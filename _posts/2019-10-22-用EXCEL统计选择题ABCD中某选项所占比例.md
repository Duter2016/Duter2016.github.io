---
layout:     post   				    # 使用的布局（不需要改）
title:      用EXCEL统计选择题ABCD中某选项所占比例 				# 标题 
subtitle:      EXCEL统计选择题                 #副标题
date:       2019-10-22				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:        # 网易云音乐单曲嵌入
music-idfull:        # 网易云音乐歌单嵌入
tags:								#标签
    - MS Office
---

要做一份问卷统计,经常需要用Excel统计一个选择题的ABCD中的某一选项所占的百分比，可用EXCEL函数功能轻松做到，方法如下：  

假设A1～A10中存有统计结果，求结果中B所占的百分比,可以在A11中输入公式  

```
=COUNTIF(A1:A10,”B”)/10
```

然后将A11单元格格式设置为“百分比”，运行就得出结果。
