---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress侧边栏最新评论「直接显示评论内容」 				# 标题 
subtitle:      wordpress博客优化2015-04-26                  #副标题
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

WordPress侧边栏自带的最新评论功能太简陋了，不符合实际使用要求。

### 具体问题如下：

1）所有留言的具体内容都不会显示出来。默认显示格式为：`“读者ID”+“在”+“具体文章名”+“上的评论”`。

2）作者（站长）自己的留言也会显示出来。这样一来，当作者连续回复时，最新评论就都是作者自己的留言了，这个模块就丧失了其应有的功能。

针对以上两个问题，处理方法也不少，有使用插件的（如WP-RecentComments），也有修改代码的。不太复杂的改动尽量不使用插件，以免拖累网站运行速度。因此，本文将介绍如何通过修改代码来解决以上问题。

### 改进方法

### 1）让最新留言的具体内容直接显示出来

进入你的网站根目录，在WordPress源程序文件夹中的`/wp-includes/widgets/`路径下找到`class-wp-widget-recent-comments.php`，打开编辑之。

搜索到以下代码片段：

```
foreach ( (array) $comments as $comment) {
$output .=  ‘<li>’ . /* translators: comments widget: 1: comment author, 2: post link */ sprintf(_x(‘%1$s on %2$s’, ‘widgets’), get_comment_author_link(), ‘<a href=”‘ . esc_url( get_comment_link($comment->comment_ID) ) . ‘”>’ . get_the_title($comment->comment_post_ID) . ‘</a>’) . ‘</li>';
}
```

#### 修改步骤一:

把`(_x(‘%1$s on %2$s’, ‘widgets’)`里面的这个单词“`on`”改成冒号“`:`”(英文标点)，即


`( _x( '%1$s : %2$s', 'widgets' )`

#### 修改步骤二：

把`get_the_title($comment->comment_post_ID)`改为


`mb_strimwidth(strip_tags($comment->comment_content),0,80,······)`


这里的数字“`80`”是用来限制评论显示的字数（一个汉字是2个字符），可以自行修改，至于后边那个小尾巴”`······`”则是用来在实际评论字数少于允许显示的字数时补充空白处的，也可以依自己喜欢的格式修改之。

以上修改完成后，最新评论的格式就变为：`“读者ID”+”：”+“实际评论内容”`。

### 2）让最新评论不显示作者自己的评论

修改对象依然是上面提到的default-widgets.php文件。

搜索到以下代码片段：

```
$comments = get_comments( apply_filters( 'widget_comments_args', array( 'number' => $number, 'status' => 'approve', 'post_status' => 'publish' ) ) );
```

修改为以下格式：

```
$comments = get_comments( apply_filters( 'widget_comments_args', array( 'number' => $number, 'status' => 'approve', 'post_status' => 'publish', 'type' => 'comment', 'user_id' => 0 ) ) );
```

解释一下：`’user_id’ => 0`效果为不显示站长自己的回复，`’type’ => ‘comment’`效果为只显示评论类留言，即，不显示pingback和trackback类留言。

**参考文献**:

+ [Type My Life](http://www.typemylife.com/wordpress-recent-comments-remove-author-name-display-content/)
