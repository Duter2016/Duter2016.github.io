---
layout:     post   				    # 使用的布局（不需要改）
title:      解决升级wordpress无法进入控制台的问题 				# 标题 
subtitle:      wordpress博客优化2012-05-23                  #副标题
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

升级之后发现控制台一片空白，不过不用紧张，其实是插件兼容性问题。

**解决办法**：

直接改后台数据库把所有的插件都禁用。

找到表 `wp_options`， 把option_name为`active_plugins`的那条记录的`option_value`设置为 `a:0:{}`

这样所有的插件都禁用了，可以进入后台控制面板。

**参考文献**：

+ 读.写.网（链接已失效）
