---
layout:     post   				    # 使用的布局（不需要改）
title:      给wordpress添加评论回复发邮件通知功能 				# 标题 
subtitle:      wordpress博客优化2015-04-15                  #副标题
date:       2019-11-04 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-ioses.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - WordPress
---

wordpress在线网站，是支持mail()函数，点击忘记密码，输入邮件后，是可以发送相应的重置密码的邮件的。只是本地的localhost不支持mail()函数。因此，按照此思路，在评论中使用邮件回复功能也是应该可以的。

找到所使用的主题中的functions.php文件，在`<?php`和`?>`中间添加以下代码：

```
// 评论邮件回复END
/*
comment_mail_notify v1.0 by willin kan. (有勾选栏, 由访客决定)
updated by crifan li, 20120803:
add post perma link for post title
changed some text notification
*/
function comment_mail_notify($comment_id) {
$admin_notify = '1'; // admin要不要收回复通知( '1'=要; '0'=不要)
$admin_email = get_bloginfo ('admin_email'); // $admin_email可改为你指定的e-mail.
$comment = get_comment($comment_id);
$comment_author_email = trim($comment->comment_author_email);
$parent_id = $comment->comment_parent ? $comment->comment_parent : '';
$postId = $comment->comment_post_ID;
$postPermaLink = esc_url(get_permalink($postId));
global $wpdb;
if ($wpdb->query("Describe {$wpdb->comments} comment_mail_notify") == '')
$wpdb->query("ALTER TABLE {$wpdb->comments} ADD COLUMN comment_mail_notify TINYINT NOT NULL DEFAULT 0;");
if (($comment_author_email != $admin_email && isset($_POST['comment_mail_notify'])) || ($comment_author_email == $admin_email && $admin_notify == '1'))
$wpdb->query("UPDATE {$wpdb->comments} SET comment_mail_notify='1' WHERE comment_ID='$comment_id'");
$notify = $parent_id ? get_comment($parent_id)->comment_mail_notify : '0';
$spam_confirmed = $comment->comment_approved;
if ($parent_id != '' && $spam_confirmed != 'spam' && $notify == '1') {
$wp_email = 'no-reply@' . preg_replace('#^www\.#', '', strtolower($_SERVER['SERVER_NAME'])); // e-mail发出点, no-reply可改为可用的e-mail.
$to = trim(get_comment($parent_id)->comment_author_email); // 以下属于邮件模板
$subject = '您在[' . get_option("blogname") . ']的留言有了回应';
$message = '
<div style="background-color:#eef2fa; border:1px solid #d8e3e8; color:#111; padding:0 15px; -moz-border-radius:5px; -webkit-border-radius:5px; -khtml- border-radius:5px; border-radius:5px;">
<p>' . trim(get_comment($parent_id)->comment_author) . ', 您好!</p>
<p>您曾在《<a href="' . $postPermaLink . '">'. get_the_title($comment->comment_post_ID) . '</a>》的留言:<br />'
. trim(get_comment($parent_id)->comment_content) . '</p>
<p>' . trim($comment->comment_author) . '给您的回应:<br />'
. trim($comment->comment_content) . '<br /></p>
<p>您可以点击<a href="' . htmlspecialchars(get_comment_link($parent_id, array('type' => 'comment'))) . '"> 查看完整的回复内容</a></p>
<p>欢迎再度光临 <a href="' . get_option('home') . '">' . get_option('blogname') . '</a></p>
<p>(此邮件由系统自动发出, 请勿回复.)</p>
</div>'; // 以上属于邮件模板
$from = "From: \"" . get_option('blogname') . "\" <$wp_email>";
$headers = "$from\nContent-Type: text/html; charset=" . get_option('blog_charset') . "\n";
wp_mail( $to, $subject, $message, $headers );
//echo 'mail to ', $to, '<br/> ' , $subject, $message; // for testing
}
}
add_action('comment_post', 'comment_mail_notify');

/* 自动加勾选栏*/
function add_checkbox() {
echo '<input type="checkbox" name="comment_mail_notify" id="comment_mail_notify" value="comment_mail_notify" checked="checked" style="margin-left:20px;" /><label for="comment_mail_notify">有人回复时邮件通知我</label>';
}
add_action('comment_form', 'add_checkbox');

// 评论邮件回复END

```

然后刷新了某个页面，点击回复评论，就可以在评论框下面看到一个勾选上的文字“有人回复时邮件通知我”，效果如图：

![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/11/04/mailofcomments.png)
