---
layout:     post   				    # 使用的布局（不需要改）
title:      CiteSpace安装 				# 标题 
subtitle:      文献管理                #副标题
date:       2019-10-14 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:       # 网易云音乐歌单嵌入
tags:								#标签
    - CiteSpace
    - 学术
---

1、CiteSpace不像其他CS客户端程序一样提供了下载安装，它提供Java的jnpl文件，实现Java Web调用，即Java Web Start。

2、由上一下可以知道，CiteSpace需要Java环境，故下载JDK安装。

3、进入网站：[http://cluster.cis.drexel.edu/~cchen/citespace/](http://cluster.cis.drexel.edu/~cchen/citespace/)。该网页中有个绿色背景字“WebStart”。点击后会发现它会自动下载运行一个“citespace.jnlp”文件。有的浏览器点击查看该文件时就自动下载客户端运行，如果你的是这种情况，你很幸运。若有的用户发现打不开该文件，那么进行下一步操作。

4、在开始->运行中输入cmd命令，然后测试JDK是否安装好（输入java若不报找不到该命令，而是出现一些帮助信息，说明java已安装好），在该命令提示符窗口中输入：

`javaws http://cluster.ischool.drexel.edu/~cchen/citespace/current/citespace.jnlp`

这时候你会发现，它开始下载了。

5、下载完成后，即可运行。然而大家会想，该程序没有快捷方式吗？嗯，但可以自己写个。若你的浏览器本身可以直接打开jnlp文件，那么我们每次启动的时候可以如下方式操作：进入官方，点击“WebStart”；若你需要输入上一步的命令才能打开下载，那么你需要每一次都输入上面的命令，则可以自己写一个bat文件内容如下：

`javaws http://cluster.ischool.drexel.edu/~cchen/citespace/current/citespace.jnlp`

文件名为citespace.bat，注意bat为其扩展名。把该文件放在桌面上，每次使用时只用点击该文件即可。

6、通过查看运行时的窗口最顶上一行中的信息：“C:\Documents and Settings\Administrator”可以判断citespace主要文件在该文件夹下，你浏览可以找到，它是citespace HOME文件夹。当然这里你的和我的可能不同，它是当前用户的文件夹。

7、一般情况下，你的电脑中Java是以client方式运行的，也可以以server方式运行，只需要把jre文件夹下的server文件夹拷到jdk文件夹下。

如把C:\Program Files\Java\jre_06\bin下的server文件夹拷到C:\Program Files\Java\jdk1.6.0_06\bin下面。

则现在你可以用如下方式来启动citespace了：

`java -server -jar -Xmx citespace.jar`

在citespace HOME文件夹“C:\Documents and Settings\Administrator”中可以找到StartCiteSpace.cmd，可将其中的内容改为上面的语句。

8、那么这个citespace.jar在哪里呢？我也不晓得，如果你知道，请告诉我一下。对Java Web Start不是很了解，所以目前不知道怎么解决这个问题。

9、另：其实jnlp文件是可以直接用javaws打开的，所以可以把jnlp文件下载下来，然后选择其默认打开方式是`JAVA_HOME/bin/javaws.exe`
