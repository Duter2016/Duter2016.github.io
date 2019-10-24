---
layout:     post   				    # 使用的布局（不需要改）
title:      lenovo 超极本进BIOS和U盘启动的方法 				# 标题 
subtitle:      超极本进BIOS和U盘启动                  #副标题
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

1.在关机状态下，按下“开机”键左边的那个弯弯箭头的那个按键，按住它开机，然后就出来一个菜单，选择第二个“BIOS setup”即可进入BIOS设置界面。

2.进入设置界面后，将快速启动禁用后保存退出。

3.切换到boot标签，将boot mode改为`legacy support`，boot property改为`legacy first`，插上U盘，按F10保存之后立即按F12直到进入启动设备列表，选择从USB启动即可。
