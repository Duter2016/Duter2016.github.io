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

本文的方法参考了**露兜博客**的解决方案。**露兜博客**的解决方案不够完美，没有提及如何写更为常用有效的排序方式的代码，也有些关键性的信息没有提供，样式表也是需要自己进行调整和编写。漫步天涯（我的老站点）站长参考**露兜博客**的方法，在其基础上添加代码，并增加新的排序方式（如按点击量排序）的使用，完善样式表，现在已经可以完美使用。

### 一、露兜博客原文：

之前已经有不少网友问我，露兜博客首页的访客可自行选择文章排序方式的效果是怎么做的，因为之前工作都比较忙，很抱歉没有及时给这些网友答复。今天就来给大家分享这个文章排序效果的实现过程吧。

![](https://up.ludou.org/blog/wp-content/uploads/2012/05/visitor.png)

其实实现过程也比较简单，一个是构造链接，另外一个是使用[query\_posts](https://codex.wordpress.org/Function_Reference/query_posts "query_posts")来改变一下主循环就可以了。

#### 构造链接

链接主要用于传递GET参数，让PHP程序知道你到底想怎么排序。在主题的index.php中你需要的位置插入以下代码，用于输出排序按钮的HTML，这个排序按钮的样式，你再自己写写css咯。需要注意的是以下代码会自动获取当前用户已选择的排序方式，并给这个排序按钮的 `li `添加了`class=”current”`：

```
<h4>文章排序</h4>
<ul>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='rand') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=rand" rel="nofollow">随机阅读</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='commented') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=commented" rel="nofollow">评论最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='alpha') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=alpha" rel="nofollow">标题排序</a></li>
</ul>
```

露兜博客原站的整体代码为（漫步天涯添加）：

```
<div class="sort">
<div class="sort_by">
<h4>文章排序</h4>
<ul>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='commented') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=commented" rel="nofollow">评论最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='rand') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=rand" rel="nofollow">随机阅读</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='alpha') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=alpha" rel="nofollow">标题排序</a></li>
<li><a href="http://lihuiyuan.summerhost.info">时间排序</a></li>
</ul>
</div>
<h4>欢迎来到</h4>
<h1>漫步天涯</h1>
<p>
"这里是对你的个人博客的简介，注意修改这里时，不要把双引号删掉了！"
</p>
<div class="fixed"></div>
</div>
```

#### 改变主循环

首先你得先在主题的index.php中找到以下语句：

`if (have_posts())`

然后在这句之前添加以下代码：

```
if ( isset($_GET['order']) )
{
switch ($_GET['order'])
{
case 'rand' : $orderby = 'rand'; break;
case 'commented' : $orderby = 'comment_count'; break;
case 'alpha' : $orderby = 'title'; break;
default : $orderby = 'title';
}
global $wp_query;
$args= array('orderby' => $orderby, 'order' => 'DESC');
$arms = array_merge($args, $wp_query->query);
query_posts($arms);
}
if (have_posts())
```

根据orderby的值不同，可以让文章按照很多种方式进行排序，下面是列举几个常见的值及其对应的排序方式:

```
title：按标题；
date：按发布日期；
modified：按修改时间；
ID：按文章ID；
rand：随机排序；
comment\_count：按评论数
```

好了，就这么简单，复制粘贴，轻轻松松实现排序效果，你…懂了吗？

**PS**.通过页面元素检查发现了露兜博客原站使用的css样式表内容如下（大家可根据自身情况调整一下）：

```
.sort, .post .content .sorting{background:#f9f9f9;border:1px solid #DFDFDF;margin:15px auto 39px;padding:20px 10px;}
.sort h4{color:#999;font-size:.875em;font-weight:400;letter-spacing:0;margin-bottom:5px}
.sort h1{color:#4A4A4A;letter-spacing:0;line-height:1.1em;margin-top:0;border:none;font-size:2em;padding:0}
.sort p{text-indent:2em;line-height:22px;padding:10px 0 0;font-size:0.875em}
.post .content .sorting p{margin-bottom:0;line-height:22px;padding:10px 0 0}
.sort_by{float:right}
.sort_by li{display:block;float:left;font-size:.75em;line-height:18px}
.sort_by li a{border:1px solid #b3b3b3;background:#e6e6e6;display:block;margin:2px 4px 0 0;padding:2px 8px 3px}
.sort_by li a:hover,.sort_by li a.current{color:#fff!important;background-color:#890000;border-color:#890000}
```

### 二、漫步天涯本站原创部分

> 以下内容是本站根据自身情况调整的代码！并且分别给网站整体和分类目录添加文章排序方式！

![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/11/04/wordpress_paixu.png)

#### (1)给网站整体添加文章排序方式

##### 构造链接

链接主要用于传递GET参数，让PHP程序知道你到底想怎么排序。在主题的index.php中你需要的位置插入以下代码，用于输出排序按钮的HTML，这个排序按钮的样式，你再自己写写css咯。需要注意的是以下代码会自动获取当前用户已选择的排序方式，并给这个排序按钮的 `li` 添加了`class=”current”`：

```
<div class="sort">
<div class="sort_by">
<ul>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='hot') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=hot" rel="nofollow">点击最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='modified') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=modified" rel="nofollow">最后修改</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='commented') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=commented" rel="nofollow">评论最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='rand') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=rand" rel="nofollow">随机阅读</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='alpha') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=alpha" rel="nofollow">标题排序</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='date') ) echo 'class="current"'; ?> href="<?php echo get_option('home'); ?>/?order=date" rel="nofollow">时间排序</a></li>
</ul>
</div>
</div>
```

**注意**：“点击最多”这个排序方式我把它命名为hot，依据的排序变量是views，但是这个变量views在wrodpress主程序中是不存在的，views是之前我添加文章题目下面显示点击次数时，在使用的主体中添加的功能和函数（具体见《[WordPress代码添加文章浏览次数和热门文章](https://duter2016.github.io/2019/11/04/WordPress%E4%BB%A3%E7%A0%81%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E6%B5%8F%E8%A7%88%E6%AC%A1%E6%95%B0%E5%92%8C%E7%83%AD%E9%97%A8%E6%96%87%E7%AB%A0/)》）；其他的几个变量
`“title：按标题；date：按发布日期；modified：按修改时间；ID：按文章ID；rand：随机排序；comment\_count：按评论数”`
在wordpress主程序中都是原本就存在的。当你需要添加这个“点击最多”排序方式时，需要在上面的“**改变主循环**”代码：

`$args= array('orderby' => $orderby, 'order' => 'DESC');`

添加“`’meta\_key’ => ‘views’,`”才可以，即改为：

`$args= array('meta_key' => 'views', 'orderby' => $orderby, 'order' => 'DESC');`

相应的，“改变主循环”的整体代码改为如下文所述的形式。

##### 改变主循环

首先你得先在主题的index.php中找到以下语句：

`if (have_posts())`

然后在这句之前添加以下代码：

```
if ( isset($_GET['order']) )
{
switch ($_GET['order'])
{
case 'hot' : $orderby = 'views'; break;
case 'rand' : $orderby = 'rand'; break;
case 'modified' : $orderby = 'modified'; break;
case 'commented' : $orderby = 'comment_count'; break;
case 'date' : $orderby = 'date'; break;
case 'alpha' : $orderby = 'title'; break;
default : $orderby = 'title';
}
global $wp_query;
$args= array('meta_key' => 'views', 'orderby' => $orderby, 'order' => 'DESC');
$arms = array_merge($args, $wp_query->query);
query_posts($arms);
}
if (have_posts())
```

##### 修改样式表

在本站使用中，主题的style.css中，第一次使用的灰色背景色的，添加以下代码：

```
.sort, .post .content .sorting{background:#f9f9f9;border:1px solid #DFDFDF;margin:15px 15px auto 15px;padding:10px 10px 38px 10px;}
.post .content .sorting p{margin-bottom:0;line-height:22px;padding:10px 0 0}
.sort_by{float:left;position:relative;left:14.1%;}
.sort_by li{display:block;float:left;font-size:.75em;line-height:18px}
.sort_by li a{border:1px solid #b3b3b3;background:#e6e6e6;display:block;margin:2px 4px 0 0;padding:2px 8px 3px}
.sort_by li a:hover,.sort_by li a.current{color:#fff!important;background-color:#890000;border-color:#890000}
```

后来把样式的背景改为白色，并调小上下空白间距后，改为了以下代码：

```
.sort, .post .content .sorting{background:#ffffff;border:1px solid #DFDFDF;margin:5px 15px 5px 15px;padding:4px 10px 33px 10px;}
.post .content .sorting p{margin-bottom:0;line-height:22px;padding:10px 0 0}
.sort_by{float:left;position:relative;left:14.1%;}
.sort_by li{display:block;float:left;font-size:.75em;line-height:18px}
.sort_by li a{border:1px solid #b3b3b3;background:#e6e6e6;display:block;margin:2px 4px 0 0;padding:2px 8px 3px}
.sort_by li a:hover,.sort_by li a.current{color:#fff!important;background-color:#890000;border-color:#890000}
```

一切OK，干的漂亮！

#### (2)给各个分类目录添加文章排序方式

分类目录的添加的代码，仅位置和构造链接部分代码与整体的有差别。代码部分，要用以下代码：

`href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=hot"`

替换掉整体的构造链接部分的以下代码：

`href="<?php echo get_option('home'); ?>/?order=hot"`

具体操作如下文所述。

##### 构造链接

链接主要用于传递GET参数，让PHP程序知道你到底想怎么排序。在主题的archive.php中你需要的位置插入以下代码，用于输出排序按钮的HTML，这个排序按钮的样式，使用上面写的整体的css。需要注意的是以下代码会自动获取当前用户已选择的排序方式，并给这个排序按钮的 li 添加了`class=”current”`。本站主体选择在`<div id=”content” class=”list-content”>`下方添加以下代码：

```
<div class="sort">
<div class="sort_by">
<ul>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='hot') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=hot" rel="nofollow">点击最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='modified') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=modified" rel="nofollow">最后修改</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='commented') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=commented" rel="nofollow">评论最多</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='rand') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=rand" rel="nofollow">随机阅读</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='alpha') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=alpha" rel="nofollow">标题排序</a></li>
<li><a <?php if ( isset($_GET['order']) && ($_GET['order']=='date') ) echo 'class="current"'; ?> href="<?php $link = esc_url( get_category_link( get_query_var('cat') ) ); echo trim($link, '/'); ?>?&amp;order=date" rel="nofollow">时间排序</a></li>
</ul>
</div>
</div>
```

##### 改变主循环

首先你得先在主题的archive.php中找到以下语句：

`if (have_posts())`

然后在这句之前添加以下代码：

```
if ( isset($_GET['order']) )
{
switch ($_GET['order'])
{
case 'hot' : $orderby = 'views'; break;
case 'rand' : $orderby = 'rand'; break;
case 'modified' : $orderby = 'modified'; break;
case 'commented' : $orderby = 'comment_count'; break;
case 'date' : $orderby = 'date'; break;
case 'alpha' : $orderby = 'title'; break;
default : $orderby = 'title';
}
global $wp_query;
$args= array('meta_key' => 'views', 'orderby' => $orderby, 'order' => 'DESC');
$arms = array_merge($args, $wp_query->query);
query_posts($arms);
}
if (have_posts())
```

##### 修改样式表

分类目录的样式表使用上文提到的在主题的style.css中添加的样式代码就可以了。
