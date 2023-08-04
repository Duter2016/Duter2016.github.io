---
layout:     post
title:      设置Chrome、Firefox等浏览器缓存到tmpfs
subtitle:   将浏览器cache缓存从硬盘转移至物理内存
date:       2023-08-02
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---


tmpfs（英语：temporary file system）是类Unix系统上暂存档存储空间的常见名称，通常以挂载文件系统方式实现，并将资料存储在易失性存储器（如物理内存）而非永久存储设备中。和RAM disk的概念近似，但后者会呈现出具有完整文件系统的虚拟磁盘。

tmpfs在Linux kernel从2.4之后的版本都有支持。tmpfs（之前比较为人所知的名称是"shmfs"）和Linux的ramdisk设备定位有所不同。Ramdisk是固定划分一块存储器出来使用，且允许比较不常用的页面可以移动到置换空间去。MFS还有其它ramfs的旧版本，都不会动态的调整大小，只能一直占用一个固定的大小。而tmpfs文件系统的大小是可以随时调整的，比如追加一个指令，改变：

`mount -o remount,size=2G /space`

因此，我们可以选择把物理内容出一部分当部分的硬盘空间来使用，读写速度相当丝滑，而且不用频繁的读写硬盘。当然，万一掉电了，tmpfs上的内容也就没了，所以要存储的配置数据等，自然是不会放在这边的。但我们可以把浏览器的缓存数据，放在这个分区上。

Archlinux系 和 debian系的系统都默认挂载了tmpfs分区，可以使用`mount`命令查看：

```
$ mount

# 输出：

/dev/sda14 on / type ext4 (rw,noatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,size=4096k,nr_inodes=973070,mode=755,inode64)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,noatime,size=2097152k,inode64)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /run type tmpfs (rw,nosuid,nodev,size=1564188k,nr_inodes=819200,mode=755,inode64)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=34,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=2798)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,size=3910464k,nr_inodes=1048576,inode64)
rw,nosuid,nodev,relatime,size=782092k,nr_inodes=195523,mode=700,uid=1000,gid=1000,inode64)
......
```

设置Chrome、Firefox、Edge等浏览器的缓存默认是在`/home/<username>/.cache/`目录下的。下面我们把这些浏览器的缓存改为在tmpfs分区。


使用的机械硬盘，清理缓存的时候，在.cache目录发现了edge上G的缓存文件，几万个文件，删除也慢。就打算把edge、google-chrome、forefox的缓存文件一起放到tmpfs。

（1）设置浏览器使用的tmpfs分区

基本上linux系统都会有/dev/shm，但是不一定把/tmp挂载成tmpfs。所以修改这个缓存路径的话，还是修改到/dev/shm下比较合适。

编辑修改`/etc/fstab`文件，挂载一个 tmpfs 分区使用，注意设置权限：

`tmpfs /dev/shm           tmpfs    defaults,noatime,nodev,nosuid,size=2048M,mode=1777   0 0`

**要注记一点：** 如果`/dev/shm`有安全上的顾虑的话，最好追加粘滞位(sticky bit)上来。就是权限应该被设作"mode=1777"，而不是"mode=0777或"mode=777"

如果仅用defaults，不设置size参数，默认是最大占用物理内存的50%，想自己确定大小，就自己加size参数。

这样把tmpfs写在fstab里面就可以开机启用了！重启后生效。

重启后，可以使用命令`df -h`查看tmpfs的挂载及使用情况：

```
$ df -h
文件系统        大小  已用  可用 已用% 挂载点
/dev/sda14       57G   28G   26G   52% /
devtmpfs        4.0M     0  4.0M    0% /dev
tmpfs           2.0G   98M  2.0G    5% /dev/shm
tmpfs           1.5G  1.5M  1.5G    1% /run
tmpfs           3.8G   37M  3.7G    1% /tmp
/dev/loop0      173M  173M     0  100% /run/wine
tmpfs           764M  108K  764M    1% /run/user/1000
```

（2）设置浏览器缓存至tmpfs分区

①修改Chrome的话，如果你是使用KDE界面的话，就比较容易了。修改KDE菜单编辑器中的Chrome的命令，加上

`--disk-cache-dir="/dev/shm/chrome_$USER"`

为了区分可能不同的用户，所以我加上了`_$USER`。另外，我们也可以修改浏览器启动的.desktop文件，
对于Chrome，把 `usr/share/applications/google-chrome.desktop`（全局，所有用户）（`~/.local/share/applications/google-chrome.desktop`为当前用户）中修改启动命令为：

`Exec=/usr/bin/google-chrome-stable %U --disk-cache-dir="/dev/shm/googlechrome_$USER"`

修改这个文件，升级不会被覆盖掉。不过你之后执行的话，要点击这边的这个.desktop文件。

其实以chromium为基础的浏览器，比如linux版本的opera、edge等也是可以的。

②对于edge,把 usr/share/applications/microsoft-edge-dev.desktop中修改启动命令为：

`Exec=/usr/bin/microsoft-edge-dev %U --disk-cache-dir="/dev/shm/edge_$USER"`

③ 对于firefox， 在firefox的地址栏输入

`about:config`

之后会跳出警告，点保证小心就是了。进入界面后，右键–>新建–>字符串–>输入首选项名称，输入首选项名称如下：

`browser.cache.disk.parent_directory` 键值string为：

`/dev/shm/firefox_dd`

④ thunderbird也是和firefox一个出身的，在ubuntu下thunderbird的`about:config`是没地方可以输入的。但是其有配置首选项，里面有个配置编辑器，与firefox一样，会弹出警告，警告上面的标题就可以看到`about:config`了。配置的话，也是和firefox一样的，当然，你得把键值路径给改一下。那么重启下，也就重定向缓存的路径了。

设置的tmpfs重启系统后生效，设置的浏览器，重启浏览器后就可以生效。


清除chromium dns缓存:
chrome://net-internals

**参考：**
* [安装archlinux的todolist](https://coda.world/archlinux-installation-todolist)
* [设置chrome、firefox缓存到tmpfs](https://elkpi.com/topics/2014/06/chrome-firefox-cache-2-tmpfs.html)
* [tmpfs维基百科](https://zh.wikipedia.org/wiki/Tmpfs)