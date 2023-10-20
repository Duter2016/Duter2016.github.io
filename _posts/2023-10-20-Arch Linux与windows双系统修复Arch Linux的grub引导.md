---
layout:     post
title:      Arch Linux与windows双系统修复Arch Linux的grub引导
subtitle:   使用EndeavourOS live cd修复
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


 

## 起因

安装的Archlinux、linuxmint、windows三系统，由于硬盘分区表分区顺序出现错误，修复后分区盘符发生变化，三个系统均不能启动。

## 整体思路

由于手里还有一个能用的winpe U盘启动盘。首先，使用winpe修复windows启动，但不能修复linux启动项。

其次，linuxmint存在不能正常引导Arch Linux的问题，而Arch Linux可以正常引导linuxmint。而EndeavourOS不需要配置图形界面就能使用Arch Linux的gui界面，所以，下面使用EndeavourOS Live CD修复grub引导，主要应用命令chroot。

## 具体操作

### 1.制作 Ubuntn U盘启动盘

可以在win下使用[Ventory](https://www.ventoy.net/cn/download.html)软件制作U盘启动盘。然后，将下载的EndeavourOS放到制作的U盘启动盘根目录下。

### 2.进入电脑BIOS，从U盘启动

### 3.然后进入EndeavourOS live normal环境

首先，使用EndeavourOS自带的welcome软件，设置镜像为国内镜像。

然后，安装grub引导需要的几个软件(注意使用—Syy更新镜像，否则可能会报错找不到安装包)：

```
sudo pacman -Syy grub
sudo pacman -Syy os-prober
sudo pacman -Syy glibc
yay update-grub
```

### 4.查看磁盘分区**，获取根目录，boot目录等所在分区编号

命令：

`sudo fdisk -l`

此处并不显示分区对应的目录，因此只能亲根据文件类型以及分区大小判断linux系统的分区，及其相应目录对应分区。例如我的archlinux在`/dev/sda9`,linuxmint 在 `/dev/sda12`，我下面就要使用`/dev/sda9`。

### 5.挂载一系列分区及目录

（1） 根分区挂载：

`sudo mount /dev/sda9 /mnt`

（2） 其他目录挂载：
```
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
```

### 6.chroot到硬盘上的linux系统

`sudo chroot /mnt`

关于chroot命令详细介绍： [chroot](http://man.linuxde.net/chroot)

### 7 .安装并更新grub

```
update-grub
grub-install  /dev/sda
```
注意这里是`/dev/sda`，不带任何盘符编号，引导的是整个硬盘。

### 8 .修复完成，卸载已挂载的目录

```
exit            //退出chroot环境
sudo umount /mnt/dev
sudo umount /mnt/proc
sudo umount /mnt/sys
sudo umount /mnt
```

### 9 .重启系统，完成
  

**参考：**
* [《ArchLinux（或Linux系统）与Win10双系统修复grub引导》](https://blog.csdn.net/lixiangITA/article/details/80545304)
