---
layout:     post   				    # 使用的布局（不需要改）
title:      Linux下调整QuickCut显示超出屏幕 				# 标题 
subtitle:      QT5高分辨率调整                  #副标题
date:       2021-02-28 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-unix-linux.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
apserver: netease    # 音乐平台netease/tencent/kugou/xiami/baidu
aptype: playlist    # 音乐类型song/playlist/album/search/artist
apsongid:         # 音乐song/playlist/album id
tags:								#标签
    - Linux
    - Qt5
    - Pyqt5
---

🔋QuickCut的UI是使用的Pyqt5，可以通过`self.resize()`调整分辨率，但是对高度调整无效。本人比较菜，既然Pyqt5不会调整，那就使用Qt5环境变量修改窗口。直接通过启动命令添加环境变量：

```
[Desktop Entry]
Name=QuickCut
Exec= env QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_FONT_DPI=85 quickcut
Type=Application
Terminal=false
Comment=视频剪辑
Icon=/home/dh/opt/icons/QuickCut.ico
Categories=AudioVideo;Player;
```
**注：**

```
QT_AUTO_SCREEN_SCALE_FACTOR=1
```
自动检测屏幕的 DPI。 

```
QT_FONT_DPI=85
```
设置字体大小。



