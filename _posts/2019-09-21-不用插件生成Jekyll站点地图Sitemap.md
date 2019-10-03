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
在站点根目录下创建一个新的文件，文件名为 sitemap.xml，文件内容如下：

```
{% raw %}
---
sitemap:
    priority: 0.7
    changefreq: monthly
    lastmod: 2013-07-28T12:49:30-05:00
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

  {% for post in site.posts %]}               
  <url>
    <loc>{{ site.url }}{{ post.url }}</loc>             
    {% if post.lastmod == null %}             
    <lastmod>{{ post.date | date_to_xmlschema }}</lastmod>              
    {% else %}             
    <lastmod>{{ post.lastmod | date_to_xmlschema }}</lastmod>             
    {% endif %}             
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  {% endfor %}             
  {% for page in site.pages %}            
  {% if page.sitemap != null and page.sitemap != empty %}             
  <url>
    <loc>{{ site.url }}{{ page.url }}</loc>             
    <lastmod>{{ page.sitemap.lastmod | date_to_xmlschema }}</lastmod>            
    <changefreq>{{ page.sitemap.changefreq }}</changefreq>             
    <priority>{{ page.sitemap.priority }}</priority>             
  </url>
  {% endif %}            
  {% endfor %}              

</urlset>
{% endraw %}
```
