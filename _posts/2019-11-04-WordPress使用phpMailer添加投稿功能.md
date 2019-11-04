---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress使用phpMailer添加投稿功能 				# 标题 
subtitle:      wordpress博客优化2015-04-11                  #副标题
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

今上午在露兜博客看到了wordpress添加投稿功能这篇文章，参照上面的代码，无论怎么配置，邮件就是发送不成功。
我依次在服务器测试了wp_mail()和mail()这两个函数。最终都没有接收到邮件。按后我想到了上次帮朋友配置phpMailer，上次使用phpMailer是可以接收到邮件的，
于是想到时候可以把phpMailer移植到这里呢？经测试，我的想法是可行的。有关phpmailer的使用方法请查看我以前写的这篇文章：phpmailer使用教程及实例演示。

下面可以开始讲解我是怎么使用phpmailer配置wordpress的投稿功能的。

+ 下载phpMailer：

phpMailer官方：<http://phpmailer.worxware.com/>，请进去下载最新版的phpMailer，或者在这里下载：[phpMailer](http://www.cnsecer.com/wp-content/uploads/2014/03/phpMailer.zip)

然后如下文件放到主题根目录的 `/inc/phpMailer`文件夹，如果没有这些文件夹，
请手动建立:”`class.phpmailer.php`”,”`class.pop3.php`”,”`class.smtp.php`”,”`PHPMailerAutolod.php`”

在主题根目录创建`tougao.php`

以下部分代码是露兜博客的了wordpress添加投稿功能，在此感谢作者的无私奉献精神。

我的模板使用bootstrap写的，所以DIV什么的可能和你的不一样，你参考下就可以了,下面是tougao.php代码（别忘了进行“初始化phpMailer”部分的参数设置）:

```
<?php
/**
* Template Name: tougao
* 作者：cnsecer
* 博客：http://www.cnsecer.com/
*
* 部分代码参考自露兜博客:http://www.ludou.org/wordpress-add-contribute-page.html
*RayJing修正偏移和布局
* 更新日志:
* 2015.04.10:使用phpMailer替换wp_mail(),解决发部分主机不能发送邮件问题..
*
*
*
*
*/
?>
<?php get_header(); ?>
<div id="content" class="widecolumn" role="main">
<?php
//初始化phpMailer
require("inc/phpMailer/PHPMailerAutoload.php"); //引入文件（把刚才解压的那些文件放到对应的路径就可以了）
$mail = new PHPMailer(); //实例化
$mail->IsSMTP(); // 启用SMTP
$mail->Host="smtp.exmail.qq.com"; //smtp服务器的名称（这里以126邮箱为例）
$mail->SMTPAuth = true; //启用smtp认证
$mail->Port = 465; //smtp端口
$mail->SMTPKeepAlive = true;
//$mail->SMTPSecure = "ssl";
$mail->Username = "rayjing@rayjing.com"; //你的邮箱名
$mail->Password = "*********"; //邮箱密码
$mail->From = "rayjing@rayjing.com"; //发件人地址（也就是你的邮箱地址）
$mail->FromName = "漫步天涯"; //发件人姓名
$mail->AddAddress("rayjing@rayjing.com","漫步天涯");
$mail->AddReplyTo("zgqdlihuiyuan@126.com", "漫步天涯"); //回复地址(可填可不填)
$mail->WordWrap = 50; //设置每行字符长度
//$mail->AddAttachment("images/01.jpg", "manu.jpg"); // 添加附件,并指定名称
$mail->IsHTML(true); // 是否HTML格式邮件
$mail->CharSet="utf-8"; //设置邮件编码

if( isset($_POST['tougao_form']) && $_POST['tougao_form'] == 'send') {
global $wpdb;
$current_url = 'http://localhost/wordpress/tougao'; // 注意修改此处的链接地址
$last_post = $wpdb->get_var("SELECT `post_date` FROM `$wpdb->posts` ORDER BY `post_date` DESC LIMIT 1");
// 博客当前最新文章发布时间与要投稿的文章至少间隔120秒。
// 可自行修改时间间隔，修改下面代码中的120即可
// 相比Cookie来验证两次投稿的时间差，读数据库的方式更加安全
if ( current_time('timestamp') - strtotime($last_post) < 10 ) {
wp_die('您投稿也太勤快了吧，先歇会儿！<a href="'.$current_url.'">点此返回</a>');
}

// 表单变量初始化
$name = isset( $_POST['tougao_authorname'] ) ? trim(htmlspecialchars($_POST['tougao_authorname'], ENT_QUOTES)) : '';
$email = isset( $_POST['tougao_authoremail'] ) ? trim(htmlspecialchars($_POST['tougao_authoremail'], ENT_QUOTES)) : '';
$blog = isset( $_POST['tougao_authorblog'] ) ? trim(htmlspecialchars($_POST['tougao_authorblog'], ENT_QUOTES)) : '';
$title = isset( $_POST['tougao_title'] ) ? trim(htmlspecialchars($_POST['tougao_title'], ENT_QUOTES)) : '';
$category = isset( $_POST['cat'] ) ? (int)$_POST['cat'] : 0;
$content = isset( $_POST['tougao_content'] ) ? trim(htmlspecialchars($_POST['tougao_content'], ENT_QUOTES)) : '';

// 表单项数据验证
if ( empty($name) || mb_strlen($name) > 20 ) {
wp_die('昵称必须填写，且长度不得超过20字。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($email) || strlen($email) > 60 || !preg_match("/^([a-z0-9+_-]+)(.[a-z0-9+_-]+)*@([a-z0-9-]+.)+[a-z]{2,6}$/ix", $email)) {
wp_die('Email必须填写，且长度不得超过60字，必须符合Email格式。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($title) || mb_strlen($title) > 100 ) {
wp_die('标题必须填写，且长度不得超过100字。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($content) || mb_strlen($content) > 15000 || mb_strlen($content) < 100) {
wp_die('内容必须填写，且长度不得超过15000字，不得少于100字。<a href="'.$current_url.'">点此返回</a>');
}

$post_content = '昵称: '.$name.'<br />Email: '.$email.'<br />blog: '.$blog.'<br />内容:<br />'.$content;

$tougao = array(
'post_title' => $title,
'post_content' => $post_content,
'post_category' => array($category)
);
// 将文章插入数据库
$status = wp_insert_post( $tougao );

$mail->Subject =$title; //邮件主题
$mail->Body .= "姓名".$name."<br />"; //邮件内容
$mail->Body .= "邮箱".$email."<br />"; //邮件内容
$mail->Body .= "博客".$blog."<br />"; //邮件内容
$mail->Body .= "分类".$category."<br />"; //邮件内容
$mail->Body .= "内容".$content."<br />"; //邮件内容
$mail->AltBody = "文件正文不支持HTML"; //邮件正文不支持HTML的备用显示

if ($status != 0) { //发送邮件

if(!$mail->Send()) { //如果邮件发送失败
echo "邮件发送失败 <p>";
echo "phpMailer 错误: " . $mail->ErrorInfo; //输出错误信息
exit();
} else {
wp_die('投稿成功！感谢您的投稿！<a href="'.$current_url.'">点此返回</a>', '投稿成功');
}

}
else {
wp_die('投稿失败！<a href="'.$current_url.'">点此返回</a>');
}
}
?>
<div class="container global">
<div class="row">
<div class="col-md-9">

<!-- 关于表单样式，请自行调整-->
<form class="ludou-tougao" method="post" action="<?php echo $_SERVER["REQUEST_URI"]; $current_user = wp_get_current_user(); ?>">
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authorname">昵&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称:*</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_login; ?>" id="tougao_authorname" name="tougao_authorname" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authoremail">E-Mail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:*</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_email; ?>" id="tougao_authoremail" name="tougao_authoremail" />
</div>

<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authorblog">您的博客&nbsp;&nbsp;:</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_url; ?>" id="tougao_authorblog" name="tougao_authorblog" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_title">文章标题:*</label>
<input type="text" size="60" value="" id="tougao_title" name="tougao_title" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougaocategorg">分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类:*</label>
<?php wp_dropdown_categories('hide_empty=0&id=tougaocategorg&show_count=1&hierarchical=1'); ?>
</div>

<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label style="vertical-align:top" for="tougao_content">文章内容:*</label>
<textarea rows="20" cols="100" id="tougao_content" name="tougao_content"></textarea>
</div>

<br clear="all">
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<input type="hidden" value="send" name="tougao_form" />
<input type="submit" value="提交" />
<input type="reset" value="重填" />
</div>
</form>
</div>
</div>
<?php get_footer(); ?>
```

**创建页面**：

进入wordpress创建页面，并选择模板“`tougao`”保存即可。然后访问`http://你的域名/tougao`，即可看到如下效果：

![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/11/04/wordpress%20tougao.png)

提交后即可接收到邮件：

**本文中的CSS已经修改好了，如果不合适还可以再修改CSS**，祝成功。


也可以不使用phpMailer发送邮件，即投稿后不发邮件提醒，上面的代码改为下面的就可以了，也不用添加inc文件夹了：

```
<?php
/**
* Template Name: tougao
* 作者：cnsecer
* 博客：http://www.cnsecer.com/
*
* 部分代码参考自露兜博客:http://www.ludou.org/wordpress-add-contribute-page.html
*RayJing修正偏移和布局
* 更新日志:
* 2015.04.10:使用phpMailer替换wp_mail(),解决发部分主机不能发送邮件问题..
*
*
*
*
*/
?>
<?php get_header(); ?>
<div id="content" class="widecolumn" role="main">
<?php
if( isset($_POST['tougao_form']) && $_POST['tougao_form'] == 'send') {
global $wpdb;
$current_url = 'http://lihuiyuan.summerhost.info/tougao'; // 注意修改此处的链接地址
$last_post = $wpdb->get_var("SELECT `post_date` FROM `$wpdb->posts` ORDER BY `post_date` DESC LIMIT 1");
// 博客当前最新文章发布时间与要投稿的文章至少间隔120秒。
// 可自行修改时间间隔，修改下面代码中的120即可
// 相比Cookie来验证两次投稿的时间差，读数据库的方式更加安全
if ( current_time('timestamp') - strtotime($last_post) < 10 ) {
wp_die('您投稿也太勤快了吧，先歇会儿！<a href="'.$current_url.'">点此返回</a>');
}

// 表单变量初始化
$name = isset( $_POST['tougao_authorname'] ) ? trim(htmlspecialchars($_POST['tougao_authorname'], ENT_QUOTES)) : '';
$email = isset( $_POST['tougao_authoremail'] ) ? trim(htmlspecialchars($_POST['tougao_authoremail'], ENT_QUOTES)) : '';
$blog = isset( $_POST['tougao_authorblog'] ) ? trim(htmlspecialchars($_POST['tougao_authorblog'], ENT_QUOTES)) : '';
$title = isset( $_POST['tougao_title'] ) ? trim(htmlspecialchars($_POST['tougao_title'], ENT_QUOTES)) : '';
$category = isset( $_POST['cat'] ) ? (int)$_POST['cat'] : 0;
$content = isset( $_POST['tougao_content'] ) ? trim(htmlspecialchars($_POST['tougao_content'], ENT_QUOTES)) : '';

// 表单项数据验证
if ( empty($name) || mb_strlen($name) > 20 ) {
wp_die('昵称必须填写，且长度不得超过20字。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($email) || strlen($email) > 60 || !preg_match("/^([a-z0-9\+_\-]+)(\.[a-z0-9\+_\-]+)*@([a-z0-9\-]+\.)+[a-z]{2,6}$/ix", $email)) {
wp_die('Email必须填写，且长度不得超过60字，必须符合Email格式。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($title) || mb_strlen($title) > 100 ) {
wp_die('标题必须填写，且长度不得超过100字。<a href="'.$current_url.'">点此返回</a>');
}

if ( empty($content) || mb_strlen($content) > 15000 || mb_strlen($content) < 50) {
wp_die('内容必须填写，且长度不得超过15000字，不得少于50字。<a href="'.$current_url.'">点此返回</a>');
}

$post_content = '昵称: '.$name.'<br />Email: '.$email.'<br />blog: '.$blog.'<br />内容:<br />'.$content;

$tougao = array(
'post_title' => $title,
'post_content' => $post_content,
'post_category' => array($category)
);
// 将文章插入数据库
$status = wp_insert_post( $tougao );
if ($status != 0) {
// 投稿成功给博主发送邮件
// somebody#example.com替换博主邮箱
// My subject替换为邮件标题，content替换为邮件内容
wp_mail("somebody#example.com","My subject","content");
wp_die('投稿成功！感谢您的投稿！<a href="'.$current_url.'">点此返回</a>', '投稿成功');
}
else {
wp_die('投稿失败！<a href="'.$current_url.'">点此返回</a>');
}
}
?>
<div class="container global">
<div class="row">
<div class="col-md-9">

<!-- 关于表单样式，请自行调整-->
<form class="ludou-tougao" method="post" action="<?php echo $_SERVER["REQUEST_URI"]; $current_user = wp_get_current_user(); ?>">
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authorname">昵&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称:*</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_login; ?>" id="tougao_authorname" name="tougao_authorname" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authoremail">E-Mail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:*</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_email; ?>" id="tougao_authoremail" name="tougao_authoremail" />
</div>

<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_authorblog">您的博客&nbsp;&nbsp;:</label>
<input type="text" size="60" value="<?php if ( 0 != $current_user->ID ) echo $current_user->user_url; ?>" id="tougao_authorblog" name="tougao_authorblog" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougao_title">文章标题:*</label>
<input type="text" size="60" value="" id="tougao_title" name="tougao_title" />
</div>
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label for="tougaocategorg">分&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类:*</label>
<?php wp_dropdown_categories('hide_empty=0&id=tougaocategorg&show_count=1&hierarchical=1'); ?>
</div>

<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label style="vertical-align:top" for="tougao_content">文章内容:*</label>
<textarea rows="20" cols="100" id="tougao_content" name="tougao_content"></textarea>
</div>

<br clear="all">
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<input type="hidden" value="send" name="tougao_form" />
<input type="submit" value="提交" />
<input type="reset" value="重填" />
</div>
</form>
</div>
</div>
<?php get_footer(); ?>
```

如果想为投稿正文的编辑框调用wordpress自带的富文本编辑器可以对上面的代码做以下更改：

把以下代码：

```
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label style="vertical-align:top" for="tougao_content">文章内容:*</label>
<textarea rows="20" cols="100" id="tougao_content" name="tougao_content"></textarea>
</div>
```

替换为：

```
<div style="text-align: left; padding: 5px 5px 10px 20px; margin: 5px 5px 1px 10px;">
<label style="vertical-align:top" for="tougao_content">文章内容:*</label>
<?php wp_editor( '', tougao_content, $settings = array('media_buttons' => false) ); ?>
</div>
```

这样就可以了！

**参考文献**：

+ [WordPress添加投稿功能](https://www.ludou.org/wordpress-add-contribute-page.html)
