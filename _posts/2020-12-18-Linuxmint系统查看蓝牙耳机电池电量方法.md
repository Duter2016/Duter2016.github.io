---
layout:     post   				    # 使用的布局（不需要改）
title:      Linuxmint系统查看蓝牙耳机电池电量方法 				# 标题 
subtitle:      Bluetooth Headset Battery Level                  #副标题
date:       2020-12-18 				# 时间
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
---

🔋🎧我们在安卓或爱疯手机上连接蓝牙耳机后，是可以查看蓝牙耳机的剩余电量的，而且现在win 10上也有软件支持了，都是有UI的！但是在linux上找了好久才发现一个
仅能通过终端命令查看蓝牙耳机电池电量的方法，没有UI界面！

这个方法是在Github的一个项目里：**[Bluetooth Headset Battery Level](https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level)**

▶️ 下面是在linuxmint 20上测试通过可以使用的方法：

## 1. 在终端运行如下命令：

```bash
sudo apt install libbluetooth-dev python3-dev
```

## 2. 通过pip3安装需要使用的python 3的库：

```bash
pip3 install bluetooth_battery
```

## 3. 在终端运行如下命令即可查看蓝牙耳机的剩余电量：

```bash
bluetooth_battery 蓝牙耳机MAC地址1 蓝牙耳机MAC地址2 ...
```

`bluetooth_battery`后可以输入多个蓝牙耳机的MAC地址，各个MAC地址之间用空格隔开，如`蓝牙耳机MAC地址1 蓝牙耳机MAC地址2 蓝牙耳机MAC地址3`。

## 4.蓝牙耳机MAC地址获取：

蓝牙耳机的MAC地址，你可以在手机连接蓝牙耳机，然后记下蓝牙耳机的MAC地址，也可以在Linuxmint系统自带的程序“蓝牙”中先连接蓝牙耳机，然后点击已经连接上的蓝牙耳机查看耳机的MAC地址！

希望能有一款可以UI显示蓝牙耳机电量的小程序！



