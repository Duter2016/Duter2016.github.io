---
layout:     post   				    # 使用的布局（不需要改）
title:      安装Office-2013后，安装Visio-2013报错「安装程序找不到office-zh-cn」 				# 标题 
subtitle:      安装程序找不到office.zh-cn疑难解答                #副标题
date:       2019-10-22 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - MS Office
    - 疑难解答
---
### 问题描述

安装系统为cn_windows_7_ultimate_with_sp1_x64_dvd_u_677408.iso，使用正常。
安装Office 2013（cn_office_professional_plus_2013_with_sp1_x64_dvd_3921920,.iso）一切正常，由于工作需求，
要安装visio 2013（cn_visio_professional_2013_x86_x64_dvd_1169517.iso），这本是微软自家的产品，安装了几次，试过安装2010和更换安装目录等，均安装失败。

安装Office 2013后，安装Visio 2013报错：“安装程序找不到office.zh-cn”。

尝试将安装源指向解压后的visio 2013，提示无效，无法继续。
 
 ### 解决办法
 
由于缺少文件，而且都属于office系列，既然visio 2013安装源不包含缺失的文件，就将0ffice 2013解压，然后将visio 2013的安装源指向解压后的office 2013文件夹作为安装源，
点击确定，发现缺失的文件已经变了，确认指向的安装源是office 2013，点击确认数次后，visio 2013终于可以正常安装了。

**注意**：是将visio 2013的安装源指向解压后的office 2013文件夹作为安装源（整个解压出来的完整安装源文件），而不是像网络上流行但不一定奏效的只指向office.zh-cn的具体文件。
本文的方法也适用于win7的32位系统和win8的32位和64位系统！
