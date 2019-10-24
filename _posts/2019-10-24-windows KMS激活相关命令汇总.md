---
layout:     post   				    # 使用的布局（不需要改）
title:      windows KMS激活相关命令汇总 				# 标题 
subtitle:      KMS激活                  #副标题
date:       2019-10-24				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-keybord.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:       # 网易云音乐歌单嵌入
tags:								#标签
    - windows
---

### 一、安装KMS和激活
```
1.首先卸载旧的密钥：slmgr -upk
2.安装密钥：slmgr -ipk xxxxxxxx(你的密钥)
3.KMS服务器地址：slmgr -skms kms.landiannews.com
4.激活：slmgr -ato
```
### 二、激活时间
```
查看系统激活到期时间：slmgr.vbs -xpr
```
### 三、KMS激活换MAK激活
```
清除KMS服务器地址：slmgr /ckms
卸载密钥：slmgr.vbs -upk
重置计算机的授权状态：slmgr.vbs -rearm
然后再用slmgr -ipk 你的MAK
```
