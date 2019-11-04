---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress防止搜索引擎反复收录replytocom 				# 标题 
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

今天是周末的的最后一天了,我无聊写写博客吧,今天我要讲的是怎么有效的防止评论产生?replytocom= 被搜索引擎收录而产生大量重复内容,我博客在百度没这个问题,但谷歌就收录了我很多?replytocom=的页面,我百度了一下发现很多人都有这样的情况,也找到了解决方法.

百度的话你可以写robots.txt来解决,大家可以在robots里加下面这个规则即可解决

`Disallow: /*?replytocom=`

谷歌大家可以在谷歌管理员工具限制带有replytocom的索引,问题解决
