---
layout:     post
title:      linux清除Windows文件系统中的dirty bit脏位
subtitle:   linux下用ntfsfix,windows下用WinHex修复
date:       2023-10-20
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Arch Linux
    - Linux
---


## 问题描述

* 该问题在Arch Linux中上报有该bug： [https://bugs.archlinux.org/task/78596](https://bugs.archlinux.org/task/78596)

* 该bug导致无法挂载windows下ntfs文件系统中存在dirty bit脏位的分区，在util-linux更新到2.39-3之后可修复。我现在的系统中util-linux版本是2.39.2-1，无法挂载的问题出现，未升级到2.39-3前可以使用本文方法修复。

我的Windows有5个NTFS分区，其中2个卷标分区无法在Dolphin中通过点击图标的方式挂载，但可以在命令行手动挂载，挂载之后可以在Dolphin中正常访问。其他3个分区可以正常挂载。

该分区上安装的Windows可以正常启动，因此分区本身应没有错误。Windows没有处在休眠状态，且关闭了快速启动。

Dolphin给出的错误提示信息如下：

`访问 时发生错误，系统返回信息：请求的操作已失败: Error mounting  wrong fs type, bad option, bad superblock on missing codepage or helper program, or other error`

在终端中使用

`sudo mount /dev/sda7`

则没有任何错误。手动挂载之后亦可在Dolphin中访问。

## 解决方法

Dolphin 报错之后，使用如下命令查看内核日志：

`journalctl -k -n 100`

我们可以在日志中找到类似如下的输出：

```
10月 20 22:33:59 ThinkPad kernel: ntfs3: sda5: volume is dirty and "force" flag is not set!
10月 20 22:34:01 ThinkPad kernel: ntfs3: sda7: volume is dirty and "force" flag is not set!
```
该错误分析如下：

Windows 系统通常能很好的处理异常的“冷重启”（断电，关闭插线板的电源，或家里的小人儿手指随意按导致关机)。事实上，至今为止，最有效的修复Windows桌面问题的方法就是简单的重启系统。但是，Windows分区偶尔会显示系统需要进行驱动器一致性检测。不这么做的话，在几次重启后可能会引起文件系统状况恶化而使系统变得更糟。众所周知，Windows文件系统检查超级慢，而且经常不得不做好几次才能清理掉文件系统的“脏（dirty）”标志。

然而在dirty bit没有被清理掉前，在linux下读取win下相关分区会出现如上错误提示。

### 1.linux系统下清除dirty bit脏位

下面介绍一个叫“ntfsfix”的小工具。

① 在Arch Linux中，无需安装，可以直接使用。用如下命令修复存在问题的分区（以`/dev/sda7`为例）：

`ntfsfix -d /dev/sda7`

② 在基于Debian的系统（如 Ubuntu）可以通过下面的命令下载安装：

`sudo apt-get install ntfsfix`

③ 或者在基于RPM的系统（如 Red Hat 或 CentOS）中通过下面的命令下载安装:

`sudo yum install ntfsfix`

这个‘ntfsfix’工具能快速的修复常见的错误以及NTFS分区不一致的问题。最常用的命令不用带任何参数。 它也可以报出来那些没有修复掉的项，然后我们能通过以下选项来修复它们：

* -b: 清除磁盘上的坏的扇区 (可以在从一个旧磁盘往新的磁盘上克隆之后使用)
* -d: 清除“脏”标志。“脏”标志是Linux不能挂载一个Windows分区的最常见的原因，通常发生在Windows断电前没有正常关机的情况。
* -n: 除了在标准输出上显示它要完成的(换句话说，就是需要修复哪些)之外不做任何事。

过去Windows在启动前，用NTFS Disk Check来重置“脏”标志，常常要花几个小时。而‘ntfsfix’完成这个仅仅只需要大约三秒的时。

### 2.windows系统下清除dirty bit脏位

Windows中有一个名为fsutil.exe的工具可用于检查卷是否“脏了”，甚至可用于手动将卷设置为“脏”，这会导致请求扫描驱动器，但奇怪的是它不能清除dirty bit。

在win下使用管理员身份运行cmd,然后输入如下命令查看分区是否存在dirty bit：

`fsutil dirty query f:`

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit001.png)

可以用两种方法清除dirty bit：进行磁盘检查(在管理员身份打开cmd，运行`chkdsk d:/f`，d为盘符)，或者格式化驱动器（之前先备份数据）。前者会生成一些​ ​后缀为CHK的文件​​，这些文件不知所谓，有可能让你丢失数据，后者更稳妥一些，但如果数据量很大，拷贝文件需要花很多时间。

本文介绍第三种方法。先在 NTFS 和 FAT16/32 文件系统上找到dirty bit，然后再用十六进制编辑器手动清除dirty bit。正如之前所说，dirty bit只是一个十六进制数值。

我们使用十六进制编辑器WinHex。下载WinHex：

```
链接: ​ ​https://pan.baidu.com/s/12sDF8QCdolNKgaAgxrSxqA​​​​​​​​​​​​​​​​​
提取码: 4v56
```

开始清除dirty bit：

（1）下载WinHex，只有注册版才能往硬盘里写回数据。

（2）以管理员权限运行WinHex.exe，点击`工具-打开磁盘`，选择你将要编辑的盘符。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit002.png)

FATA32卷的dirty bit偏移量是`0x41`，该位置01为脏卷，置00为干净，所以将其置为00，按`Ctrl+W`或点软盘按钮写入驱动器，以后将不再提示检查磁盘。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit003.png)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit004.png)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit005.png)

FAT16卷dirty bit的偏移量是0x25，修改方法同上。

点击$Volume文件可以找到NTFS卷的dirty bit，但偏移量有所不同。首先找13个字节的特征串，它是下列两者之一：

`03 01 01 00 00 00 00 00 80 00 00 00 18`

或者：`03 01 81 01 00 00 00 00 80 00 00 00 18`

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/10/dirty-bit006.png)

本例是找到了特征串`03018101`，改`8101`为`8000`。

如果找到的特征串是`03010100`，改为`03010000`。

我在自己的系统中找到的特征串为`03010102`，改为`03010000`。

dirty bit即被清除。

据实验，对WIN7、8、10的修改即刻生效，XP需要重启。

**参考：**
* [《ArchLinux（或Linux系统）与Win10双系统修复grub引导》](https://blog.csdn.net/lixiangITA/article/details/80545304)
* [《不使用CHKDSK，手动重置或清除Windows中的 dirty bit （脏位）》](https://blog.51cto.com/u_9843231/4844617)
* [《Linux下NTFS分区的修复和恢复》](https://github.com/LCTT/TranslateProject/blob/master/published/201310/NTFS%20Partition%20Repair%20and%20Recovery%20In%20Linux.md#L1)
* [《kde无法挂载特定的NTFS分区》](https://bbs.archlinuxcn.org/viewtopic.php?id=13801)
* [《无法在kde dolphin中挂载特定的磁盘分区》](https://bbs.archlinuxcn.org/viewtopic.php?id=13476)
