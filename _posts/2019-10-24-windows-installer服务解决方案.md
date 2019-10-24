---
layout:     post   				    # 使用的布局（不需要改）
title:      windows installer服务解决方案 				# 标题 
subtitle:      windows installer服务                 #副标题
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

很多朋友在安装MSI格式的文件包时，经常会遇到windows installer出错的情况，有如下几种现象：

1、所有使用windows installer服务安装的MSI格式程序均不能正常安装，并且系统提示“`不能访问windows installer 服务，可能你在安全模式下运行 windows ，
或者windows installer 没有正确的安装，请和你的支持人员联系以获得帮助`”。

2、察看“`windows installer服务`”的状态，一般为停用，当你试图启用此服务，会发现此服务已被系统禁用，或则windows installer服务已被标记为删除。

3、如果你重新安装windows installer服务，系统提示“`指定的服务已存在`”。

当出现了以上现象，是非常令人头疼的，而且问题难以解决，后来经自己研究发现一些非常好的解决方法。

笔者以Windows XP系统为例，根据它们出现的不同问题分别介绍一下解决过程：

一、Windows XP解决过程：

Windows XP集成了最新版本的Windows Installer v2.0，但在Windows XP里安装MSI程序也会经常出现“找不到windows installer服务”的错误。

第一步：使用记事本编写installer.reg文件，内容如下：

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSIServer]

“ImagePath”=-

“ImagePath”=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,\

74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,6d,\

00,73,00,69,00,65,00,78,00,65,00,63,00,2e,00,65,00,78,00,65,00,20,00,2f,00,\

56,00,00,00
```

然后将文件保存为“.reg”格式，双击该文件，将文件内容导入注册表。

第二步：重新启动电脑进入安全模式（启动时按F8键），然后点击“开始－－>运行”，输入“CMD”命令，
在弹出的”CMD命令提示符“窗口中输入“`msiexec /regserver`”，最后重新启动系统即可。

二、如果不是在“安全模式”下出现该情况，那么很可能是由于“Windows Installer”服务被禁用了。

运行“`services.msc`”，找到服务“`Windows Installer`”，
双击打开其属性。

然后在“常规”选项卡的“启动类型”下拉框中选择“手动”，最后单击“启动”按钮，便可启动该服务。

如果这时提示“指定的服务已标记为删除”或其他错误，无法启动该服务，那么就需要重新安装Windows Installer。

Windows XP的用户可以到 `http：//www.skycn.com/soft/11601.html `上下载Windows Installer 3.1 进行安装。
