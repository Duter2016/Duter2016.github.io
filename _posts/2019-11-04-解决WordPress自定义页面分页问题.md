---
layout:     post   				    # 使用的布局（不需要改）
title:      解决WordPress自定义页面分页问题 				# 标题 
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

wordpress页面分页功能有很多，插件也有很多，但是自定义页面的分页会让很多wordpress使用者感到苦恼，因为一些自定义页面函数使用问题，网络上的自定义输出文章的代码都是只考虑了功能的实现，却没有为其它功能的兼容性考虑清楚，纵使现在很多人问我这种页面输出文章后怎么分页啊。博客首页的分页代码完全没有用，点来点去都是第一页的问题。

现在我跟着网上的思路试来试去，终于解决了，现在把方法交给大家，而不止是代码，搜索了一番，网上也有少量类似的结果，但是他们都是针对自己的主题直接给出代码，如果不是用他们主题的人是用不了的。

传统的自定义页面输出文章的代码是

`<?php query_posts();if (have_posts()) : while (have_posts()) : the_post(); ?>`

这正是造成自定义页面无法分页关键因素，如果要实现分页，这段代码是有bug的，所以我们应该替换成：

```
<?php $limit = get_option('posts_per_page');$paged = (get_query_var('paged')) ? get_query_var('paged') : 1;
query_posts();if (have_posts()) : while (have_posts()) : the_post(); ?>
```

按照这种输出格式就能完美解决自定义页面分页功能了，但是实际的自定义页面是有参数设置的，所以带参数的代码我拿个例子来说一下，比如：

`<?php query_posts("post_type=shuoshuo&post_status=publish&posts_per_page=100");if (have_posts()) : while (have_posts()) : the_post(); ?>`

则正确地能分页的代码是：

```
<?php $limit = get_option('posts_per_page');
$paged = (get_query_var('paged')) ? get_query_var('paged') : 1;
query_posts('post_type=shuoshuo&post_status=publish&showposts=' . $limit=10 . '&paged=' . $paged);
if (have_posts()) : while (have_posts()) : the_post(); ?>
```

看了这个例子大家应该知道怎么做了，修改红色部分的代码为自己主题的输出参数就行了。

到此为止并没有结束，自定义页面要分页肯定要分页代码函数啊，所以要在自定义页面中调用分页函数，如果不知道自己的主题的分页函数是什么，可以到index.php里面查看。形同`<?php pagination($query\_string); ?>`，如果你的主题也是这个分页函数，那就百分之百能成功，因为不同的分页函数调用情况可能不一样，
如果你直接写`<?php pagination($query\_string); ?>`是调不出来的，需要修改成`<?php pagination($query); ?>`这样才能把分页调出来。我不知道其它的翻页函数如何，没有试过，也许不用修改分页函数就能用，也许修改了也用不了，为了避免其它分页函数用不了的情况，特放出本站所使用的分页功能函数，如果真不行可以把你的主题的分页函数修改成百家网络博客的分页功能函数，其方法在下一篇文章放出来。点击这里：[WordPress分页功能函数](http://www.wuover.com/228.html)，demo可以到这个页面观看：[秋叶的说说](http://www.wuover.com/shuo)。

**补充**：

我这种方法其实质是调用了博客首页的分页数字链接，其是有效的，但是我发现如果首页有9页的话，而你的自定义页面有8页的话，那么自定义页面的第9页将会显示空白，这是一个小bug，如果不在乎的话可以忽略，另外如果看不惯这个bug的话，还有一种调用方法，就是用wp的内置函数上一页下一页两个按钮调用，代码如下：

`<?php if (function_exists('wp_pagenavi')) wp_pagenavi();else { ?><div><?php previous_posts_link('【« 上一页】') ?>     <?php next_posts_link('【下一页 »】') ?></div><?php } ?>`

这个方法不会出现空白页，但是没有翻页数字，请自行决定使用哪个方法。
