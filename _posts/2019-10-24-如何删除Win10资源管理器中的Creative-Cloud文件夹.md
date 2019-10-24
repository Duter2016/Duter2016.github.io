---
layout:     post   				    # 使用的布局（不需要改）
title:      如何删除Win10资源管理器中的Creative Cloud文件夹				# 标题 
subtitle:      Creative Cloud                 #副标题
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

7月28日Adobe Creative Cloud桌面版程序发布了一次更新，更新后可完全兼容Win10系统。当Adobe Creative Cloud升级更新完成之后，
会在文件资源管理器导航窗格中创建一个名为“`Creative Cloud文件`”的文件夹。

对于不使用Adobe Creative Cloud同步文件的朋友来说，可能有些碍眼。但是在右键菜单以及Creative Cloud桌面版程序的设置中都没有找到关闭选项，
看来只能从注册表下手了。

经过一番查找，在注册表以下位置找到了对应的项目：

```
HKEY_USERS\S-1-5-21-3185218813-812416551-593507322-1001\SOFTWARE\Classes\CLSID\{0E270DAA-1BE6-48F2-AC49-F7A03EB7D1CF}
```

对应键为：

`System.IsPinnedToNameSpaceTree`

该键值默认为`1`，即在文件资源管理器导航窗格中显示“`Creative Cloud文件`”。如果你不想看到它，将其键值修改为0即可。修改后可立即生效，
无需重启文件资源管理器，也无需重启计算机。

本文在Windows10正式版操作系统中测试，在Win7/Win8/Win8.1操作系统中应该也适用。
