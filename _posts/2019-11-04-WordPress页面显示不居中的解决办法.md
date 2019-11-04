---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress页面显示不居中的解决办法 				# 标题 
subtitle:      wordpress博客优化2015-05-04                  #副标题
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

在wordpress制作网站的过程中，偶尔会出现整体页面在屏幕上居左显示（不是文字居左）的问题，或者是首页显示正常居中显示，但是内页（如文章归档页面）却居左显示。遇到这种现象可以参考以下方法决绝：

### 一、使用自动外边距实现居中

在使用的主题中找到`style.css`或者`default.css`文件，在里面找到body样式，将body的样式添加如下样式：

`body { margin:0 auto;}`

### 二、负外边距解决方案

有时，有的主体在使用上面的方法并不能解决问题，仍会有页面不能正常居中显示。在上面无法解决的时候，可以考虑采用这个第二个方法，当然还是优先使用第一个方法。

负外边距解决方案远不是仅仅为元素添加负外边距这么简单。这种方法需要同时使用绝对定位和负外边距两种技巧。

如果要实现整体页面居中，在使用的主题中找到style.css或者default.css文件，在里面找到body样式，将body的样式添加如下样式：

```
body { position:absolute; left:50%; width:960px; margin-left:-480px; }
```

或者

```
body {margin:0px auto 0px -480px; position:absolute; left:50%; width:960px; }
```

上面的两个效果在大部分主体中效果是一样的，只有上下边距的差别。下面对这个代码进行一下解释：

```
body {
    position:absolute;
    left:50%;
    width:960px; /*你的实际页面的宽度*/  
    margin-left: -480px; /*480为整体width(这里是960)的一半*/
}
```

这是使用绝对定位和负margin值实现的。

`left:50%` 会让整个body容器从浏览器水平方向的中点开始往右显示，此时浏览器左边的一半是空的。

然后设置`margin-left`为body容器的一半，设置为负值是让容器能再向左移动，也就是将整个容器从浏览器中点往左边挪动它（body容器）本身的一半。
这样body容器刚好就能够左右居中显示了。

同理，上下居中显示的原理一样：先`top：50%`让容器从垂直方向的中点向下显示，上面空出一半。然后再向上移动body容器的一半，使之垂直居中：

```
body {
    position:absolute;
    left:50%;
    top:50%;
    width:960px; /*你的实际页面的宽度*/
    margin-top:-270px; 
    margin-left: -480px; /*480为整体width(这里是960)的一半*/
}
```

这样子的实现基本兼容所有浏览器（测试通过了chrome firefox ie7-11）！
