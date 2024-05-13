---
layout:     post
title:      Linux下为network-manager设置全局public DNS
subtitle:   Arch Linux下为NM全局设置使用阿里等Public DNS
date:       2024-05-13
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Arch Linux
    - Linux
    - 网络
---

网络上一些设置linux系统全局DNS的教程，很多都涉及到修改文件`/etc/resolv.conf`，但是如果设置完后，断开wifi,重新连接wifi,`/etc/resolv.conf`中DNS又会被network-manager等网络管理软件重新覆写为运营商默认的DNS。

[网络管理器](https://wiki.archlinuxcn.org/wiki/Network_manager)们会有意覆盖 `/etc/resolv.conf`，具体细节请参见相应文章章节：

+ [dhcpcd#/etc/resolv.conf](https://wiki.archlinuxcn.org/wiki/Dhcpcd#/etc/resolv.conf)
+ [netctl#/etc/resolv.conf](https://wiki.archlinuxcn.org/wiki/Netctl#/etc/resolv.conf)
+ [NetworkManager#/etc/resolv.conf](https://wiki.archlinuxcn.org/wiki/NetworkManager#/etc/resolv.conf)

如果要使连接的每个wifi不用单独设置DNS,为Network-manager等网络管理软件设置全局DNS，其中一个方法就是：要防止程序覆盖 `/etc/resolv.conf`，还可以通过设置不可变文件属性来为其建立写保护(write-protect)：

```
sudo chattr +i /etc/resolv.conf
```

**提示：** 如果想要多个进程写入 `/etc/resolv.conf`，可以使用 [resolvconf](https://wiki.archlinuxcn.org/wzh/index.php?title=Resolvconf&action=edit&redlink=1 "Resolvconf（页面不存在）")。

**参考：**
* [《Archlinux wiki-域名解析》](https://wiki.archlinuxcn.org/wiki/%E5%9F%9F%E5%90%8D%E8%A7%A3%E6%9E%90)