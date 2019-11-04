---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress自定义栏目「添加文章来源」 				# 标题 
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

WordPress 的自定义栏目是一个非常强大的功能，借助它，你的WordPress 站点不仅仅可以是博客，也可以是购物店，企业站，CMS等等。如果你对WordPress的自定义栏目还不够了解，
建议你先去WordPress官方文档“[自定义栏目](http://codex.wordpress.org/zh-cn:%E8%87%AA%E5%AE%9A%E4%B9%89%E6%A0%8F%E7%9B%AE)”了解相关内容。多说一句，如果你想对WordPress 了解更深，最好多去WordPress官方文档那里泡泡，在那里你会学到很多；
虽然不少文档是英文，但基本上读过高中的都能大概理解。

下面就由Jeff为大家带来自定义栏目运用实例之一：添加文章来源。

你可以看到在devewor.com的每篇文章下面都有个 **来源：xxx** 的说明，这个就是用自定义栏目来实现的。先给出核心代码先（代码放到该显示的地方）：

### 添加文章来源核心代码

```
<?php 
     $form = get_post_meta($post->ID, 'from', true);
     $fromurl = get_post_meta($post->ID, 'fromurl', true);
     if($from){
        echo '来源：'."<a href='$fromurl' target='blank' rel='nofllow'>$from</a>";}
        else echo '来源：'."原创"
?>
```

基本上你能看懂吧，就是先定义from、fromurl这两个自定义字符，如果from或fromurl存在（后台有输入内容），
那么就输出输入的内容；如果没有输入内容，则默认是输出“`来源：原创`”；`from 输入来源的地方；fromurl输入来源url`。

### 怎么用？

> Note:
>> 自WordPressversion 3.1起,默认情况下自定义栏目已经隐藏,您可以通过管理面板写文章和页面编辑的显示选项中勾选自定义栏目打开它。

怎么用很清楚了，以谋篇文章来源于Jeff的阳台为例：

怎么用很清楚了，以谋篇文章来源于Jeff的阳台为例：在后台写文章的时候，第一次需要在编辑页面【输入新栏目】，名称为`from`，值为`Jeff的阳台`；再【输入新栏目】，名称为 `fromurl`，值为 `http://www.jianhui.org` 。这样在前台相关地方就会出现链接到`http://www.jianhui.org`的`Jeff的阳台`字样。

**PS**.
自从WordPress 3.4.2 版后出现了添加自定义栏目按钮失效的现象，即点击过添加自定义栏目后，添加的自定义栏目不能立即显示，在保存草稿或发布后才显示。这个bug到4.1版本还存在！知更鸟网站上贴出来了[插件解决办法](http://zmingcx.com/wordpress-3-4-2-custom-section-bug.html)，但是最好别用，有副作用，可能会导致进不去后台！**本站建议采用“不是办法的办法”的临时解决方法**：`添加一次自定义栏目，保存一次草稿，然后再添加另一个自定义栏目`。这样也可以的。

**参考文献**：

+ 《[DeveWork](http://devework.com/wordpress-custom-fields-for-instance-source.html)》
