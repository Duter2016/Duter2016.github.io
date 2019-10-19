---
layout:     post   				    # 使用的布局（不需要改）
title:      Word中没有出现Endnote X7加载项的一般解决方案 				# 标题 
subtitle:      EndNote 疑难解答                 #副标题
date:       2019-10-19 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-desk.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - EndNote
    - 疑难解答
---
来源：参考网络和自己的更新探索

## Endnote X7解决办法

注意本文的解决办法是针对Endnote X7版本的，较低版本的解决办法与此有差异！

处理步骤如下，以Office word 2007为例，word 2003及word2013等版本可以参考处理：

### 1.在word中手工添加endnote加载项。

左上角的office按钮-word选项-加载项-左下方COM加载项 若找到Endote相关项，则打勾–确定

若是这一步没有看到endnote相关加载项，则进入步骤2

### 2.启用可能被禁用的endnote加载项

左上角的office按钮-word选项-加载项-左下方禁用项目 找到Endote相关项-点击转到-启用。若是禁用项目中没有找到Endnote相关项，则进入步骤3。

### 3.将Endnote安装文件夹“`Program Files（你的文件安装路径）\EndNote X7\ResearchSoft\Cwyw\17`”下面的所有文件（主要是一定要有两个文件EndNote Cwyw.dot和EndNote Cwyw.dll） 复制到 “`%userprofile%\AppData\Roaming\Microsoft\Word\STARTUP`”（win8系统）或者win7系统的“`C:\Documents and Settings\Administrator（或者具有管理员权限的账户）\Application Data\Microsoft\Word\STARTUP`”目录下。

## 较低版本（如endnote x5、x6）解决办法

现在也把较低版本（如endnote x5、x6）的此问题的解决办法也附上吧，方便大家查找：

处理步骤如下，以Office word 2007为例，word 2003及word2013等版本可以参考处理：

### 1.在word中手工添加endnote加载项。

左上角的office按钮-word选项-加载项-左下方COM加载项 若找到Endote相关项，则打勾–确定

若是这一步没有看到endnote相关加载项，则进入步骤2

### 2.启用可能被禁用的endnote加载项

左上角的office按钮-word选项-加载项-左下方禁用项目 找到Endote相关项-点击转到-启用。若是禁用项目中没有找到Endnote相关项，则进入步骤3。

### 3.将Endnote安装文件夹`\Program Files\EndNote X5\Product-Support\CWYW`下面的两个文件**EndNote Cwyw.dot和EndNote Cwyw.dll 复制到** “`%userprofile%\AppData\Roaming\Microsoft\Word\STARTUP`”（win8系统）或者win7系统的“`C:\Documents and Settings\Administrator（或者具有管理员权限的账户）\Application Data\Microsoft\Word\STARTUP`”目录下。
