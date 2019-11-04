---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress投稿功能添加富文本编辑器KindEditor 				# 标题 
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


在N年前，我写了一篇教程：[WordPress添加投稿功能](http://www.ludou.org/wordpress-add-contribute-page.html "WordPress添加投稿功能")，这篇教程目前的点击率已经快接近9000了，算是露兜博客最火的一篇文章了。这篇教程从发布到现在，不知道改过多少遍了，也不断收到读者各方面的需求，我也在留言中给他们一一回复了，所以文章中找不到你想要的东西，可以看看留言。

鉴于留言中我已经给很多读者指导怎么修改代码，如果现在再去修改文章中的代码，势必会导致代码所在行数的变化，等于毁了我之前给读者的所有回复。最近一段时间，我将再写几篇文章，告诉你怎么增强这个投稿功能。今天要讲的是如何给这个投稿功能添加一个富文本编辑器（也包括了图片上传功能），原来的代码只能实现一个简单的纯文本输入框，对于投稿者的输入体验不太好。效果见露兜博客的投稿页面：[我要投稿](http://www.ludou.org/ask-a-question "我要投稿")

### 一、下载KindEditor

这里我们将使用KindEditor来作为我们的编辑器，[点此下载KindEditor](http://www.kindsoft.net/down.php "KindEditor")。下载后解压，将文件夹重命名为kindeditor，放到你当前主题文件夹下。

### 二、修改HTML页面

打开[WordPress添加投稿功能](http://www.ludou.org/wordpress-add-contribute-page.html "WordPress添加投稿功能")，下面我们将对这篇文章中的代码进行修改。

将代码一中第41行的`</form>`改成：

```
</form>
<script charset="utf-8" src="<?php bloginfo('template_url'); ?>/kindeditor/kindeditor-min.js"></script>
<script charset="utf-8" src="<?php bloginfo('template_url'); ?>/kindeditor/lang/zh_CN.js"></script>
<script>
/* 编辑器初始化代码 start */
var editor;
KindEditor.ready(function(K) {
editor = K.create('#tougao_content', {
resizeType : 1,
allowPreviewEmoticons : false,
allowImageUpload : true, /* 开启图片上传功能，不需要就将true改成false */
items : [
'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
'insertunorderedlist', '|', 'emoticons', 'image', 'link']
});
});
/* 编辑器初始化代码 end */
</script>
```

### 三、php代码小修改

代码二第43行代码：

`$content = isset( $_POST['tougao_content'] ) ? trim(htmlspecialchars($_POST['tougao_content'], ENT_QUOTES)) : '';`

改成：

```
$content = isset( $_POST['tougao_content'] ) ? trim($_POST['tougao_content']) : '';
$content = str_ireplace('?>', '?&gt;', $content);
$content = str_ireplace('<?', '&lt;?', $content);
$content = str_ireplace('<script', '&lt;script', $content);
$content = str_ireplace('<a ', '<a rel="external nofollow" ', $content);
```

### 四、自定义编辑器功能

经过以上三步的修改，目前你的编辑器就可以正常使用了。但是对不同人来说，他们的需求可能不太一样，有人可能会觉得上面的编辑器太过简单。那么怎样自定义编辑器的功能呢？这里我就不讲编程了，简单点就找编辑器自带的样例来说就行了。

我们下载的kindeditor目录下有个examples文件夹，这里是部分演示，双击打开index.html可以看到所有演示。你是否看中某个演示呢？那就用文本编辑器打开它的html文件，查看里面的代码。这些html文件的代码中都可以看到类似代码：

```
<script charset="utf-8" src="../kindeditor-min.js"></script>
<script charset="utf-8" src="../lang/zh_CN.js"></script>
<script>
... 编辑器初始化代码
</script><script charset="utf-8" src="../kindeditor-min.js"></script>
<script charset="utf-8" src="../lang/zh_CN.js"></script>
<script>
... 编辑器初始化代码
</script>
```

将以上代码中 **编辑器初始化代码** 那部分代码替换第三步中的编辑器初始化代码，然后将 ‘`textarea\[name=”content”\]`’ ，改成 ‘`#tougao\_content`’ 即可。

好了，添加个编辑器就是这么简单。如果你会编程，或者懂看文档，动手能力强，可以看看KindEditor的文档，自己动手玩玩：[KindEditor文档](http://www.kindsoft.net/doc.php "KindEditor文档")

**本文转载自**：

+ 《[WordPress投稿功能添加富文本编辑器](https://www.ludou.org/tougao-text-editor.html)》
