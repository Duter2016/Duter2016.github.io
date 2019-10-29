---
layout:     post   				    # 使用的布局（不需要改）
title:      「Microsoft Office Word已停止工作」解决方法 				# 标题 
subtitle:      MS Office 疑难解答                 #副标题
date:       2019-10-29 				# 时间
author:     Duter2016 						# 作者
header-img: img/tag-bg-o.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:        # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - MS Office
    - 疑难解答
---

### 症状
在使用MS office word的时候，有时不注意就会出现一些莫名的错误，导致word崩溃退出，很有可能导致正在编辑的文件丢失。一旦出现莫名的错误，就要立马进行修复，
防止办公文件丢失。下面是可能出现的频次比较高的错误。

在使用Word 2003 或者2007、2010、2013等版本的时候，可能会有些人遇到如下错误提示：“`Microsoft Office Word已停止工作`”。这个错误是由于
不良的关机习惯导致的，在没有关闭或者保存正在编辑的办公文件前，就强制关机，导致正在使用的模板文件被打坏，致使以后使用时，经常出现这个错误提示。
这个问题的解决也比较简单，下面，将讲解如何解决这个问题。

### Word停止工作解决方法如下：

下面提供的这个方法在MS office 2003，2007，2010以及2013版本的办公软件中通用。

双击打开“计算机”在左上方的地址栏中输入“`%userprofile%\AppData\Roaming\Microsoft\Templates`”（复制到地址栏回车）
（本站提供的地址是通用访问地址，回车后显示的地址一般是“`C:\Users\Administrator\AppData\Roaming\Microsoft\Templates`”），然后回车，
这个路径下面找到“Normal.dot”这个文件，然后将其删除即可。

（上面的这个方法适用于xp、win7、win8、win8.1，在win10下注意修改一下地址的全称，win10下有时不能直接显示）

**PS**.Excel和ppt有时也会出现这个类似的错误，有时按照上面的方法处理也能解决，但是，由于Excel和powerpoint有时使用了VB代码也会导致出现错误提示，
如果上面的方法不能解决就要特殊对待了，需要根据出现错误时操作进行判断哪里出的问题了。
