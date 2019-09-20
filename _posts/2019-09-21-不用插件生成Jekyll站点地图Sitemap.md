---
layout:     post   				    # 使用的布局（不需要改）
title:      不用插件生成Jekyll站点地图Sitemap 				# 标题 
subtitle:   通过sitemap.xml内置代码自动生成  #副标题
date:       2019-09-21 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
catalog: true 						# 是否归档
music-id:        # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - Blog
---

**原文地址**：https://danny.li/notes/jekyll-sitemap/  

Sitemap 可以帮助搜索引擎抓取网站内容，增加访问量。不过如何你不想别人访问你的网站，就不需要这个东西。
在站点根目录下创建一个新的文件，文件名为 sitemap.xml，文件内容如下（**把一下代码中的[]替换为{}**）：

```
---
sitemap:
    priority: 0.7
    changefreq: monthly
    lastmod: 2013-07-28T12:49:30-05:00
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

  [% for post in site.posts %]                 # 把代码中的[]替换为{}
  <url>
    <loc>[[ site.url ]][[ post.url ]]</loc>              # 把代码中的[]替换为{}
    [% if post.lastmod == null %]              # 把代码中的[]替换为{}
    <lastmod>[[ post.date | date_to_xmlschema ]]</lastmod>              # 把代码中的[]替换为{}
    [% else %]              # 把代码中的[]替换为{}
    <lastmod>[[ post.lastmod | date_to_xmlschema ]]</lastmod>              # 把代码中的[]替换为{}
    [% endif %]              # 把代码中的[]替换为{}
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  [% endfor %]              # 把代码中的[]替换为{}
  [% for page in site.pages %]              # 把代码中的[]替换为{}
  [% if page.sitemap != null and page.sitemap != empty %]              # 把代码中的[]替换为{}
  <url>
    <loc>[[ site.url ]][[ page.url ]]</loc>              # 把代码中的[]替换为{}
    <lastmod>[[ page.sitemap.lastmod | date_to_xmlschema ]]</lastmod>              # 把代码中的[]替换为{}
    <changefreq>[[ page.sitemap.changefreq ]]</changefreq>              # 把代码中的[]替换为{}
    <priority>[[ page.sitemap.priority ]]</priority>              # 把代码中的[]替换为{}
  </url>
  [% endif %]              # 把代码中的[]替换为{}
  [% endfor %]              # 把代码中的[]替换为{}

</urlset>
```
