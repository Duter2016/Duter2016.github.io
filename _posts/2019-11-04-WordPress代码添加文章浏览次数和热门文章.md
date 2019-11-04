---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress代码添加文章浏览次数和热门文章 				# 标题 
subtitle:      wordpress博客优化2015-04-14                  #副标题
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

WordPress文章浏览次数统计功能是必不可少的，不少主题已经集成该功能，如果你的主题没有集成，你可以使用 [WP-Postviews](http://www.wpdaxue.com/wp-postviews.html) 插件，或者试试本文的代码。

WordPress非插件实现文章浏览次数统计的方法，是DH参考willin kan大师的my\_visitor插件来写的，刷新一次文章页面就统计一次，比较简单实用。

### 非插件统计文章浏览次数

1.在主题的 functions.php文件的最后一个 `?>` 前面添加下面的代码：

```
/* 访问计数 */
function record_visitors()
{
if (is_singular())
{
global $post;
$post_ID = $post->ID;
if($post_ID)
{
$post_views = (int)get_post_meta($post_ID, 'views', true);
if(!update_post_meta($post_ID, 'views', ($post_views+1)))
{
add_post_meta($post_ID, 'views', 1, true);
}
}
}
}
add_action('wp_head', 'record_visitors');

/// 函数名称：post_views
/// 函数作用：取得文章的阅读次数
function post_views($before = '(点击 ', $after = ' 次)', $echo = 1)
{
global $post;
$post_ID = $post->ID;
$views = (int)get_post_meta($post_ID, 'views', true);
if ($echo) echo $before, number_format($views), $after;
else return $views;
}
```

2.在使用的主题的single.php文件中，需要显示该统计次数的地方使用下面的代码调用：

`<?php post_views('点击：', ' 次'); ?>`

### 获取浏览次数最多的文章

如果要获取上面的函数统计出来的浏览次数最多的文章，可以在 functions.php文件的最后一个 `?>` 前面添加下面的代码：

```
/// get_most_viewed_format
/// 函数作用：取得阅读最多的文章
function get_most_viewed_format($mode = '', $limit = 10, $show_date = 0, $term_id = 0, $beforetitle= '(', $aftertitle = ')', $beforedate= '(', $afterdate = ')', $beforecount= '(', $aftercount = ')') {
global $wpdb, $post;
$output = '';
$mode = ($mode == '') ? 'post' : $mode;
$type_sql = ($mode != 'both') ? "AND post_type='$mode'" : '';
$term_sql = (is_array($term_id)) ? "AND $wpdb->term_taxonomy.term_id IN (" . join(',', $term_id) . ')' : ($term_id != 0 ? "AND $wpdb->term_taxonomy.term_id = $term_id" : '');
$term_sql.= $term_id ? " AND $wpdb->term_taxonomy.taxonomy != 'link_category'" : '';
$inr_join = $term_id ? "INNER JOIN $wpdb->term_relationships ON ($wpdb->posts.ID = $wpdb->term_relationships.object_id) INNER JOIN $wpdb->term_taxonomy ON ($wpdb->term_relationships.term_taxonomy_id = $wpdb->term_taxonomy.term_taxonomy_id)" : '';

// database query
$most_viewed = $wpdb->get_results("SELECT ID, post_date, post_title, (meta_value+0) AS views FROM $wpdb->posts LEFT JOIN $wpdb->postmeta ON ($wpdb->posts.ID = $wpdb->postmeta.post_id) $inr_join WHERE post_status = 'publish' AND post_password = '' $term_sql $type_sql AND meta_key = 'views' GROUP BY ID ORDER BY views DESC LIMIT $limit");
if ($most_viewed) {
foreach ($most_viewed as $viewed) {
$post_ID = $viewed->ID;
$post_views = number_format($viewed->views);
$post_title = esc_attr($viewed->post_title);
$get_permalink = esc_attr(get_permalink($post_ID));
$output .= "<li>$beforetitle$post_title$aftertitle";
if ($show_date) {
$posted = date(get_option('date_format'), strtotime($viewed->post_date));
$output .= "$beforedate $posted $afterdate";
}
$output .= "$beforecount $post_views $aftercount</li>";
}
} else {
$output = "<li>N/A</li>n";
}
echo $output;
}
```

然后使用下面的函数调用：

`<?php get_most_viewed_format(); ?>`
