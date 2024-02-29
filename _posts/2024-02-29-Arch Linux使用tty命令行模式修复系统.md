---
layout:     post
title:      Arch Linux使用tty命令行模式修复系统
subtitle:   Arch Linux升级系统，重启崩溃修复方法
date:       2024-02-29
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Arch Linux
    - Linux
---


有时升级Arch Linux系统时，由于升级操作不当，导致没有完整升级相关依赖库等原因，重启系统报错，不能正常进入GUI界面。但是tty命令行模式还能使用。

这时，重装系统比较麻烦，我们如果使用tty模式，再次通过命令行操作，再进行一次完整的系统升级，基本就可以成功修复系统，再次能够使用GUI登陆系统。

使用tty模式修复系统，需要解决两个问题：

+ ① 解决中文Arch Linux系统在tty模式下中文乱码问题（tty下出现大量方框乱码）；
+ 
+ ② tty没有GUI只有终端且没有其他有线互联网连接可用，需要手动检测无线网卡和设备，并通过终端密码验证连接到WiFi热点。

## 解决中文Arch Linux系统在tty模式下中文乱码问题

在使用中文环境的Arch Linux的tty下，终端默认使用了中文，但tty下中文却全显示成了方块。为解决显示为方块的问题，我们可以修改当中文字体不可用时，自动切换备选英文环境，解决乱码问题。在`~/.bashrc` 里添加：

```
#tty use English
if [ 'tty | grep tty' ]; then
    export LANG="en_US.UTF-8"
else
    export LANG="zh_CN.UTF-8"
fi
```

## 使用 iwd（Net Wireless Daemon）通过终端连接到 WiFi

一般，系统都默认安装了iwd。iwd 包有三个主要模块：iwctl（无线客户端）、iwd（守护进程）、iwmon（监控工具）。在终端中输入：

```
iwctl
```
![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/02/iwd001.jpg)

运行以下命令以获取系统的无线设备名称:

```
device list
```
![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/02/iwd002.jpg)

要获取 WiFi 网络列表，请运行以下命令。在以下命令和所有其他命令中将 `wlan0` 替换为你的设备名称。

```
station wlan0 get-networks
```

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/02/iwd003.jpg)

该命令为你提供具有安全类型和信号强度的可用 WiFi 网络列表。

要连接到 WiFi 网络，请使用上述 get-networks 命令中的 WiFi 接入点名称运行以下命令:

```
station wlan0 connect
```
![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/02/iwd004.jpg)

出现提示时输入你的 WiFi 密码。如果一切顺利，你现在可以连接到互联网。

你还可以使用以下命令检查连接状态。

```
station wlan0 show
```

`iwd` 在 `/var/lib/iwd` 中保存 `.psk` 后缀的配置文件，其中带有你的接入点名称。此文件包含使用你的WiFi网络的密码和SSID生成的哈希文件。

按 `CTRL+D` 退出 `iwctl` 提示符。

最后，使用系统升级命令`sudo pacman -Syyu` 或`yay`进行完整的系统升级就可以了！

**参考：**
* [《在 Arch Linux 和其他发行版中使用终端连接到 WiFi》](https://linux.cn/article-15067-1.html)
* [《tty终端怎样才能正确显示中文》](https://forum.suse.org.cn/t/topic/484)