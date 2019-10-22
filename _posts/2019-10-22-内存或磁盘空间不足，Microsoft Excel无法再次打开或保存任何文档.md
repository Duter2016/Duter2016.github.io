---
layout:     post   				    # 使用的布局（不需要改）
title:      内存或磁盘空间不足，Microsoft Excel无法再次打开或保存任何文档 				# 标题 
subtitle:      疑难解答                  #副标题
date:       2019-10-22				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:        # 网易云音乐歌单嵌入
tags:								#标签
    - MS Office
    - 疑难解答
---

### 问题描述

office2013，打开foxmail附件或网上下载的文档时，提示：“内存或磁盘空间不足，Microsoft Excel无法再次打开或保存任何文档。”

### 解决方法

按照下面的教程，把Excel、word 、PPT全部设置一次即可。下面以Excel为例：

1.打开excel程序，我们点击左上角的“文件”菜单，点击左侧最下面的“选项”；

![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/10/22/excel01-1571741786154.png)

2.在Excel选项中，我们点击左侧栏中的“信任中心”－“信任中心设置”；

 ![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/10/22/excel02.png)

3.再点击左侧栏中的“受保护的视图”－右侧3个复选框全部去掉勾；

 ![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/10/22/excel03.png)
 
 其实，也不必三项都去掉，去掉第一项，或者第一项和第三项就可以了

4.再点击左侧栏中的“受信任位置”－右侧勾选“允许网络上的受信任位置”、不勾选“禁用所有受信任位置”；

![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/10/22/excel04.png)

5.如果打开你下载到磁盘上的文件，依然存在问题，再点击左侧栏中的“受信任位置”－右侧“添加新位置”－“路径”填写打不开文件的位置，如果对电脑里的文件放心，可以直接添加磁盘根目录如“`D:\`”并勾选“同时信任此位置的子文件夹”，最后点击确定即可。

![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/10/22/excel05.jpg)
 
以上内容就是内存或磁盘空间不足excel无法再次打开的解决方法。

**不要忘了按照上面的教程，把word 、PPT全部再设置一次。**
