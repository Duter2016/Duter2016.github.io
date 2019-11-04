---
layout:     post   				    # 使用的布局（不需要改）
title:      给WordPress添加验证码解决垃圾评论的方法 				# 标题 
subtitle:      wordpress博客优化2015-04-09                  #副标题
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

WordPress虽然功能非常之强大，但是有很多的功能是没有实现的，好多的站长朋友的站点只要开启了评论的，但是呢没有过多久数据库就爆满了，被不法人员刷了评论，为了防止这样的垃圾评论，我们只有添加验证码才能解决这个问题，好了也不用多说什么废话了，下面就看看怎么去做到这一步的吧！

1、首先我们要解决这样的问题，我们就要想想在哪里找到这样的问题，怎么去添加，那么就需要找到评论那个页面的地方去添加相应的代码，既然这样那么我们就需要看看wordpress开发技术文档了。

2、**wordpress4.3.1及以下版本**修改`wordpress主目录`下面的`wp-comments-post.php`文件，在`if ( ” == $comment_content )`前面加入如下代码：

```
if ( !$user->ID ) {
$a = trim($_POST[a]);
$b = trim($_POST[b]);
$result = trim($_POST[result]);
if ((($a+$b)!=$result)|| empty($result)){
wp_die( __('验证码输入不正确，请返回重新输入验证码再提交留言！') );
}
}
```

**wordpress 4.4及以上版本**中，`wordpress主目录`下面的`wp-comments-post.php`文件，和`wp-includes目录`下的`comment.php`文件都发生改变，原本`wordpress主目录`下面的`wp-comments-post.php`文件里`if ( ” == $comment_content )`相关代码转移到了`wp-includes目录`下的`comment.php`文件中。另外，wordpress 4.4中把以前版本中的`wp_die`改为了`WP_Error`（这一项不需要修改），此时，如果再修改的话需要修改`wp-includes目录`下的`comment.php`文件，在`if ( ” == $comment_content )`前面加入如下代码：

```
if ( !$user->ID ) {
$a = trim($_POST[a]);
$b = trim($_POST[b]);
$result = trim($_POST[result]);
if ((($a+$b)!=$result)|| empty($result)){
wp_die( __('验证码输入不正确，请返回重新输入验证码再提交留言！') );
}
}
```

3、**wordpress4.3.1及以下版本**用户，修改`wordpress主题目录`下面的`comments.php`文件，在提交按钮前面加上如下代码：

```
<?php $a=rand(0,10); $b=rand(0,10); ?>
<p><br></p><p><input type="text" name="result" id="result" size="22" tabindex="5" />
<input type="hidden" value="<?php echo $a ?>" name="a" />
<input type="hidden" value="<?php echo $b ?>" name="b" />
<small>验证码</small><label style=”background:#ff0000; color:#ffffff;”>Code (<?php echo $a ?>+<?php echo $b ?>=?)</label></p>
```

**wordpress4.4及以上版本**用户，修改`wordpress主题目录`下面的`comments.php`文件，在提交按钮前面加上如下代码：

```
<?php $a=rand(0,10); $b=rand(0,10); ?>
<p><br></p><p><input type="text" name="result" id="result" size="22" tabindex="5" onblur="if(this.value == '')this.value='登录用户无需填写';"
onclick="if(this.value == '登录用户无需填写')this.value='';" value="登录用户无需填写" />
<input type="hidden" value="<?php echo $a ?>" name="a" />
<input type="hidden" value="<?php echo $b ?>" name="b" />
<small>验证码</small><label style=”background:#ff0000; color:#ffffff;”>Code (<?php echo $a ?>+<?php echo $b ?>=?)</label></p>
```

这样就可以了。

**注**：wordpress 4.4中经过修改后，验证码对于登陆的用户评论时是不起作用的，而对于没有登录的游客可以起作用。网上的其他通过functions.php添加验证码方法已经失效无法使用，另外网上的很多文章里的相关代码都存在错误。
