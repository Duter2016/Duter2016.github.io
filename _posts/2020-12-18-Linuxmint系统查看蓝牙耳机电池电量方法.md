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

> 据悉，[Blueman](https://github.com/blueman-project/blueman)将在2.2版本中加入蓝牙设备电量显示,[见issue](https://github.com/blueman-project/blueman/issues/1453)，期待！

> 本文方法基于Github的一个项目：[Bluetooth Headset Battery Level](https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level)

我在GitHub上新建了一个项目**[〔bluetooth_battery_level_bash〕](https://github.com/Duter2016/bluetooth_battery_level_bash)**。在[Bluetooth Headset Battery Level](https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level)项目基础上添加了bash脚本，使用更方便！

▶️ 下面是在linuxmint 20.1上测试通过可以使用的方法：

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

## 5.建立bash脚本，通过.desktop快捷方式运行

先建立bash脚本文件bluetoothBattery.sh，脚本内容为：

```bash
#!/bin/bash
# Linux系统蓝牙设备电池电量显示

DEVICE=$("bluetoothctl" devices)
OUTPUT=$(bluetooth_battery A4:E0:A9:F7:EA:70 15:D2:38:EA:CD:F4)    #修改为你的蓝牙设备MAC地址，多个设备空格隔开

#任意键
get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}
#任意键

IFS=$012        #012指定换行符'\n'为分割依据，不要使用'\n'，"040"是空格，"011"是Tab。
echo "蓝牙设备电池电量信息为："
echo $OUTPUT
echo ""
echo "MAC与设备对应关系："
echo "15:D2:38:EA:CD:F4 is for i12double;"     #修改为你的蓝牙设备标识
echo "A4:E0:A9:F7:EA:70 is for i12single."     #修改为你的蓝牙设备标识
unset IFS       #取消分隔符依据

#任意键退出 开始
echo ""
# echo "组合键 CTRL+C 终止运行脚本命令! ..."
echo "按任意键退出脚本运行..."
char=`get_char`
#任意键退出 结束

#20秒自动关闭 开始
# echo "本窗口将在20秒后关闭..."
# sleep 20
#20秒自动关闭 结束
```

再建立BluetoothBattery.desktop快捷方式：
```
#!/usr/bin/env xdg-open
[Desktop Entry]
Encoding=UTF-8
Name=蓝牙设备电量
Exec=sh /home/username/opt/bluetooth_battery/bluetoothBattery.sh 
Type=Application
Terminal=true
Comment=蓝牙设备电池电量显示
Icon=/home/username/opt/bluetooth_battery/bluetoothBattery.jpeg
```
把本项目下载到`~/opt/bluetooth_battery`目录，修改下上述代码中的目录路径为你的路径，然后，把BluetoothBattery.desktop复制到`~/.local/share/applications`目录下，就可以在开始菜单启动了！





