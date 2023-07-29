---
layout:     post
title:      ThinkPad 配置 Archlinux KDE Plasma 记录
subtitle:   个人笔记本安装记录
date:       2023-06-06
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - ArchLinux
    - Linux
---





> Thinkpad 安装 基于Archlinux 的 EndeavourOS

## 一、系统基础配置

### 1. 配置镜像源

#### （1）EndeavourOS镜像源

`sudo gedit /etc/pacman.d/endeavouros-mirrorlist`

添加吉大和清华大学的两个国内源后为：

```
Server = https://mirrors.tuna.tsinghua.edu.cn/endeavouros/repo/$repo/$arch
Server = https://mirrors.jlu.edu.cn/endeavouros/repo/$repo/$arch
Server = https://mirror.archlinux.tw/EndeavourOS/repo/$repo/$arch
Server = https://mirror.freedif.org/EndeavourOS/repo/$repo/$arch
Server = https://mirror.funami.tech/endeavouros/repo/$repo/$arch
Server = https://mirror.jingk.ai/endeavouros/repo/$repo/$arch
Server = https://fosszone.csd.auth.gr/endeavouros/repo/$repo/$arch
Server = https://mirror.alpix.eu/endeavouros/repo/$repo/$arch
Server = https://ftp.acc.umu.se/mirror/endeavouros/repo/$repo/$arch
Server = https://mirrors.gigenet.com/endeavouros/repo/$repo/$arch
Server = https://md.mirrors.hacktegic.com/endeavouros/repo/$repo/$arch
Server = https://de.freedif.org/EndeavourOS/repo/$repo/$arch
Server = https://endeavour.remi.lu/repo/$repo/$arch
Server = https://ca.gate.endeavouros.com/endeavouros/repo/$repo/$arch
Server = https://fastmirror.pp.ua/endeavouros/repo/$repo/$arch
Server = https://mirror.albony.xyz/endeavouros/repo/$repo/$arch
```

#### （2）切换国内Arch官方镜像源

`sudo gedit /etc/pacman.d/mirrorlist`

添加国内源后为：

```
## China
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.jlu.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.wsyu.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch

## China
Server = http://mirrors.163.com/archlinux/$repo/os/$arch

## China
Server = https://mirrors.dgut.edu.cn/archlinux/$repo/os/$arch

## China
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
```


#### （3）添加 ArchLinuxcn 中文社区仓库 

`sudo gedit /etc/pacman.conf`

在 /etc/pacman.conf 文件末尾添加以下几行：

```
# The Chinese Arch Linux communities packages.
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

之后通过一下命令安装 archlinuxcn-keyring 包导入 GPG key：

`sudo pacman -Syu archlinuxcn-keyring`

**注意：ArchLinuxcn 中文社区仓库源，只能添加一个！**

其他备选源：

```
# 只能添加一个
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch # 中国科学技术大学开源镜像站
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch # 清华大学开源软件镜像站
Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch # 哈尔滨工业大学开源镜像站
Server = https://repo.huaweicloud.com/archlinuxcn/$arch # 华为开源镜像站
```

#### （4）关于添加AUR源

**注意：不要添加AUR国内源！原来仅有清华大学提供AUR的国内镜像源，后因种种原因，已经取消了AUR的国内镜像源。**

#### （5）启用multilib仓库源

编辑 `/etc/pacman.conf`，去掉下面两行前面的 # 号： 

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

### 2.安装update-grub及os-prober

**注意：图形界面不可用`grub-customizer`，会导致引导出错。**

（1）安装 os-prober

安装系统探测器os-prober，便于添加已有的EFI系统的引导项，如果不安装可能会探测不到其他系统（如果你其他系统使用的BIOS引导，可以不用安装）。

`pacman -S os-prober`

然后修改`/etc/default/grub`文件：

```
# 找到如下一行
# GRUB_DISABLE_OS_PROBER="false

去掉`GRUB_DISABLE_OS_PROBER="false"`的`#`。
```
（2）安装update-grub

安装update-grub：

```
sudo pacman -Syu grub
yay update-grub
sudo update-grub
```
目前，我的linuxmint+Archlinux+windows通过上述步骤，成功完成引导！

（3）如果探测不到其他系统

如果两个Linux系统，其中一个不能通过`sudo update-grub`加载，比如Archlinux不能引导Linuxmint，就把两个系统的grub引导文件`/boot/grub/grub.cfg`复制出来，然后进行整合（注意两个系统的引导部分的语句的不同的地方）。

如我把Linuxmint系统的引导部分加入Archlinux的grub引导中，就是在Archlinux的`/boot/grub/grub.cfg`文件中添加如下引导部分：

```
### BEGIN /etc/grub.d/10_linux ###
menuentry 'Linux Mint MATE' --class linuxmint --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-753fefe8-0234-438c-9d31-728a2143d0c8' {
	load_video
	set gfxpayload=keep
	insmod gzio
	if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos10'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos10 --hint-efi=hd0,msdos10 --hint-baremetal=ahci0,msdos10  753fefe8-0234-438c-9d31-728a2143d0c8
	else
	  search --no-floppy --fs-uuid --set=root 753fefe8-0234-438c-9d31-728a2143d0c8
	fi
	linux	/boot/vmlinuz-5.15.0-76-generic root=UUID=753fefe8-0234-438c-9d31-728a2143d0c8 ro  quiet splash 
	initrd	/boot/initrd.img-5.15.0-76-generic
}
### END /etc/grub.d/10_linux ###
```

### 3.切换到其它内核（可选）

Arch Linux 和 AUR 上可选的内核可以参考以下网址：

[Kernel -- ArchWiki](https://wiki.archlinuxcn.org/wiki/%E5%86%85%E6%A0%B8)

（1）

① 先使用`uname -a`查看一下当前内核版本，如果不是你需要的，那就更换！

`uname -a`

输出

`Linux dh-ThinkPad-X240 6.4.7-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, ... x86_64 GNU/Linux`

② 以 linux-lts 为例，首先下载 linux-lts 内核：

`sudo pacman -S linux-lts linux-lts-headers`

可以选择保留或删除原有内核，若保留内核，重启后可以选择从任何一个内核启动。（建议保留）

``
（2）**重点更新grub，否则启动失败**

①不太必要的一步（这步我没改）

> 多内核时，grub生成的默认开机引导中，advanced项是折叠菜单，启动其他内核多点一次菜单。我们把advanced折叠菜单关掉：

编辑grub：

`sudo gedit /etc/default/grub`

然后修改如下三行，将子菜单展开，这样不用点击 advanced 进去了：

```
# 未修改前
GRUB_DISABLE_SUBMENU="false"
GRUB_DEFAULT="0"
GRUB_SAVEDEFAULT=true

# 修改后
GRUB_DISABLE_SUBMENU="true"
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```
② 重点：重新生成 GRUB 文件：

`sudo grub-mkconfig -o /boot/grub/grub.cfg`

或者

`sudo update-grub`

如果不重新生成 GRUB 文件会因为找不到内核而无法启动！

**注意：回到`2`添加多系统linux！**



### 4.给kde文件管理器Dolphin添加右键“以管理员身份打开”

kde文件管理器Dolphin属于用户使用的安全考虑，已经取消了右键“以管理员身份打开”菜单。经过查询，仍然有以root身份运行Dolphin解决方法，终端输入如下命令即可：

```
pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin
```
为了简便使用，我们把上述命令给添加到文件管理器Dolphin的右键中。

在目录`/usr/share/kservices5/`（全局可用）或者`/home/<username>/.local/share/kservices5/`（当前用户可用）创建一个名为`DolphinAsRoot.desktop`的文件。使用编辑器在其上放置以下内容：

```
[Desktop Entry]
Actions=root
Icon=system-file-manager-root
MimeType=inode/directory
ServiceTypes=KonqPopupMenu/Plugin
Type=Service
X-KDE-Priority=TopLevel
X-KDE-StartupNotify=false

[Desktop Action root]
Exec=/usr/bin/pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin
Icon=system-file-manager-root
Name=Open as administrator
Name[zh_CN]=以管理员身份打开
Name[zh_TW]=以管理员身份打开
```

如果仍未显示在Dolphin的上下文菜单中，请转到“设置->配置Dolphin ...->服务”，然后激活您最近添加的选项。它应该在那里。如果没有，请关闭Dolphin甚至注销并登录您的会话。

**说明：**

> `[Desktop Entry]`

>> `Actions`: 在该菜单中的菜单项，多个用英文分号隔开

>> `MimeType`: 在指定的文件类型中启动该菜单

>>> `inode/directory` ：在目录中启用

>>> `image/png` 只在png图片启用

>>> `all/allfiles`：在所有文件中启用（不包括文件夹）

>>> `image/allfiles`： 在所有图片启用

>> `Type=Service`: 表示服务，不会在开始菜单中显示， 改为Application表示应用，会显示在开始菜单

>> `X-KDE-ServiceTypes=KonqPopupMenu/Plugin`: 只在kde中支持， 表示显示在右键-动作下边

>> `X-KDE-Priority=TopLevel`： 表示显示在顶级菜单中，右键直接显示

>> `Icon Type=Service` 时图标不会显示

>> `Name`菜单项名称

>> `Name[zh_CN]`中文菜单项名称

>> `Icon`菜单显示图标

>> `Exec`点击菜单时执行的命令

>>> `%f` 文件列表。用于可一次打开多个本地文件的应用程序。每个文件都作为单独的参数传递给可执行程序。

>>> `%F` 即使选择了多个文件，也只有一个文件名（包括路径）。读取桌面条目的系统应认识到所讨论的程序无法处理多个文件参数，并且如果该程序无法处理其他文件参数，则应该为每个选定文件生成并执行该程序的多个副本。如果文件不在本地文件系统上（即，在HTTP或FTP位置），则文件将被复制到本地文件系统，%f并将展开以指向临时文件。用于不了解URL语法的程序。

如果新建无误后显示不出来的话， 执行一下`kbuildsycoca5`如果有错误会有提示。

### 5.使用 thinkfan 控制 thinkpad 风扇转速

（1） 安装 thinkfan 风扇控制器软件

首先，同时安装thinkfan和thinkfan-openrc，单个安装会报错：

`yay -S thinkfan thinkfan-openrc`

然后，安装图形界面：

`yay -S thinkfan-ui`

（2） 配 置 thinkfan, 需 要 配 置 的 文 件 为 `/etc/modprobe.d/thinkfan.conf`, 如 果 在 目 录 下 面 没 有`thinkfan.conf` 文件的话，自己新建一个就可以了(gedit,nano,vi(vim)都 ok 啦).然后编辑里面的内容：

`sudo gedit /etc/modprobe.d/thinkfan.conf`

添加下面这段内容：

`options thinkpad_acpi fan_control=1`

然后手动加载当前模块(当然也可以不加载这个模块,设置为自动启动就OK）：

```
sudo modprobe -rv thinkpad_acpi
sudo modprobe -v thinkpad_acpi
```

（3） 激活 thinkfan 的开机自动启动

终端执行：

`sudo systemctl enable thinkfan`

添加'coretemp'内核模块以在开机引导时加载：

`$ sudo sh -c 'echo coretemp >> /etc/modules'`

如果这对你来说看起来很神秘， 但这是一个在文件末尾添加'coretemp'非常简单的命令。 如果您愿意， 您可以使用自己喜欢的文本编辑器打开“模块”并自行添加“coretemp”。
由于您的更改不会在您重新启动计算机之前生效， 因此我们手动加载'coretemp'以继续配置我们的配置：

`$ sudo modprobe coretemp`

（4）设置风扇转速等级 

安装一个温度感应软件，备用：

`sudo pacman -Syu lm_sensors`

当然我们还需要让 thinkfan 知道一个温度的配置,也就是说多少温度的时候风扇级别是多少,thinkfan 是没有 UI 界面的,所以我们只能通过配置文件的形式.看下面这段配置朋友们就会明白啦,需要配置的文件为`/etc/thinkfan.conf`(当然 thinkfan 命令也支持引用其他的配置文件,即非系统默认的,请用 `thinkfan --version`查看参数列表,这里就不过多介绍啦)。查看配置文件：

`sudo gedit /etc/thinkfan.conf`

其中的这 7 行代表的就是需要修改的.

```
(0, 0, 55)
(1, 48, 60)
(2, 50, 61)
(3, 52, 63)
(4, 56, 65)
(5, 59, 66)
(7, 63, 32767)
```
格式:(风扇级别,范围最小温度,范围最大温度)， 温度在最小温度-最大温度之间时调用相应的风扇级别(切记： 三个参数中间并非空格,而是 tab 制表符而已， 否则将不生效)， 下面是摘自国内与国外网上推荐的温度设置列表。 Henry 建议根据自己的温度情况(如何查看温度情况将于下面讲解)而定制此配置列表。 当然要格外小心哦。 注意范围温度值的配置。官方给出的样例温度配置

```
(0, 0, 42)
(1, 40, 47)
(2, 45, 52)
(3, 50, 57)
(4, 55, 62)
(5, 60, 67)
(6, 65, 72)
(7, 70, 77)
(127, 75, 32767)＃ 这一行， 确保风扇全速
```
此种配置并非少写了 6 级风扇

```
(0, 0, 52)
(1, 46, 59)
(2, 54, 65)
(3, 58, 69)
(4, 62, 72)
(5, 65, 74)
(7, 68, 32767)
```
闭合式温度配置(摘自网上)

```
(0, 0, 45)
(1, 45, 48)
(2, 48, 55)
(3, 55, 58)
(4, 58, 60)
(5, 60, 63)
(6, 63, 65)
(7, 65, 32767)
```
**注：该部分如何修改， 可以参考本小节最后所附的我的整个文件的内容， 完全有效（Thinkpad X240）！**

好啦,我们可以手动去开启 thinkfan 啦,敲命令.停止就是把后面的 `start` 变为 `stop` 咯。
开启 thinkfan 服务的命令：

`sudo /etc/init.d/thinkfan start`

（5） 温度显示,接下来我们要查看当前的温度值啦.对于 ThinkPad 笔记本电脑显示所有温度传感器的值,我们敲击下面命令：

`cat /proc/acpi/ibm/thermal`

里面有一堆的数字,总之呢,第一个就是 CPU 的温度值。

（6）敲击下面命令,一路yes就ok,也可以根据自己需要,不过最后一个"**Do you want to add these lines automatically to /etc/modules? (yes/NO)**"我们要敲击 **yes**~：

`sudo sensors-detect`

完事儿后我们加载到当前内核中去,命令：

`sudo /etc/init.d/module-init-tools start`

不敲上面这段代码重启电脑也可以(貌似~~)...然后我们通过下面命令找到几个 thinkfan 取决温度的标准文件，命令：

`find /sys/devices -type f -name "temp*_input"`

我的本子找到的内容如下:

```
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp6_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp3_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp7_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp4_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp8_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp5_input
/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp2_input
/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp3_input
/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input
/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp2_input
/sys/devices/virtual/thermal/thermal_zone0/hwmon1/temp1_input
```
显示的文件取决于本子噢~~ok...取决温度的标准文件我们找到了...copy 一下,edit 一下...改为以下样子(前面都加上 hwmon 命令...中间的是空格啊~不是 tab 制表符):

```
tp_fan /proc/acpi/ibm/fan
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp6_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp3_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp7_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp4_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp8_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp5_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp2_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp3_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp2_input
hwmon /sys/devices/virtual/thermal/thermal_zone0/hwmon1/temp1_input
```
然后我们执行

`sudo gedit /etc/thinkfan.conf`

将上面这段内容 copy 到`/etc/thinkfan.conf` 文件中。

（7）使用方法

① 查看**温度等信息**，可以通过如下命令：

`sensors`

② 也可以通过下面命令查看到 thinkfan 与**风扇**的相关状态：

`cat /proc/acpi/ibm/fan`

看看效果吧...

③ 通过下面的命令可以查看**运行状态**：

`sudo thinkfan -n`

④ 但是， 无论是查看运行状态后， 还是刚编辑过 thinkfan.conf 后， 都要重新运行一次开启 thinkfan服务的命令：

`sudo /etc/init.d/thinkfan start`

完成！

### 6.显示 Intel CPU 频率（可选）不可安装，会让风扇启动失败

**安装thinkfan的用户万万不可安装[Intel P-state and CPU-Freq Manager]，其依赖libsmbios是Dell's Thermal Management Feature，会破坏thinkfan的thinkpad_hwmon温度感应**

KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

### 7.Thinkpad 笔记本安装硬盘保护模块

因thinkpad_ec原因，安装后启动不了服务。

### 8.Thinkpad 笔记本电源管理模块

Archlinux系统的KDE Plama桌面的电源管理模块已经可以进行电源阀值的设置，以及节能设置，无需另外安装tlp。

### 9.软件管理器pamac

pamac是Manjaro系统中的软件管理器，可以通过AUR安装在Arch系的系统中。

pamac 支持命令行和图形界面，“**添加/删除软件**”就是 pamac 的 GUI 版本，Pamac 有几个不同的软件包：

> `pamac-aur` - Pamac 的主体。
> `pamac-tray-icon-plasma` - 用于 KDE Plasma 的托盘图标。

执行以下命令安装 pamac： 

```
yay pamac-aur libpamac-aur
yay -S pamac-tray-icon-plasma
```

其使用教程参考以下网址：

[Manjaro Wiki -- Pamac](https://wiki.manjaro.org/index.php/Pamac/zh-cn)

需要按照如下方式启用 pamac 的 AUR 支持：

> 添加/删除软件 >> 设置（右上角的三横线图标） >> 首选项 >>第三方>> AUR >> 启用 AUR 支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build (package_name)` 获取 AUR 的软件包。

以下所有的 `yay -S` 都可以用 `pamac build`替代，或者在“**添加/删除软件**”搜索安装。

### 10.安装KDE Plasma桌面的系统监视器 ksysguard

系统监视器（KSysGuard），即KDE系统监视器，设计简单，无需特别设置即可进行简单的进程控制。它包含两张工作表：①系统负载（上面是图表）和②进程表。

系统默认**只安装了系统监视器（KSysGuard）的“进程表”组件**，“系统负载”组件没有安装。**“`Ctrl+Esc`” 能启动系统监视器的进程模块**。

若使用“系统负载”组件，需完全安装系统监视器（KSysGuard）：

`sudo pacman -Syu ksysguard`

### 11.manjaro的GUI内核和驱动管理工具

manjaro的**GUI内核管理工具**在AUR仓库中是garuda-settings-manager-git，即manjaro的Manjaro settings manager。

manjaro的**GUI驱动管理工具**是Driver Manager，在AUR仓库中没有。

不知风险，暂未安装。

### 12.轻松搞定 Linux+Win 双系统时间差异

在 Linux 下系统时间是正确的,转到 Windows 下,系统时间整整慢了 8 个小时。这是因为 Linux 默认使用网络时间,而不是读取本机硬件时钟。打开终端,输入如下命令(不需要管理员权限)：

`timedatectl set-local-rtc 1`

然后输入不加参数的时间控制命令,查看状态:

`Timedatectl`

这就设置好了。无论你在 Linux 还是 Windows,系统时间都是正确的了。
## 二、系统类软件配置及美化

### 1.安装及配置输入法fcitx5

#### 1）安装输入法 fcitx5

命令如下：

```
# 核心主体
sudo pacman -S xcb-imdkit fcitx5 fcitx5-chinese-addons fcitx5-rime fcitx5-qt fcitx5-gtk fcitx5-lua libime fcitx5-material-color fcitx5-configtool

# 下面两个是词库
sudo pacman -Syu fcitx5-pinyin-zhwiki
yay fcitx5-pinyin-moegirl
```

#### 2）安装主题

下面为`fcitx5-material-color`主题的安装及设置。`fcitx5-material-color` 提供了类似微软拼音的外观。

**（1）手动安装主题**

```
mkdir -p ~/.local/share/fcitx5/themes/Material-Color
git clone https://github.com/hosxy/Fcitx5-Material-Color.git ~/.local/share/fcitx5/themes/Material-Color
```
**（2）手动设置配色方案**

手动设置/切换配色方案需要使用命令行，比如将配色方案设置/切换为 deepPurple：

```
cd ~/.local/share/fcitx5/themes/Material-Color
ln -sf ./theme-deepPurple.conf theme.conf
```

Tips 1：第一次使用时必须设置一种配色方案（否则会打回原形）

Tips 2：设置/切换配色方案后需要重启输入法以生效

**（3）启用主题**

修改配置文件:

```
gedit ~/.config/fcitx5/conf/classicui.conf
```

如下：

```
# 垂直候选列表
Vertical Candidate List=False

# 按屏幕 DPI 使用
PerScreenDPI=True

# Font (设置成你喜欢的字体)
Font="思源黑体 CN Medium 13"

# 主题
Theme=Material-Color
```
**（4）fcitx5-material-color主题更新**

想要更新这个皮肤很简单，打开一个终端，执行以下命令：

```
cd ~/.local/share/fcitx5/themes/Material-Color
git pull
```

**（5）使用fcitx5配置工具设置主题**

以上主题的一些设置也可以通过如下步骤进行设置：

前往 `Fcitx5设置` -> `配置附加组件` -> `经典用户界面` -> `主题` 设置主题。

> 注意： 如果您在 GNOME 环境下使用了 gnome-shell-extension-kimpanel-gitAUR，那么主题设置对于 Fcitx5 不起作用。

**（6）设置单行模式**

在拼音输入法（或者 Rime 输入法）的设置中，启用“ 在程序中显示预编辑文本 ”即可启用单行模式。


#### 3）fcitx5-rime用户配置

**（1）fcitx5配置目录**

fcitx5的用户配置目录在两个文件夹中：

`~/.config/fcitx5`和`~/.local/share/fcitx5`

**（2）fcitx5-rime配置目录**

fcitx5-rime用户配置目录(这个与fcitx-rime的目录位置不同)：

`~/.local/share/fcitx5/rime`

fcitx5-rime用户配置目录(这个与fcitx-rime的目录位置相同)：

`/usr/share/rime-data`

**（3）fcitx5-rime恢复用户词库**

如果是新安装fcitx5第一次使用，先使用开始菜单“fcitx5迁移向导”从fcitx4迁移已有的用户数据到fcitx5。

这时仅迁移过去了rime的dict词典，但是用户日常使用中积累下来的词库还没有生效，需要右键点击状态栏的输入法图标，点击“同步”，然后就可以了。

fcitx5-rime的其他配置的设置（如同步、恢复词库）基本与fcitx-rime相同。

### 2.安装windows字体及等宽字体

（1）安装windows字体

首先在 home 下新建一个文件夹如 win-fonts,把想安装的 win 字体拷贝到 win-fonts 文件夹,

`sudo cp -av` 到`/usr/share/fonts/truetype/`目录下:

`sudo cp -av /home/个人文件夹/win-fonts /usr/share/fonts/truetype/`

然后添加权限:

`sudo chmod 755 /usr/share/fonts/truetype/win-fonts`

建立字体缓存:

```
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
```

（2）安装jetbrains-mono 等宽字体

`sudo pacman -Syu ttf-jetbrains-mono`

重启电脑,这样系统就知道这些字体了。

（3）设置系统字体

重启后,`开始>>设置>>系统设置>>外观>>字体`，设置系统中你想使用的字体,参考如下:

```
常规 >> 微软雅黑 10pt
固定宽度 >> jetbrains-mono 10pt
小字体 >> 微软雅黑 8pt
工具栏 >> 微软雅黑 10pt
菜单 >> 微软雅黑 10pt
窗口标题 >> 微软雅黑 10pt
抗锯齿 >> 打勾 启用
抗锯齿要排除的范围 >> 不打勾
次像素渲染方式 >> RGB
微调 >> 完全
固定字体 >> 打勾 96

```

### 3.ArchLinux 终端文字颜色设置

默认情况下，ArchLinux的终端显示是黑白的，如命令提示行（即`root@host:~#`）、`ls`显示的结果等，下面描述设置方法。

要修改 linux 终端命令行颜色，我们需要用到`PS1`，`PS1`是 Linux 终端用户的一个环境变量，用来说明命令行提示符的设置。在终端输入命令`：set`，即可在输出中找到关于`PS1`的定义。

终端直接运行颜色命令，设置只能改变当前终端的命令行格式，关闭这个终端，重新打开的一个终端中命令行格式又会恢复到默认的形式。想要永久性的改变终端命令行格式，需要修改`.bashrc`文件。

 对于普通用户，编辑`~/.bashrc`，对于root用户，可编辑`/etc/bash.bashrc`，添加或更改如下代码：

```
## terminal Css setting
PS1='\[\e[1;35m\]\u@\h:\[\e[0m\]\[\e[1;33m\]\w\[\e[1;35m\]\[\e[0m\]\[\e[1;34m\]\$ \[\e[0m\]'
# 备用样式：
# PS1='\[\e[32;1m\]\u@\h\[\e[m\]:\[\e[33m\]\w\[\e[m\]\$'
```
这条语句，然后保存，就可以永久性的改变终端命令行格式了。

参考：
* [1]:https://blog.csdn.net/apollo_miracle/article/details/116007968
* [2]:https://www.ancii.com/adj83v55p/

### 4.安装 debtab

* 参考： [《arch/manjaro安装deb包》](https://www.jianshu.com/p/3eee333687a4)

（1）首先查看电脑上是否安装过

`sudo pacman -Q debtap`

（2）安装yay工具，记得配置arch

`sudo pacman -S yay`

（3）安装解包打包工具debtap

`yay -S debtap`

 修改debtap源为国内镜像源：

```
# 打开`/usr/bin/debtap`

替换：http://ftp.debian.org/debian/dists
为：https://mirrors.ustc.edu.cn/debian/dists

替换：http://archive.ubuntu.com/ubuntu/dists
为：https://mirrors.ustc.edu.cn/ubuntu/dists/
```

（4）升级debtap

`sudo debtap -u`

（5）解包

`sudo debtap  xxxx.deb`

（6）安装

`sudo pacman -U x.tar.xz`

### 5.安装Dock栏latte

`sudo pacman -Syu latte-dock`

启动 dock ：

`latte-dock`

### 6.安装icon theme

图标推荐的是Papirus-Dark，仿steam的图标：

`sudo pacman -S papirus-icon-theme`

### 7.屏幕色温调节 redshift

注意，使用**plasma kde桌面不需要安装redshift**,kde自带“夜间颜色控制”组件。

`sudo pacman -Syu redshift`

### 8.压缩归档工具

`sudo pacman -Syu ark unace p7zip sharutils arj zip lzip unarchiver`

Dolphin 文件管理器默认使用的 ark 包右键压缩包直接解压。其可选依赖提供了各个压缩格式的支持，可以自行选择安装。

但是ark方法解压 Windows 下的压缩包可能会乱码。使用 Unarchiver 可以避免这个问题。

Unarchiver解压压缩包：

`unar xxx.zip`

### 9.杀毒软件 clamtk

`sudo pacman -Syu clamtk`

### 10.高漫M5数位板

**1）安装软件**

高漫M5数位板官方驱动是支持Win/Mac/Android的， 然而没有提供Linux驱动。

但是已有高手发现Huion(绘王)和Gaomon(高漫)数位板某些型号是相互对应的，驱动也能通用，于是乎相关软件就有了。这就好办了!

先安装几个软件，命令安装：

`sudo pacman -S xf86-input-wacom kcm-wacomtablet libwacom switchboard-plug-wacom`
 
**2）检查数位板设备**

目前的Linux内核大部分都能识别出高漫数位板了。

> 下面以高漫M5为例！

（1）首先查看设备id，终端运行:

`lsusb`

显示：

`Bus 002 Device 013: ID 256c:0064 GAOMON Gaomon Tablet`

设备id是256c:0064。也就是

```
idVendor           256c
idProduct          0064
```

（2）终端运行命令：

`sudo usbhid-dump -es -m 256c:0064 | tee frame_wheel_srolling.txt`

查看设备是否能正常上报，发现能正常上报数据，说明设备本身没有问题。

（3）在`/etc/X11/xorg.conf.d`目录下添加文件`50-digimend.conf`， 内容如下：

```
Section "InputClass"
        Identifier "Tablet"
        MatchUSBID "256c:0064"
        MatchDevicePath "/dev/input/event*"
        Driver "wacom"
EndSection
```

上面就完成了驱动适配。

拔下数位板USB连线，重启或注销一下系统，在开始菜单打开“**wacom数位板扫描工具**”就可以正常使用数位板了。

### 11.安装新版TrueCrypt加密盘软件veracrypt

veracrypt是TrueCrypt的升级版，可以使用TrueCrypt建立的加密盘的：

`sudo pacman -Syu veracrypt`

### 12.剪切板管理工具parcellite（也可不安装，plasma kde 默认使用klipper接口）

sudo pacman -Syu parcellite

### 13.温度查看工具psensor

`sudo pacman -Syu psensor`

### 14.磁盘空间分析baobab

`sudo pacman -Syu baobab`

## 三、互联网类软件配置

### 1.安装SS、SSR、v2ray、clash

#### （1）SS
`sudo pacman -Syu shadowsocks`

`sudo pacman -Syu shadowsocks-v2ray-plugin`

但是，shadowsocks图形界面用appimage版的shadpwsocks-qt5，在Archlinux上安装不上(**暂不可用图形界面**)！

于是乎，只能手动改配置文件`/etc/shadowsocks/config.json`，然后运行如下命令启动SS：

`ssserver -c /etc/shadowsocks/config.json`

#### （2）SSR

用如下命令通过AUR安装electron-ssr，**一直编译失败，安装不上**：

`yay electron-ssr`

尚未安装

**目前使用星火应用商店在linuxmint安装后的文件，复制到Archlinux可以启动！**

#### （3）v2ray

安装主体：

`sudo pacman -Syu v2ray`

安装图形界面工具nekoray：

`yay nekoray`

#### （4）clash GUI

clash 是一款非常强大的上网神器，现在在 Linux 平台下也推出了 GUI 版本。

可以直接通过 yay 安装，也可以手动安装：

`yay -S clash-for-windows-bin`

### 2.浏览器类

#### （1）Firefox

`sudo pacman -Syu firefox`

#### （2）Edge 

稳定版stable：

`yay -S microsoft-edge-stable-bin` 

开发版dev:

`yay -S microsoft-edge-dev-bin` 

#### （3）Chrome

`yay -S google-chrome`

### 3.云盘及下载类

#### （1）安装百度网盘

选择第 2 个基于 electron 的版本：

`yay -S baidunetdisk-electron`

#### （2）安装迅雷：

`yay -S xunlei-bin`

#### （3）安装deluge：

`sudo pacman -Syu deluge`

#### （4）安装aria2和uget

```
sudo pacman -Syu uget
sudo pacman -Syu aria2
```
接下来我们就改对 uget 进行一些相关配置,以便于能比单纯使用 uget 下载有更快的下载速度。

①首先开启 uget

➁依次打开界面的`编辑——>设置`,打开设置界面,切换到“`插件`”界面,然后

```
插件匹配顺序》》aria2

URI：http://localhost:6800/jsonrpc

速度限制全部0（无限制）

勾选 启动时运行aria2

勾选 退出时时关闭aria2

路径：aria2c

参数：--enable-rpc=true -D --disable-ipv6 --check-certificate=false
```
这里只需要设置这个地方就行了。

③关闭设置界面后选择主界面左边的“home”然后依次打开:`分类——右键属性`,打开属性设置窗口,切换到“新下载的`默认一般设置`”这里可以设置默认的下载路径。
然后调整最大连接数(建议 16)。

#### (5) 坚果云

`yay nutstore`

### 4.社交及新闻类

#### （1）安装腾讯QQ：

`yay -S linuxqq`

#### （2）微信

星火应用商店的修改的官方wechat-uos微信：

`yay -S com.qq.weixin.spark`

微信官方原生桌面版 WeChat desktop：

`yay -S wechat-uos`

哪个新用哪个！

## 四、影音类软件配置

### 1.图像处理类

#### （1）安装火焰截图

`sudo pacman -Syu flameshot`

#### （2）深度OCR

**编译一直出错，尚未安装**

`yay deepin-ocr-git`

#### （3）录屏软件kazam

`yay kazam`

#### （4）画图工具 mypaint

`sudo pacman -Syu mypaint`

#### （5）安装 peek录制 GIF：

`sudo pacman -Syu peek`

#### （6）屏幕量尺 kruler

`sudo pacman -Syu kruler`

#### （7）GIMP

`sudo pacman -Syu gimp`

#### （8）优麒麟wine Photoshop

下载后，使用debtap安装。

#### （9）图片查看器gwenview（系统已默认安装）

`sudo pacman -S gwenview`

### 2.影音类

#### （1）安装网易云音乐：

`yay netease-cloud-music`

#### （2）洛雪音乐助手

`yay lx-music-desktop-bin`

#### （3）视频剪辑 kdenlive

`sudo pacman -Syu kdenlive`

#### （4）安装MPV

`sudo pacman -S youtube-dl mpv`

有视频链接（网页地址也可以）的话，装好 youtube-dl和MPV，直接 用命令`mpv url` 就可以播放视频了，比如油管、B站都支持。

#### （5）资源播放器zyplayer

`yay -S zyplayer-appimage`

建议到[项目主页](https://github.com/Hunlongyu/ZY-Player)下载安装`v2.8.5`版，新版本`v2.8.8`有功能阉割（没有影视推荐模块了）！
#### （6）rhythmbox

`sudo pacman -Syu rhythmbox`

#### （7）音频剪辑audacity

`sudo pacman -Syu audacity`

## 五、办公类软件配置

### 1.office编辑类

#### （1）安装wps

执行：

``` 
yay wps-office
# 选择三个包：wps-office-cn wps-office-mui-zh-cn wps-office-mime-cn
```

#### （2）在 Arch Linux 上安装 LibreOffice

可能需要 hsqldb2-java 启用 LibreOffice Base 中的某些模块。 使用命令安装它：

`$ yay hsqldb2-java`

上面的包还需要一个 Java 运行时环境。如果您还没有，使用以下内容安装最新版本：

`$ sudo pacman -S --needed jre-openjdk`

有了这个，可以进行下一步。

安装稳定版本libreoffice-still，使用：

`$ sudo pacman -Syu libreoffice-still`

安装汉化包：

`$ sudo pacman -Syu libreoffice-still-zh-cn`

将一些附加功能添加到 LibreOffice，为此我们需要一些附加包。

要启用 Latex 工作，您需要安装以下内容：

`$ sudo pacman -Syu libreoffice-extension-texmaths libreoffice-extension-writer2latex`

接下来，我们可以安装一个用于启用拼写检查的包：

`$ sudo pacman -Syu hunspell`

您可能还想为 hunspell 安装特定于语言的词典。如果你想为 hunspell 启用美国英语词典，你可以安装它：

`$ sudo pacman -Syu hunspell-en_us`

要启用语法检查，您可以安装以下工具：

`$ yay libreoffice-extension-languagetool`

#### （3）retext

`sudo pacman -Syu retext`

#### （4）安装texstudio

`sudo pacman -Syu texstudio`

#### （5）安装 tinytex

**暂时安装失败，使用的从linuxmint系统安装后复制过来的文件！**

① 从 CTAN mirrors 选择一个镜像， 然后用 options 参数来指定， 如在终端执行如下命令，清华大学的镜像（推荐） ：

`export CTAN_REPO="https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet"`

官方源是[http://mirror.ctan.org/systems/texlive/tlnet]

然后按照谢大神写的教程 [https://yihui.org/tinytex/#for-other-users]， 执行下一步操作， 即终端继续执行如下命令：

`wget -qO- "http://yihui.org/gh/tinytex/tools/install-unx.sh" | sh`

安装过程比较漫长， 慢慢等待安装完成即可。

在安装过程中如果意外中断， 或者安装完后报错`.TinyTeX/bin/*/tlmgr: not found`， 一般也是网络问题导致的安装不完全， 重新安装即可。

② 将其添加到 path(这里如果你用的是 zsh,把 bashrc 改成 zshrc， 其他类推),方法如下：

终端执行命令

`gedit ~/.bashrc`

在打开的文件最后添加如下内容：

`export PATH=$PATH:/home/usename/.TinyTeX/bin/x86_64-linux`

执行如下命令重新部署一下：

`source ~/.bashrc`

③ 安装 XeLaTeX 中文编译引擎。 终端执行：

`sudo pacman -Syu texlive-xetex`

至此， 支持环境已经完成， 如果你不要使用 Latex 进行高级编辑，后面的可以不安装了。 如果需要， 那么就继续下面的操作！

④ 安装中文支持包， 使用的是 xeCJK， 中文处理技术也有很多， xeCJK 是成熟且稳定的一种。

`sudo pacman -Syu texlive-langchinese`

继续安装一些可能必须的模块， 终端依次执行：

`tlmgr install xecjk`

`tlmgr install ctex`

#### （6）

### 2.阅读类

#### （1）安装xournalpp

`sudo pacman -Syu xournalpp`

#### （2）电子书calibre

如果使用如下命令通过Arch源安装，会提示文件冲突，**暂不使用Arch源安装**。

`sudo pacman -Syu calibre`   //有文件冲突，暂未安装

我们**使用官方命令安装**，可以正常使用：

`sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin`

#### （3）福昕PDF阅读器

直接到官网下载linux amd64版本的安装包解压，双击安装即可！

#### （4）pdf 分割工具

`sudo pacman -Syu pdfarranger`  //有文件冲突，暂未安装

#### （5）文献阅读 cajviewer

`yay cajviewer`

### 3.笔记及记忆类

#### （1）安装vnote

`yay vnote`

#### （2）思维导图xmind

`yay xmind`

#### （3）anki

`yay anki ` (有文件冲突，暂未安装)

#### （4）词典Goldendict

`yay goldendict` 

**① 离线字典安装**

离线字典下载地址： <http://abloz.com/huzheng/stardict-dic/>

下载完成后进入文件所在目录执行下面命令：

```
tar -xjvf filename.tar.bz2
mv directory(目录名) /usr/share/goldendict/dic
```

或则执行：

`tar -xjvf filename.tar.bz2 -C /usr/share/goldendict/dic`

**② 在线字典配置**

然后， 添加有道、 Bing、 汉词、 海词等在线翻译词典（建议只添加有道在线翻译词典， 一个足矣） 。

```
在线词典： 有道词典 http://dict.youdao.com/search?q=%GDWORD%&ue=utf8
海词 http://dict.cn/%GDWORD%
汉典 http://www.zdic.net/sousuo/?q=%GDWORD%
bing http://cn.bing.com/dict/search?q=%GDWORD%
```

### 4.会议类

#### （1）安装腾讯会议：

`yay -S wemeet`


## 六、开发类软件配置

### 1.sublime-text-4

`yay sublime-text-4`

### 2.汉化文件编译poedit

`sudo pacman -Syu poedit`

### 3.python-pip

`sudo pacman -Syu python-pip python-setuptools`

消除pip3安装模块时的错误：

`sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED`

### 4.安装开源版vscodium

sudo pacman -Syu code

### 5.安装git-cola

`yay git-cola`   //有依赖错误，暂时未安装

### 6.数据库管理 sqlitebrowser

`sudo pacman -Syu sqlitebrowser`

## 七、工具类软件配置




## 八、游戏类软件配置




## 常见问题

### 系统级常见问题

### 1.sudo: service：找不到命令

在执行 sudo service 命令时遇到 `command not found` 的错误提示，可以尝试使用 systemctl 命令来代替，或者安装相应的支持包来获得 service 命令的支持。

`sudo service bluetooth start`

改为

`sudo systemctl start bluetooth`

### 2.关于很久没有更新系统，再次更新系统提示错误

先更新 archlinux-keyring 这个包：

`pacman -S archlinux-keyring`

如果也使用了 [archlinuxcn] 仓库，那把 archlinuxcn-keyring 也更新一下：

`yay -S archlinux-keyring`

最后，更新系统：

`pacman -Syyu`

### 3.启动blueman提示“bulez守护进程没有运行”

已经安装了bluez、 bluez-utils、 blueman,每次重启后再次打开blueman 都会提示“bulez守护进程没有运行”。不想使用`sudo systemctl enable bluetooth`添加开机启动项，因为添加后都会启动后自动打开蓝牙。

在`～/opt`下建目录`startbluez`，然后建一个sh脚本“`startbluez.sh`”，脚本内容如下：

```
#!/bin/bash
# 自建的bluez daemon bash脚本，用来运行.desktop

OUTPUT=$(sudo systemctl start bluetooth)    #需要执行的终端命令

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
echo "组合键 CTRL+C 终止运行脚本! ..."
echo "按任意键退出..."
echo ""
echo $OUTPUT
unset IFS       #取消分隔符依据

#任意键继续 开始
char=`get_char`
#任意键继续 结束
```

再建一个desktop文件“`启动Bluez.desktop`”用来在开始菜单点击启动上述脚本：

```
[Desktop Entry]
Categories=Settings;HardwareSettings;
Comment=Start the Bluez Bluetooth daemon
Comment[zh_CN]=启动bluez蓝牙守护进程
Encoding=UTF-8
Exec=sh /home/dh/opt/startbluez/startbluez.sh
Icon=preferences-system-bluetooth
Name[zh_CN]=启动Bluez
Name=StartBluez
Terminal=true
Type=Application

```
最后，加入开始菜单即可！

### 4.



## 附件部分

### 1.thinkfan 的 thinkfan.conf文件内容

```
######################################################################
# thinkfan 0.7 example config file
# ================================
#
# ATTENTION: There is only very basic sanity checking on the configuration.
# That means you can set your temperature limits as insane as you like. You
# can do anything stupid, e.g. turn off your fan when your CPU reaches 70°C.
#
# That's why this program is called THINKfan: You gotta think for yourself.
#
######################################################################
#
# IBM/Lenovo Thinkpads (thinkpad_acpi, /proc/acpi/ibm)
# ====================================================
#
# IMPORTANT:
#
# To keep your HD from overheating, you have to specify a correction value for
# the sensor that has the HD's temperature. You need to do this because
# thinkfan uses only the highest temperature it can find in the system, and
# that'll most likely never be your HD, as most HDs are already out of spec
# when they reach 55 °C.
# Correction values are applied from left to right in the same order as the
# temperatures are read from the file.
#
# For example:
# tp_thermal /proc/acpi/ibm/thermal (0, 0, 10)
# will add a fixed value of 10 °C the 3rd value read from that file. Check out
# http://www.thinkwiki.org/wiki/Thermal_Sensors to find out how much you may
# want to add to certain temperatures.

#  Syntax:
#  (LEVEL, LOW, HIGH)
#  LEVEL is the fan level to use (0-7 with thinkpad_acpi)
#  LOW is the temperature at which to step down to the previous level
#  HIGH is the temperature at which to step up to the next level
#  All numbers are integers.
#

# I use this on my T61p:
#tp_fan /proc/acpi/ibm/fan
#tp_thermal /proc/acpi/ibm/thermal (0, 10, 15, 2, 10, 5, 0, 3, 0, 3)

tp_fan /proc/acpi/ibm/fan
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp6_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp3_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp7_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp4_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp8_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp5_input
hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp2_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp3_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon5/temp2_input
hwmon /sys/devices/virtual/thermal/thermal_zone0/hwmon1/temp1_input

#(FAN_LEVEL, LOW, HIGH)

(0,	0,	43)
(1,	43,	46)
(2,	46,	50)
(3,	50,	55)
(4,	55,	59)
(5,	59,	63)
(6,	63,	65)
(7,	65,	32767)


```

