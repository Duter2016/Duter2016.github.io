---
layout:     post
title:      ThinkPad 安装配置 Arch Linux记录
subtitle:   基于KDE Plasma桌面
date:       2023-06-06
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
istop: true           # 设为true可把文章设置为置顶文章
music-id: 
music-idfull: 
tags:
    - Arch Linux
    - Linux
---





> Thinkpad 安装 基于Arch Linux 的 EndeavourOS

# 一、系统基础配置

## 1.1 配置镜像源

### 1.1.1 EndeavourOS镜像源

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

### 1.1.2 切换国内Arch官方镜像源

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


### 1.1.3 添加 ArchLinuxcn 中文社区仓库 

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

### 1.1.4 关于添加AUR源

**注意：不要添加AUR国内源！原来仅有清华大学提供AUR的国内镜像源，后因种种原因，已经取消了AUR的国内镜像源。**

### 1.1.5 启用multilib仓库源

编辑 `/etc/pacman.conf`，去掉下面两行前面的 # 号： 

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

## 1.2 安装update-grub及os-prober

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
目前，我的linuxmint+Arch Linux+windows通过上述步骤，成功完成引导！

（3）如果探测不到其他系统

如果两个Linux系统，其中一个不能通过`sudo update-grub`加载，比如Arch Linux不能引导Linuxmint，就把两个系统的grub引导文件`/boot/grub/grub.cfg`复制出来，然后进行整合（注意两个系统的引导部分的语句的不同的地方）。

如我把Linuxmint系统的引导部分加入Arch Linux的grub引导中，就是在Arch Linux的`/boot/grub/grub.cfg`文件中添加如下引导部分：

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

## 1.3 切换到其它内核（可选）

Arch Linux 和 AUR 上可选的内核可以参考以下网址：

[Kernel -- ArchWiki](https://wiki.archlinuxcn.org/wiki/%E5%86%85%E6%A0%B8)

（1）安装需要的内核

① 先使用`uname -a`查看一下当前内核版本，如果不是你需要的，那就更换！

`uname -a`

输出

`Linux dh-ThinkPad-X240 6.4.7-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, ... x86_64 GNU/Linux`

② 以 linux-lts 为例，首先下载 linux-lts 内核：

`sudo pacman -S linux-lts linux-lts-headers`

可以选择保留或删除原有内核，若保留内核，重启后可以选择从任何一个内核启动。（建议保留）

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

（3）删除不用的旧内核

通常情况下，如果没有安装内核模块钩子kernel-modules-hook，如果有新的内核可更新时，如果更新了内核，当前在使用的旧内核模块更新时也被删除，如果不重启，将有很多模块功能不能使用。如果安装并启用了内核模块钩子kernel-modules-hook服务，那么在更新内核时，当前在用的旧内核会被备份一份供重启之前正常使用，重启使用新内核后，该服务会自动删除不再使用的旧内核。

先查看一下系统中是否安装了内核模块钩子kernel-modules-hook：

`pacman -Q kernel-modules-hook`

如果没有安装，使用如下命令安装：

`sudo pacman -S kernel-modules-hook`

查看kernel-modules-hook服务是否运行：

`sudo systemctl status linux-modules-cleanup.service`

如果没有运行，下面设置开机自启动kernel-modules-hook服务：

`sudo systemctl enable linux-modules-cleanup.service`

**注意：**我同时安装了linux和linux-lts内核，启用kernel-modules-hook服务后，同时保留了linux和linux-lts内核的最新版本。

**如果想在升级内核后，保留旧内核不删除，禁用kernel-modules-hook服务即可：**

`sudo systemctl disable linux-modules-cleanup.service`

## 1.4 给文件管理器Dolphin添加右键“以管理员身份打开”

（1）适用于kde5的方法

① 方法一：安装` kf5-servicemenus-rootactions-git`

`yay -S kf5-servicemenus-rootactions-git`

② 手动添加dolphin右键菜单

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
`[Desktop Entry]`属性：

|属性|解释|
|-|-|
| `Actions`:| 在该菜单中的菜单项，多个用英文分号隔开|
| `MimeType`:| 在指定的文件类型中启动该菜单|
| `inode/directory` ：|在目录中启用 |
| `image/png` | 只在png图片启用|
| `all/allfiles`：|在所有文件中启用（不包括文件夹） |
| `image/allfiles`： |在所有图片启用 |
| `Type=Service`:| 表示服务，不会在开始菜单中显示， 改为Application表示应用，会显示在开始菜单|
| `X-KDE-ServiceTypes=KonqPopupMenu/Plugin`: |只在kde中支持， 表示显示在右键-动作下边 |
| `X-KDE-Priority=TopLevel`：|表示显示在顶级菜单中，右键直接显示 |
| `Icon Type=Service`|时图标不会显示 |
| `Name` | 菜单项名称|
| `Name[zh_CN]`| 中文菜单项名称|
| `Icon`| 菜单显示图标|
| `Exec` | 点击菜单时执行的命令|
| `%f` | 文件列表。用于可一次打开多个本地文件的应用程序。每个文件都作为单独的参数传递给可执行程序。|
| `%F`| 即使选择了多个文件，也只有一个文件名（包括路径）。读取桌面条目的系统应认识到所讨论的程序无法处理多个文件参数，并且如果该程序无法处理其他文件参数，则应该为每个选定文件生成并执行该程序的多个副本。如果文件不在本地文件系统上（即，在HTTP或FTP位置），则文件将被复制到本地文件系统，%f并将展开以指向临时文件。用于不了解URL语法的程序。|

如果新建无误后显示不出来的话， 执行一下`kbuildsycoca5`如果有错误会有提示。

（2）适用于KDE6的方法

现在kde版本已经升级到`6`版本,上面的方法已经无法使用。需要单独安装适用于KDE6的软件：`kf6-servicemenus-rootactions`

`yay -S kf6-servicemenus-rootactions`

## 1.5 Arch Linux 安装及配置 TLP 高级电源管理工具


### 1.5.1 tlp 与 power-profiles-daemon的选择

现在如果桌面环境（如KDE Plasma、Gnome等）都已经默认安装了power-profiles-daemon作为系统的电源及CPU管理软件。而TLP是老牌优秀的高级电源管理工具，需要用户自己安装配置。从使用来看，TLP对CPU的管控能力更胜一筹。

（1）然而，tlp 与 power-profiles-daemon 是相互冲突的，不能同时安装使用。至于tlp 与 power-profiles-daemon怎么选择，分析如下：

① 假如你是SandyBridge或IvyBridge架构的CPU，可以启动Intel_pstate驱动，来取代现在默认的Intel_cpufreq、Acpi_cpufreq驱动，以获得较好的效能与省电平衡。此时，tlp 与 power-profiles-daemon都可以使用，当然如果不怕麻烦可以使用更好的TLP。

② 假如你的CPU架构比较老，通过设置`/etc/default/grub`文件中`GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=enable"`更新内核，仍然不能启动Intel_pstate驱动，只能使用Intel_cpufreq、Acpi_cpufreq驱动，那么就只能选择使用TLP了。

（2）如何识别启用的是Intel_pstate驱动，还是Intel_cpufreq、Acpi_cpufreq驱动？

① 通过下面的命令检查intel_pstate是否开启：

`cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver`

此命令将会返回"`intel_pstate`"，就表示你的CPU使用的intel_pstate驱动，如果返回"`intel_cpufreq`
"，就表示你的CPU使用的intel_cpufreq驱动。

② 另外一种检查方式是使用下面的命令（需要安装cpupower）：

`cpupower frequency-info`

其输出将会是类似下面这样的信息：
```
analyzing CPU 0:
driver: intel_pstate
```
表示你的CPU使用的intel_pstate驱动。

（3）如果你选择使用power-profiles-daemon

thermald仅适用于英特尔CPU，并且非常专注于允许最大性能基于系统的“最高温度”。因此，它可以被视为对 power-profiles-daemon 的补充。所以如果你选择使用power-profiles-daemon，就选择同时安装上thermald，以提供更好的电源管理模式：
```
sudo pacman -S thermald
yay -S dptfxtract-bin
```

如果你选择使用TLP,安装步骤如下：


### 1.5.2 安装TLP

#### （1）卸载与tlp冲突的power-profiles-daemon

如果系统中默认安装了power-profiles-daemon。那么先禁用power-profiles-daemon.service服务，执行以下命令：

`sudo systemctl mask power-profiles-daemon.service`

然后卸载有冲突的 power-profiles-daemon 软件包：

`sudo pacman -Rs power-profiles-daemon`

或者安装TLP时，根据提示卸载也可以。

#### （2）开始安装TLP

① 对于基于 Arch Linux 的系统，使用 Pacman 命令 安装 TLP：

`sudo pacman -S tlp tlp-rdw`

tlp是节能主模块，tlp-rdw（选装）是无线电设备（如wifi、蓝牙）管理模块。

② 处理器性能与节能策略（x86_energy_perf_policy）是红帽提供设置intel cpu节能模式的工具，TLP的功能需要此软件加持。安装CPU性能与节能策略：

`sudo pacman -S x86_energy_perf_policy`

③ 安装 smartmontool 以显示 tlp-stat 中 S.M.A.R.T. 数据。

`$ sudo pacman -S smartmontools`

SMART的目的是监控硬盘的可靠性、预测磁盘故障和执行各种类型的磁盘自检。smartmontools为Linux平台提供对磁盘退化和故障的高级警告，预防硬件突然崩溃造成数据丢失。它通过使用自我监控(Self-Monitoring)、分析(Analysis)和报告(Reporting)三种技术（缩写为S.M.A.R.T或SMART）来管理和监控存储硬件。如今大部分的ATA/SATA、SCSI/SAS和固态硬盘都搭载内置的SMART系统。

④ ThinkPad 需要一些附加软件包。(**只对Thinkpad有用的功能**)

如果使用Thinkpad笔记本，且需要更优化的电池管理功能，比如充电阈值控制以及电池校准，安装下列软件包：

* tp_smapi - 电池充电阈值控制，电池校准和特殊的tlp-stat输出需要tp-smapi。

* acpi_call包 - 在Sandy Bridge及更新型号（X220/T420,X230/T430等）的电池充电阈值控制和电池校准需要acpi-call。

`sudo pacman -S tp_smapi acpi_call`

`sudo pacman -S tp_smapi-lts acpi_call-lts`

> 如果你使用的内核是`linux`内核，选择安装上面的tp_smapi和acpi_call；如果你使用的`linux-lts`内核，就选择安装tp_smapi-lts和acpi_call-lts。我在系统中同时安装了linux和linux-lts内核，我两组都安装了！x240不用安装tp_smapi、tp_smapi-lts,换用tpacpi-bat。

注意：[tp_smapi](https://github.com/linux-thinkpad/tp_smapi)冲突声明：
```
Conflict with HDAPS
-------------------
The extended battery status function conflicts with the "hdaps" kernel module
(they use the same IO ports).
You can use HDAPS=1 (see Installation) to get a patched version of hdaps which
is compatible with tp_smapi.
```

⑤ 安装threshy及其Qt图形界面 (**只对Thinkpad有用的功能**)

使用threshy(AUR)及其Qt图形界面threshy-gui(AUR)可在不使用Root权限的情况下用D-Bus控制电池充电阈值。安装命令如下：

`yay -S threshy`

`yay -S threshy-gui`

**注意：** threshy以及KDE Plasma设置中心中的充电阈值修改均不会更改/etc/tlp.conf文件中的充电阈值设置。
**threshy以及KDE Plasma设置中心中的充电阈值单次修改仅单次生效，重启、再次设置、或再次插拔电源后均会重新变为/etc/tlp.conf中的设置。**

⑥ 部分平台无法使用tp_smapi控制电池充电阈值的情况

部分2013 新出的几款 Ivy Bridge 平台的 thinkpad(X230,X240,T430,T530), 可能会遇到无法使用 tp_smapi控制电池充电阈值的情况，例如tp_smapi 可能无法支持 T430, 但是我们还有 tpacpi-bat 可以使用控制其充电阀值（安装acpi_call和tpacpi-bat）：

`sudo pacman -S acpi_call`

`sudo pacman -S acpi_call-lts`

`sudo pacman -S tpacpi-bat`

后面进行配置。

### 1.5.3  配置TLP

#### （1） 设置开机启动tlp服务

对于基于 Arch Linux 的系统，在启动时启用 TLP 和 TLP-Sleep 服务：

```
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service    //我的提示Unit file tlp-sleep.service does not exist.
```

#### （2）设置tlp-rdw服务

在使用(tlp-rdw包)之前需要使用NetworkManager并且需要启用NetworkManager-dispatcher.service:

`sudo systemctl enable NetworkManager-dispatcher.service`

也应该屏蔽 systemd 服务systemd-rfkill.service 以及套接字 systemd-rfkill.socket 来防止冲突，保证TLP无线设备的开关选项可以正确运行:

```
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
```

#### （3）安装图形化界面工具 TLPUI 管理工具

TLPUI（https://github.com/d4nj1/TLPUI）是用Python和GTK编写的TLP的图形界面，可以读取和显示TLP配置，显示默认值和未保存的更改以及加载tlp-stat以查看简单而完整的统计信息。

`yay -S tlpui`

#### （4）配置tpacpi-bat文件

**设置开机启动服务：**

`sudo systemctl enable tpacpi-bat.service`

**设置电池充电阀值：**

阅读 [README (tpacpi-bat)](https://github.com/teleshoes/tpacpi-bat)， 根据提示可以进行阀值设置了：

格式：`tpacpi-bat [-v] -s ST <bat{1,2,0}> <percent{0,1-99}>`

注意：tpacpi-bat与tp_smapi中电池编号不同：
```
# tpacpi-bat中`<bat>` 
1 for main, 2 for secondary, 0 for either/both

# tp_smapi中`<bat>` 
0 for main/内置电池, 1 for secondary/可更换电池
```

① 电池 1 开始充电阀值设置， 终端输入：

`sudo tpacpi-bat -v -s ST 1 45`

batt1 is going to change the start threshold to 45%.

② 电池 2 开始充电阀值设置， 终端输入：

`sudo tpacpi-bat -v -s ST 2 45`

batt2 is going to change the start threshold to 45%.

③ 同理， 电池 1 和 2 的停止充电阀值设置， 在终端输入：

`sudo tpacpi-bat -v -s SP 1 50`

`sudo tpacpi-bat -v -s SP 2 50`

changes the stop at 50%.

> 注意：通过以上四个命令设置的充电阈值不能写进tlp.conf，这里四个命令只能本次开机中使用。长期设置仍然需要到tlp.conf或TLPUI中设置。

重启， 生效！

**查看结果：**

查看单个阈值设置：

`sudo tpacpi-bat -v -g ST 1`

输出结果如下：
```
Call    : \_SB.PCI0.LPC.EC.HKEY.BCTG 0x1
Response: 0x32e
46 (relative percent)
```

查看全部阈值设置（其他命令同tlp）：

`sudo tlp-stat -b`

在 X240 上测试有效！ 

#### （5）配置tlp.conf文件

配置文件位于 `/etc/tlp.conf` 并默认提供高度优化的省电方案。对选项的全部解释请访问:[TLP configuration](https://linrunner.de/en/tlp/docs/tlp-configuration.html)。

我正在使用的`/etc/tlp.conf`完整文件内容，在文末的附件部分提供。

**下面是配置文件中部分要注意的部分设置选项：**

① 默认电源模式设为 BAT ，没有接通电源时采用 BAT 电源模式

`TLP_DEFAULT_MODE=BAT`

② 默认持续模式设为 0 ，根据是否接通电源来决定电源模式，若设为 1 则总是使用 TLP_DEFAULT_MODE

`TLP_PERSISTENT_DEFAULT=0`

③ CPU 性能模式设置

```
CPU_SCALING_GOVERNOR_ON_AC=schedutil
CPU_SCALING_GOVERNOR_ON_BAT=powersave
```
接通电源时，性能优先，无电源时使用 schedutil 模式(似乎是近几年出的省电又顺畅的调度模式，推荐)，另外也有 ondemand(按需，推荐)，powersave(节能)，conservative(保守供电)可选。

intel_cpufreq驱动模式下，Linux 内部共有6种对频率的管理策略conservative, ondemand, userspace, powersave, performance, schedutil(*)。

| 调速器 | 描述 |
|-|-|
|performance |运行于最大频率, 数值通过 `/sys/devices/system/cpu/cpuX/cpufreq/scaling_max_freq`.|
|powersave |运行于最小频率，数值值通过 `/sys/devices/system/cpu/cpuX/cpufreq/scaling_min_freq` 查看。|
|userspace |运行于用户指定的频率，通过 `/sys/devices/system/cpu/cpuX/cpufreq/scaling_setspeed` 配置。|
|ondemand |根据CPU的当前使用率，动态的调节CPU频率。scheduler通过调用ondemand注册进来的钩子函数来触发系统负载的估算（异步的）。它以一定的时间间隔对系统负载情况进行采样。按需动态调整CPU频率，如果的CPU当前使用率超过设定阈值，就会立即达到最大频率运行，等执行完毕就立即回到最低频率。好处是调频速度快，但问题是调的不够精确。|
|conservative |类似Ondemand，不过频率调节的会平滑一下，不会有忽然调整为最大值又忽然调整为最小值的现象。区别在于：当系统CPU 负载超过一定阈值时，Conservative的目标频率会以某个步长步伐递增；当系统CPU负载低于一定阈值时，目标频率会以某个步长步伐递减。同时也需要周期性地去计算系统负载。|
|schedutil |相比其他governor的改进点如下：基于scheduler的CPU调频策略，它直接使用来自scheduler的负载数据，之所以能做到这样，是因为在此之前内核有了负载变化回调机制（mechanism for registering utilization update callbacks），schedutil的通过将自己的调频策略注册到hook，在负载变化时候会回调该hook，此时就可以进行调频决策和甚至于执行调频动作。而ondemand、conservation都需要定期采样以计算CPU负载，具有一定的滞后性，精度也有限。实际上scheduler已经可以用PELT或者WALT去较为准确的追踪Task负载和CPU负载，现在可以直接去利用其中的CPU负载，省去了采样，使调频能更快速。支持从中断上下文直接切换频率机制，可以进一步缩短调频的时延。该特性需要driver能够支fast_switch功能。一句话总结就是：通过它，让scheduler和调频建立起更加紧密的联系，同时提升了性能和功耗表现（调频上升和下降的曲线都更加陡峭，频率更快的上升或者下降到目标频率）。调频速度`schedutil>ondemand>conservative`。|

> 参考：[Arch Linux CPU调频wiki](https://wiki.archlinuxcn.org/wiki/CPU_%E8%B0%83%E9%A2%91)、[CPU调速器schedutil原理分析](https://deepinout.com/android-system-analysis/android-cpu-related/principle-analysis-of-cpu-governor-schedutil.html)

④ CPU 相对节能模式

```
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power
```
接通电源时使用性能模式，否则省电模式，另外也有 balance_performance 和 balance_power 可选。

⑤CPU最大、最小调频范围设置

```
CPU_SCALING_MIN_FREQ_ON_AC=800000
CPU_SCALING_MAX_FREQ_ON_AC=2900000
```
安装cpupower(pacman)和cpupower-gui(yay),然后使用如下命令可以查看：

`cpupower frequency-info`

比如我的输出是`hardware limits: 800 MHz - 2.90 GHz`，然后换算成tlp.conf中的单位khz，就是`800000khz-2900000khz`。

⑥ 硬盘设置

`DISK_DEVICES="nvme0n1"`

使用 `sudo fdisk -l`查看你的硬盘名称，向我只有一块 NVMe 的固态硬盘就只需要写一个”nvme0n1”，如果你还有一块 SATA 固态，那么就应该写 “`nvme0n1 sda`”，以 fdisk 指令的结果为准。

⑦ 硬盘空闲速度设置
```
DISK_APM_LEVEL_ON_AC="254"
DISK_APM_LEVEL_ON_BAT="128"
```
设置范围是`[1,255]`，`[1,127]`会使硬盘降速，所以电源模式设置为 128 就好，注意如果你有两块硬盘，就要分别对每块硬盘设置，比如写成”`254 254`”和”`254 128`”

#### （6）关于设置后键盘灯自动亮起的问题

**注意：** Thinkpad x 系列等笔记本已经有键盘灯， 但是通过上述设置后， 还有一个问题没有解决： 就是在使用电源供电时，如果在很短的时间内不操作键盘或者鼠标（即进入空闲状态后），键盘灯总是会自动亮起！对着这个问题可以通过“系统设置-电源管理-节能”，然后点击三个选项卡，将“降低屏幕亮度”、“屏幕节能”前面的勾去掉既可以解决问题。 

### 1.5.4 TLP常用命令

|功能|命令|
|-|-|
|①查看TLP运行状态：|`sudo tlp-stat -s`|
|②显示电池信息 |`sudo tlp-stat -b`或`sudo tlp-stat --battery` |
|③显示磁盘信息 |`sudo tlp-stat -d`或`sudo tlp-stat --disk` |
|④ 显示 PCI 设备信息 |`sudo tlp-stat -e`或`sudo tlp-stat --pcie` |
|⑤显示图形卡信息 | `sudo tlp-stat -g`或`sudo tlp-stat --graphics`|
|⑥显示处理器信息 | `sudo tlp-stat -p`或`sudo tlp-stat --processor`|
|⑦ 显示系统数据信息 | `sudo tlp-stat -s`或`sudo tlp-stat --system`|
|⑧显示温度和风扇速度信息 | `sudo tlp-stat -t`或`sudo tlp-stat --temp`|
|⑨显示 USB 设备数据信息|`sudo tlp-stat -u`或`sudo tlp-stat --usb`|
|⑩ 显示警告信息 |`sudo tlp-stat -w`或`sudo tlp-stat --warn` |
|⑪ 状态报告及配置和所有活动的设置 |`sudo tlp-stat` |
|⑫ 查看使用的CPu驱动模式和调频控制器 |`sudo tlp-stat -p` |

在linux 2.6以后的内核就支持cpu频率的动态调整，有下面5种模式：

* performance将CPU频率设定在支持的最高频率,而不动态调节.
* powersave将CPU频率设置为最低
* ondemand快速动态调整CPU频率, Pentuim M的CPU可以使用
* conservative与ondemand不同,平滑地调整CPU频率,适合于用电池工作时.
* userspace用户模式，也就是长期以来都在用的那个模式。可以通过手动编辑配置文件进行配置

**参考：**

* [使用 tlp 来为 linux 省电](https://fly.meow-2.com/post/records/tlp-for-power-saving.html)
* [TLP：一个可以延长 Linux 笔记本电池寿命的高级电源管理工具](https://linux.cn/article-10848-1.html)
* [TLP wiki](https://linrunner.de/tlp/installation/arch.html)
* [Arch Linux TLP wiki](https://wiki.archlinuxcn.org/wiki/TLP)

## 1.6 使用 thinkfan 控制 thinkpad 风扇转速

（1） 安装 thinkfan 风扇控制器软件

~~首先，同时安装thinkfan和thinkfan-openrc，单个安装会报错：~~

首先，安装thinkfan：

`yay -S thinkfan`

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

`sudo sh -c 'echo coretemp >> /etc/modules'`

如果这对你来说看起来很神秘， 但这是一个在文件末尾添加'coretemp'非常简单的命令。 如果您愿意， 您可以使用自己喜欢的文本编辑器打开“模块”并自行添加“coretemp”。
由于您的更改不会在您重新启动计算机之前生效， 因此我们手动加载'coretemp'以继续配置我们的配置：

`sudo modprobe coretemp`

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

`sudo systemctl start thinkfan.service`

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

其上一行有类似如下代码，表示温度值的修正：

`tp_thermal /proc/acpi/ibm/thermal (0, 10, 15, 2, 10, 5, 0, 3, 0, 3)`

上面的温度修正数字排序和Thinkpad型号有关，各个数字表示的部件温度也各不相同，在[thinkwiki](https://www.thinkwiki.org/wiki/Thermal_Sensors)上可以查到部分型号机器的资料（比如我的x240只能探测到cpu温度，其他硬件传感器探测不到，就没有必要设置了，其他型号可以正常探测各硬件温度的，可以设置一下）。因为thinkfan根据读取到的最高温度来控制风扇。而部件温度和承受力是不一致的。比如CPU在80度下也能正常工作，而硬盘此时就会挂掉。所以对于读取到的温度值需要修正，这个括号里的数字会直接加到响应的thermal的数字上，一一对应。然后用其中修正过最大温度值进行控制。

（7）使用方法

① 查看**温度等信息**，可以通过如下命令：

`sensors`

② 也可以通过下面命令查看到 thinkfan 与**风扇**的相关状态：

`cat /proc/acpi/ibm/fan`

看看效果吧...

③ 通过下面的命令可以查看**运行状态**：

`sudo thinkfan -n`

④ 但是， 无论是查看运行状态后， 还是刚编辑过 thinkfan.conf 后， 都要重新运行一次开启 thinkfan服务的命令：

`sudo systemctl start thinkfan.service`

完成！

## 1.7 显示 Intel CPU 频率（可选）不可安装，会让风扇启动失败

**安装thinkfan的用户万万不可安装[Intel P-state and CPU-Freq Manager]，其依赖libsmbios是Dell's Thermal Management Feature，会破坏thinkfan的thinkpad_hwmon温度感应**

KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

## 1.8 Thinkpad 笔记本安装硬盘保护模块

**hdaps在我的笔记本上不能运行，提示“Could not find a suitable interface”，经项目主页查看，是因为hdapsd目前不支持较新的笔记本型号。如果你想尝试一下，可以安装下面的步骤安装一下！**

安装hdapsd：

`sudo pacman -S hdapsd`

安装图形界面工具hdaps-gl：

`yay -S hdaps-gl`

显示hdapsd状态,通过它们你很容易知道发生了些什么.

启动hdapsd：

`sudo hdapsd`

启动hdaps-gl：

`hdaps-gl`

安装hdapsd包后,通过 hdapsd@device.service 来启动 hdapsd 守护进程，但是不需要设置为开机启动:

```
sudo systemctl start hdapsd@device.service
```

## 1.9 安装硬件加速驱动

使用mpv等一些播放器时，如果开启了播放器的硬件加速功能，需要系统安装硬件加速驱动。尤其如果播放视频时CPU温度比较高，开启硬件加速可以有明显改善。

（1）我当前使用的机器是**intel核显4400**（型号不同，驱动不同，参考[Arch wiki 硬件视频加速](https://wiki.archlinuxcn.org/wiki/%E7%A1%AC%E4%BB%B6%E8%A7%86%E9%A2%91%E5%8A%A0%E9%80%9F)），使用如下命令安装硬件加速驱动：

① 安装驱动：
`sudo pacman -S libva-intel-driver`

② 安装驱动翻译层：

`sudo pacman -S libva-vdpau-driver`

`sudo pacman -S libvdpau-va-gl`

③ 查看硬件加速是否有效的软件：

`sudo pacman -S intel-gpu-tools`

运行intel-gpu-tools的命令为`intel_gpu_top`

安装libva-utils包提供命令`vainfo` 来检查 VA-API 的设置：

`sudo pacman -S libva-utils`

安装vdpauinfo包提供命令`vdpauinfo` 来检查 VA-API 的设置：

`sudo pacman -S vdpauinfo`

安装硬件加速驱动后，mpv使用硬解播放时，Xorg进程cpu占用从15%左右降至3%左右！

**注意：**使用intel核显硬件加速驱动时，如果使用MPV等播放器播放视频时，提示如下信息`[ffmpeg] AVHWDeviceContext: Cannot load libcuda.so.1 [ffmpeg] AVHWDeviceContext: Could not dynamically load CUDA`、`Cannot load libcuda.so.1`等cuda相关提示，不用处理，CUDA驱动是NVIDIA硬件驱动，与intel核显硬件加速驱动无关。

（2）**如果你使用的是其他显卡（NVIDIA/AMD），那么[参考下面的分析信息进行配置](https://blog.ddosolitary.org/posts/configure-hardware-video-acceleration-on-arch-linux/)**：

Linux配置显卡驱动相关是很麻烦的（尤其闭源驱动容易搞崩系统，其实开源驱动还好），这里仅提及开源驱动的配置，不涉及专有驱动。

目前Linux下的广泛使用的硬件加速API有两个：VA-API和VDPAU，不同应用程序的支持情况不同。

可能需要安装的相关驱动信息：

**VA-API**
- `libva-intel-driver`提供Intel核显的驱动。
- `libva-mesa-driver`提供NVIDIA和AMD的驱动。
- `libva-vdpau-driver`提供支持所有显卡的驱动，但实际上底层调用的是VDPAU，只是对API进行了翻译，所以需要配置好VDPAU才能使用。

**VDPAU**
- `mesa-vdpau`提供NVIDIA和AMD的驱动（但对于NVIDIA显卡需要安装提取自专有驱动的AUR包`nouveau-fw`）。
- `libvdpau-va-gl`提供支持所有显卡的驱动，但和`libva-vdpau-driver`相反，底层调用VA-API。

对于三种Intel/NVIDIA/AMD显卡，由上面简单分析发现各类显卡都有对应的VA-API驱动，**但Intel核显没有对应VDPAU驱动，需要`libvdpau-va-gl`调用VA-API来支持VDPAU**。安装驱动后，系统会自动选用对应的驱动，然而有时自动识别的效果不是很好（尤其是对于核显+独显的机器，系统会默认使用性能较差的核显），可以用环境变量指定使用的驱动：（下面的优先配置驱动仅供参考）

| 显卡 | LIBVA_DRIVER_NAME | VDPAU_DRIVER |
| :---: | :---: | :---: |
| Intel | i965 | va_gl |
| NVIDIA | nouveau | nouveau |
| AMD | radeonsi | radeonsi |

同时，如果是核显+独显的机器要使用独显驱动的话，还需要设置`DRI_PRIME=1`。注意这不只是针对硬件加速的设置，也会强制其他所有调用显卡的程序使用独显，所以笔记本的话会相当耗电。

## 1.10 软件管理器pamac

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

## 1.11 安装系统监视器 ksysguard

系统监视器（KSysGuard），即KDE系统监视器，设计简单，无需特别设置即可进行简单的进程控制。它包含两张工作表：①系统负载（上面是图表）和②进程表。

系统默认**只安装了系统监视器（KSysGuard）的“进程表”组件**，“系统负载”组件没有安装。**“`Ctrl+Esc`” 能启动系统监视器的进程模块**。

若使用“系统负载”组件，需完全安装系统监视器（KSysGuard）：

`sudo pacman -Syu ksysguard`

## 1.12 manjaro的GUI内核和驱动管理工具

manjaro的**GUI内核管理工具**在AUR仓库中是garuda-settings-manager-git，即manjaro的Manjaro settings manager。

manjaro的**GUI驱动管理工具**是Driver Manager，在AUR仓库中没有。

不知风险，暂未安装。

## 1.13 轻松搞定 Linux+Win 双系统时间差异

在 Linux 下系统时间是正确的,转到 Windows 下,系统时间整整慢了 8 个小时。这是因为 Linux 默认使用网络时间,而不是读取本机硬件时钟。打开终端,输入如下命令(不需要管理员权限)：

`timedatectl set-local-rtc 1`

然后输入不加参数的时间控制命令,查看状态:

`Timedatectl`

这就设置好了。无论你在 Linux 还是 Windows,系统时间都是正确的了。

## 1.14 禁用编译安装软件时生成安装-debug软件包

通常，为了让可执行文件尽可能小，会在编译和链接时移除和运行无关的调试信息。这种可执行文件的栈回溯信息非常少，所以在调试软件或者报告 Bug 的时候，需要安装带调试信息的版本。

如果使用AUR或Pacman（从 4.1 开始）安装软件时进行编译安装，默认会使用 `etc/makepkg.conf` 中的 DEBUG_CFLAGS 和 DEBUG_CXXFLAGS 编译标志，会强制编译调试信息，并在安装软件时（如abc），同时安装软件abc-debug。慢慢积累，会使系统中多出若干软件，占用空间比较大！

可以通过如下方法禁用编译安装软件时生成安装-debug软件包，在 `/etc/makepkg.conf` 中。在以 `OPTIONS=` 开头的行中，将 `debug` 更改为 `！debug`：

```
OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)
```

# 二、系统类软件配置及美化

## 2.1 安装及配置输入法fcitx5

### 2.1.1 安装输入法 fcitx5

命令如下：

```
# 核心主体
sudo pacman -S xcb-imdkit fcitx5 fcitx5-chinese-addons fcitx5-rime fcitx5-qt fcitx5-gtk fcitx5-lua libime fcitx5-material-color fcitx5-configtool

# 下面两个是词库
sudo pacman -Syu fcitx5-pinyin-zhwiki
yay fcitx5-pinyin-moegirl

# 启用英文输入提示功能，需要开启英语键盘输入法中的拼写检查和提示功能，
# 此时需要安装英文拼写检查语言包aspell-en
sudo pacman -S aspell-en
```

然后，设置输入法集成环境：

编辑 `/etc/environment` 并添加以下几行，然后重新登录：
```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```

或者在`/home/<username>/`目录下， 于隐藏文件“`.xprofile`” （若没有自己建一个） 里， 添加如下命令：
```
export LC_ALL=zh_CN.utf-8
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
```

### 2.1.2 安装主题

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


### 2.1.3 fcitx5-rime用户配置

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

### 2.1.4 解决 Fcitx5 中文输入法无法输入全角中括号【】

新安装的 fcitx5， 在中文输入法状态时， `[`和`]`打出的字符为`·` 和`「 」` 。

编辑`/usr/share/fcitx5/punctuation/punc.mb.zh_CN` 文件。 将

```
[ ·
] 「 」
```
改成

```
[ 【
] 】
```
然后， 保存后重启 fcitx5 即可。

## 2.2 安装windows字体及等宽字体

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

（2）安装jetbrains-mono 等宽、emoji字体等

`sudo pacman -S ttf-jetbrains-mono`

`sudo pacman -S noto-fonts-emoji`

（3）安装字体渲染

`sudo pacman -S freetype2`

（4）设置系统字体

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

## 2.3 系统美化及优化


### 2.3.1 Arch Linux 终端文字颜色设置

默认情况下，Arch Linux的终端显示是黑白的，如命令提示行（即`root@host:~#`）、`ls`显示的结果等，下面描述设置方法。

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
* [https://blog.csdn.net/apollo_miracle/article/details/116007968]
* [https://www.ancii.com/adj83v55p/]

### 2.3.2 Linux 终端命令补全及 Bashmarks 命令书签功能

**常规技巧：**

在 linux 的 shell 命令行中， 当输入字符后， 按`两次 Tab 键`， shell 会列出一输入字符打头的所有可用命令， 如果匹配的命令只有一个时， 按`一次 Tab 键`就自动将该命令补齐。

除了命令补全之外， 还有路径、 文件名、 目录名补全， 比如使用 `cd` 切换到指定的目录和 `ls`查看指定的文件等。 但我们找到文件夹或文件时， 需要使用完整的路径， 不高效， 常见的定位一个目录的步骤是， 先执行一下 `cd`， 再执行`ls`，然后来回在这两个命令中切换，当记忆卡壳的时候，还会使用`find`命令。我们在使用浏览器时，会使用书签来解决“寻址”的问题，那为什么不能把这种方法用在 shell 中呢？

这时我们可以使用 [Bashmarks](https://github.com/bachya/bashmarks) 。 Bashmarks 是一个bash shell脚本，它可以帮你保存经常使用的目录，并在它们之间跳转。更奇妙的是，它还支持tab自动补全，以及它只有5个简单的命令，所以你根本不需要去记忆它。

（1） 在终端依次执行如下命令， 安装 Bashmarks：

```
mkdir temp && cd temp
git clone git://github.com/huyng/bashmarks.git
cd bashmarks
make install
echo "source ~/.local/bin/bashmarks.sh" >> ~/.bash_profile
source ~/.bash_profile
```

（2） 安装完成后，可以使用，但重启后，Bashmarks 会无效，并且命令 BS 的“l” 和系统默认的命令“l” 冲突，我们需要做如下修改：

① 将文件 `/home/username/.local/bin/bashmarks.sh` 内的内容复制粘贴到文件`/home/username/.bashrc` 的最后， 使 Bashmarks 命令生效；

②将文件`/home/username/.bashrc` 中如下命令注释掉，

`alias l='ls -CF'`

即修改为

`# alias l='ls -CF'`

保存即可。 重启启动终端窗口就生效了！

（3） 可用命令：

```
s <bookmark_name> - 将当前目录的书签名保存为"bookmark_name"
g <bookmark_name> - 切换到书签为 "bookmark_name"的目录下
p <bookmark_name> - 打印出"bookmark_name"对应的目录
d <bookmark_name> - 删除指定的目录书签
l - 列出所有的书签
```

先 `cd` 到一个目录后， `s` 命令保存该目录为书签后， 才能使用其他命令哦！

### 2.3.3 安装Dock栏latte

`sudo pacman -Syu latte-dock`

启动 dock ：

`latte-dock`

### 2.3.4 安装icon theme

图标推荐的是Papirus-Dark，仿steam的图标：

`sudo pacman -S papirus-icon-theme`

### 2.3.5 屏幕色温调节 redshift

注意，使用**plasma kde桌面不需要安装redshift**,kde自带“夜间颜色控制”组件。

`sudo pacman -Syu redshift`

## 2.4 系统辅助工具

### 2.4.1 安装 debtab

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

### 2.4.2 压缩归档工具

`sudo pacman -Syu tar gzip ark unace p7zip sharutils arj zip unzip lzip unarchiver`

`yay -S p7zip-gui`

Dolphin 文件管理器默认使用的 ark 包右键压缩包直接解压。其可选依赖提供了各个压缩格式的支持，可以自行选择安装。

但是ark方法解压 Windows 下的压缩包可能会乱码。使用 Unarchiver 可以避免这个问题。

Unarchiver解压压缩包：

`unar xxx.zip`

**参考：**[Arch wiki 归档与压缩](https://wiki.archlinuxcn.org/wiki/%E5%BD%92%E6%A1%A3%E4%B8%8E%E5%8E%8B%E7%BC%A9)

### 2.4.3 杀毒软件 clamtk

安装杀毒软件：

`sudo pacman -Syu clamtk`

**杀毒软件clamTK使用http代理更新病毒库的方法：**

Clamtk在安装完成后，一般情况下，如果不设置一下网络fq，是很难更新病毒库成功的。目前，我还不清楚是什么原因，但是通过努力找到了解决病毒库更新难的办法：通过安装privoxy，通过设置，把SSR的socks5转换为http代理，让clamtk使用http代理更新病毒库。

具体方法如下：

（1）安装并配置[privoxy](https://gist.github.com/xwsg/5ecd015be95a61875d43df87c451aca4)

①安装 privoxy

```
yay -S privoxy
```

②配置 privoxy

```
sudo gedit /etc/privoxy/config 
```

用`#`注释掉：`listen-address  localhost:8118`

在最后一行添加：

```
forward-socks5t  /  127.0.0.1:1080 .
listen-address  127.0.0.1:8118
```

注：第一行最后有一个英文句号，不要漏了。

`127.0.0.1:1080` 为 socks5代理地址及端口

`127.0.0.1:8118` 为转换为http 代理后的地址及端口，8118如果被占用，可以修改，比如10800， 方便记忆。

③启动 privoxy

```
sudo systemctl enable privoxy
sudo systemctl start privoxy
```

④配置自定义快捷命令

```
sudo gedit ~/.bashrc
```

(如果使用的是zsh 修改`sudo gedit ~/.zshrc`)

添加:

```
alias proxyon="export http_proxy='http://127.0.0.1:8118'; export https_proxy=$http_proxy"
alias proxyoff="unset http_proxy; unset https_proxy"
```

使配置生效:

```
source ~/.bashrc
```

(或如果使用的zsh: `source ~/.zshrc`）

⑤开起了SSR的代理后，后续开启代理使用`proxyon`命令即可，关闭代理使用`proxyoff`。

⑥检验privoxy的http代理是否可用：

在终端执行命令：

```
curl --connect-timeout 2 -x 127.0.0.1:8118 http://google.com
```

如果出现如下代码，说明http代理成功：

```
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

（2）设置clamtk代理

网络--》手工设置--》

IP地址或域名： `http://127.0.0.1`

端口号：`8118`

--》应用

最后，在更新助手里设置为手动更新，再次点击更新，就可以了！

### 2.4.4 剪切板管理工具parcellite

**（也可不安装，plasma kde 默认使用klipper接口）**

sudo pacman -Syu parcellite

### 2.4.5 温度查看工具psensor

`sudo pacman -Syu psensor`

### 2.4.6 磁盘空间分析baobab

`sudo pacman -Syu baobab`

### 2.4.7 安装 Guake 下拉终端

`sudo pacman -S guake`

在wayland环境下，全局`切换guake终端是否可见`的快捷键`F12`在激活某些窗口（如Dolphin、Google-Chrome等）的情况下，快捷键`F12`不能成功`切换guake终端是否可见`，因为与某些窗口（如Dolphin、Google-Chrome等）自身的快捷键冲突。但是我们可以自己为guake添加注册全局快捷键，通过打开`设置--系统设置--键盘--快捷键`，然后点击`+新增--命令或者脚本`打开`添加命令窗口`，粘贴如下命令

```
guake --toggle-visibility
```
然后，点击选择刚添加的命令，再在右边的窗口中点击`添加自定义快捷键`，然后根据提示按下`F12`键，应用即可完成全局快捷键的注册。

## 2.5 系统外设硬件设置

### 2.5.1 高漫M5数位板

**（1）安装软件**

高漫M5数位板官方驱动是支持Win/Mac/Android的， 然而没有提供Linux驱动。

但是已有高手发现Huion(绘王)和Gaomon(高漫)数位板某些型号是相互对应的，驱动也能通用，于是乎相关软件就有了。这就好办了!

先安装几个软件，命令安装：

`sudo pacman -S xf86-input-wacom kcm-wacomtablet libwacom switchboard-plug-wacom`
 
**（2）检查数位板设备**

目前的Linux内核大部分都能识别出高漫数位板了。

> 下面以高漫M5为例！

① 首先查看设备id，终端运行:

`lsusb`

显示：

`Bus 002 Device 013: ID 256c:0064 GAOMON Gaomon Tablet`

设备id是256c:0064。也就是

```
idVendor           256c
idProduct          0064
```

② 终端运行命令：

`sudo usbhid-dump -es -m 256c:0064 | tee frame_wheel_srolling.txt`

查看设备是否能正常上报，发现能正常上报数据，说明设备本身没有问题。

③ 在`/etc/X11/xorg.conf.d`目录下添加文件`50-digimend.conf`， 内容如下：

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

### 2.5.2 配置插入鼠标禁用触摸板功能

> 下面的设置只在 Xorg 中有效！在 Wayland 上,没有关于 libinput 的配置文件，只能在系统设置图形界面中进行有限的设置。

Arch Linux在刚安装好，时默认是安装了xf86-input-libinput和libinput的，一般不需要手动安装。并且可以在`设置>>系统设置>>输入设备>>触摸板`中设置很多项，如“打字时禁用”等。

如果没有安装，用以下命令安装一下：

```
sudo pacman -S xf86-input-libinput
sudo pacman -S libinput
```

其默认的配置文件安装在 `/usr/share/X11/xorg.conf.d/40-libinput.conf`。

用编辑器打开该文件，找到包含`MatchIsTouchpad "on"`的section部分：
```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection
```
添加当检测到 USB 鼠标时，它将禁用触摸板的option：

`Option "SendEventsMode" "disabled-on-external-mouse"`

即：
```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "SendEventsMode" "disabled-on-external-mouse"
EndSection
```

然后重启或注销一下就可以了！

### 2.5.3 安装新版TrueCrypt加密盘软件veracrypt

veracrypt是TrueCrypt的升级版，可以使用TrueCrypt建立的加密盘的：

`sudo pacman -Syu veracrypt`

# 三、互联网类软件配置

## 3.1 安装SS、SSR、v2ray、clash、goflyway

### 3.1.1 SS
`sudo pacman -Syu shadowsocks`

`sudo pacman -Syu shadowsocks-v2ray-plugin`

但是，shadowsocks图形界面用appimage版的shadpwsocks-qt5，在Arch Linux上安装不上(**暂不可用图形界面**)！

于是乎，只能手动改配置文件`/etc/shadowsocks/config.json`，然后运行如下命令启动SS：

`ssserver -c /etc/shadowsocks/config.json`

### 3.1.2 SSR

用如下命令通过AUR安装electron-ssr，**一直编译失败，安装不上**：

`yay electron-ssr`

尚未安装

**目前使用星火应用商店在linuxmint安装后的文件，复制到Arch Linux可以启动！**

### 3.1.3 v2ray

安装主体：

`sudo pacman -Syu v2ray`

安装图形界面工具nekoray：

`yay -S nekoray`

默认使用Xray核心，如果想使用sing-box核心，还需要安装sing-geosite 和 sing-geoip：

`yay -S sing-geosite sing-geoip`

不过推荐使用Xray核心，因为sing-box核心对部分协议存在兼容性问题。

### 3.1.4 clash GUI

(1)clash-for-windows-bin （已停止维护，但已安装的仍可用）

clash 是一款非常强大的上网神器，现在在 Linux 平台下也推出了 GUI 版本。

可以直接通过 yay 安装，也可以手动安装：

`yay -S clash-for-windows-bin`

安装的clash-for-windows-bin是原始未汉化的。可以在Clash for Windows原版汉化项目[Clash_Chinese_Patch](https://github.com/BoyceLig/Clash_Chinese_Patch/releases)下载汉化补丁文件`app.7z` 或 `app.zip` 文件(两个压缩包内容一样)后，解压压缩包，请自行替换下列路径中的 app.asar 文件即可：

`/opt/clash-for-windows-bin/resources/app.asar`

**注意：**使用的Clash_Chinese_Patch汉化补丁版本号必须与安装的clash-for-windows-bin版本号一致。

（2）`clash-meta` + `clash-verge`（推荐使用，一直维护更新中）

`clash-verge`是clash的内核，`clash-verge`是`clash-meta`的GUI界面程序。

`yay -S clash-meta clash-verge`

### 3.1.5 Goflyway

（1）下载Goflyway

到项目主页下载Goflyway文件“goflyway_linux_amd64.tar.gz”：

[https://github.com/coyove/goflyway/releases](https://github.com/coyove/goflyway/releases)

下载后，将下载的文件解压到`/home/<username>/opt/goflyway/`目录，终端下`chmod a+x`或者用文件管理器给予可执行权限：

`chmod a+x goflyway`

（2）启动goflyway有两种方法：

A.第一种：直接显示运行状态

①` /goflyway`目录下，右键启动终端，执行如下命令（直接显示运行状态）：

`./goflyway -up="cf://服务器地址:端口" -k="密码" -l="127.0.0.1:1080"`

在服务器地址、端口、密码的位置换成你要设定的服务器地址、端口和密码。

② 如果想停止运行：快捷键组合Ctrl+C

B.第二种：单独查看运行状态

①执行如下命令（单独查看运行状态）：

`./goflyway -up="cf://服务器地址:端口" -k="密码" -l="127.0.0.1:1080" > /tmp/goflyway.log 2>&1 &`

在服务器地址、端口、密码的位置换成你要设定的服务器地址、端口和密码。

②如果想查看软件运行状况，就看日志：

`tail -f /tmp/goflyway.log`

③如果想停止运行：

```
{% raw %} 
kill -9 $(ps -ef|grep "goflyway"|grep -v grep|awk '{print $2}')
{% endraw %}
```

## 3.2 浏览器类

### 3.2.1 Firefox

`sudo pacman -Syu firefox`

### 3.2.2 Edge 

稳定版stable：

`yay -S microsoft-edge-stable-bin` 

开发版dev:

`yay -S microsoft-edge-dev-bin` 

### 3.2.3 Chrome

`yay -S google-chrome`

## 3.3 云盘及下载类

### 3.3.1 安装百度网盘

选择第 2 个基于 electron 的版本：

`yay -S baidunetdisk-electron`

### 3.3.2 安装迅雷：

`yay -S xunlei-bin`

### 3.3.3 安装deluge：

`sudo pacman -Syu deluge`

### 3.3.4 安装aria2和uget

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

### 3.3.5 坚果云

`yay nutstore`

## 3.4 社交及新闻类

### 3.4.1 安装腾讯QQ：

`yay -S linuxqq`

### 3.4.2 微信

星火应用商店的修改的官方wechat-uos微信：

`yay -S com.qq.weixin.spark`

微信官方原生桌面版 WeChat desktop：

`yay -S wechat-uos`

哪个新用哪个！

### 3.4.3 邮箱客户端 Imap 协议下“已删除” 及“已发送” 目录的设置

以Thunderbird为例，其他邮箱客户端大同小异。

在 Thunderbird 中使用 QQ 邮箱的 Imap 服务时（使用 POP3 的，可忽略） ， 要注意一下“已删除” 及“已发送” 邮件在 Thunderbird 中的配置，Thunderbird 默认是把删除的邮件放在“垃圾” 文件夹下面， 但是这样删除的邮件无法同步到QQ 邮箱中。 这时， 你需要把如下图所示的“服务器设置” 中的“在删除消息时” ——“将之移到此文件夹中” 选择为“****的 Deleted Messages” 即可。 这样， 就可以同步到 QQ 邮箱服务器了！

同样， 及“已发送” 邮件的目录需要选择“Sent Messages” 目录， 而不是默认的“sent” 目录。

### 3.4.4 IRC 通信软件 Hexchat

`sudo pacman -S hexchat`

给 IRC 通信软件 Hexchat 配置脚本:

插件或脚本可以在如下项目地址进行下载： [https://github.com/hexchat/hexchat-addons](https://github.com/hexchat/hexchat-addons)。

然后，在如下目录`/home/username/.config/hexchat/`下新建文件夹`addons` ， 即`/home/username/.config/hexchat/addons`。 然后把你需要的脚本放在这个文件夹里， 重启 Hexchat 就加载上了！ 我使用的脚本主要为如下几个：

```
alias.lua           filter.py           keepdialogs.lua  onoticeformat.py   shortnicks.py
at.py               follow.py           match.lua        passwordmask.py    slap.py
blinkonprivate.py   input-r-search.lua  nicenicks.py     quotes.py          statusmsg.py
clones.lua          isbanned.py         nickspy.py       rainbow.pl         twitch_enhancements.py
emoji-slack-fix.py  joinparttab.py      nignore.py       sharedchannels.py  url_highlight.pl
```

# 四、影音类软件配置

## 4.1 图像处理类

### 4.1.1 安装火焰截图

`sudo pacman -Syu flameshot`

### 4.1.2 深度OCR

**编译一直出错，尚未安装**

`yay deepin-ocr-git`

### 4.1.3 录屏软件

（1）vokoscreenNG

`sudo pacman -S vokoscreen`

（2）kazam （python升级3.12后已无法使用）

`yay -S kazam`

### 4.1.4 画图工具 mypaint

`sudo pacman -Syu mypaint`

### 4.1.5 安装GIF录屏软件：

（1）Kooha

`sudo pacman -Syu kooha`

（2）peek （项目已经弃置，无法运行，暂无修复）

`sudo pacman -Syu peek`

### 4.1.6 屏幕量尺 kruler

`sudo pacman -Syu kruler`

### 4.1.7 GIMP

`sudo pacman -Syu gimp`

### 4.1.8 优麒麟wine Photoshop

下载后，使用debtap安装。

### 4.1.9 图片查看器gwenview

（系统已默认安装）

`sudo pacman -S gwenview`

## 4.2 影音类

### 4.2.1 安装网易云音乐：

`yay netease-cloud-music`

### 4.2.2 洛雪音乐助手

`yay lx-music-desktop-bin`

### 4.2.3 视频剪辑 kdenlive

`sudo pacman -Syu kdenlive`

### 4.2.4 安装MPV

（1）安装MPV基础功能

`sudo pacman -S youtube-dl mpv`

也可以同时安装上youtube-dl的带有附加特性和修复的fork版yt-dlp(支持设置一些参数)：

`sudo pacman -S yt-dlp`

> 测试发现，如果仅安装youtube-dl，播放B站视频时，使用的AVC1（H264）解码，安装yt-dlp后，使用了HEVC解码，CPU占用骤降！

有视频链接（网页地址也可以）的话，装好 youtube-dl和MPV，直接 用命令`mpv url` 就可以播放视频了，比如油管、B站都支持。

（2）为MPV添加播放器常用lua脚本

mpv可使用的Lua脚本信息汇总：[Lua Scripts](https://github.com/mpv-player/mpv/wiki/User-Scripts)

MPV脚本配置目录为`/home/<username>/.config/mpv/`，其下面相关目录及文件说明：

```
mpv.conf 用户配置文件
input.conf 键盘快捷键
fonts.conf 字体配置文件
fonts 存放字幕需要使用的字体
scrpits 存放用户外挂脚本插件
scrpit-opts 存放外挂脚本插件配置文件
```

① 为MPV添加丰富的UI控件

按照项目[UOSC](https://github.com/tomasklaen/uosc)进行设置。如果还想使用mpv原始的外观窗口边框，按照项目指引设置时，注意mpv.conf中参数设置`border=no`即可。

② 为MPV添加画质选择菜单

按照项目[mpv-quality-menu](https://github.com/christoph-heinrich/mpv-quality-menu)进行设置。

③ 为MPV添加高性能动态缩略图

按照项目[thumbfast](https://github.com/po5/thumbfast)进行设置。注意，动态缩略图默认只对本地视频有效，对在线视频大部分不支持，如果想要支持在线视频动态缩略图，需将`.config/mpv/script-opts/thumbfast.conf`中参数`network=no`改为`network=yes`。

④ 为MPV添加最近播放、历史播放

有两个lua脚本可以使用，任一个都一个：[【memo】](https://github.com/po5/memo)和[【recent】](https://github.com/hacel/recent)。

A.【memo】:

推荐使用这个mome脚本！这个脚本附带了一个简单的菜单，可以与 uosc 整合界面，在界面上添加历史播放控件按钮，也可以使用默认的热键`h`打开历史播放菜单。按照项目[memo](https://github.com/po5/memo)进行设置即可：

首先，将`memo.lua`放到`/home/<username>/.config/mpv/scripts/`目录下，将`memo.conf`放到`/home/<username>/.config/mpv/script-opts/`目录下。

然后，为uosc添加memo菜单或按钮（二选一即可）：

**添加按钮：**在时间线上方添加一个历史按钮，编辑`/home/<username>/.config/mpv/script-opts/uosc.conf`文件，找到`controls=`代码行，在`controls=`行最后添加如下代码（注意用英文逗号分割）：

`command:history:script-binding memo-history?History` 

**添加菜单：**编辑`/home/<username>/.config/mpv/input.conf`文件，添加如下一行代码即可（点击左下角三道线即是）：

```
# script-binding memo-history #! History
```
也可以使用[recent-menu](https://github.com/natural-harmonia-gropius/recent-menu)，可以与uosc集成，添加菜单或按钮。

B.【recent】:

如果没有使用UOSC,可以recent。按照项目[recent](https://github.com/hacel/recent)进行设置。然后将`/home/<username>/.config/mpv/script-opts/recent.conf`中设置`auto_save_skip_past=100`。

**最近播放菜单控制:**

* 默认显示热键 **`` ` ``**
* 键盘操作:
    * `UP`/`DOWN` 上下选择
    * `ENTER` 打开高亮媒体
    * `DEL` 删除高亮记录
    * `0`-`9` 快速选择
    * `ESC` 退出
* 鼠标操作:
    * `WHEEL_UP`/`WHEEL_DOWN` 滚动选择
    * `MBTN_MID` 打开高亮媒体（默认是中键打开，如果是从github获取可在脚本中搜索MBTN_MID修改）
    * `MBTN_RIGHT` 退出

⑤ 将同目录播放媒体文件自动载入playlist

自动载入当前播放媒体文件所在目录下的所有同类型媒体文件，依名称排序。下载文件[autoload.lua](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua)放在`/home/<username>/.config/mpv/scripts`目录下。

脚本选项设置`/home/<username>/.config/mpv/script-opts/autoload.conf`，可以比较方便修改自动加载哪一类文件：

```
#禁用autoload脚本
disabled=no
#图片
images=no
#视频
videos=yes
#音频
audio=yes
#忽略隐藏文件
ignore_hidden=yes
```

⑥ 为MPV添加右键菜单脚本

这个稍微比较麻烦，需要tcl支持，上面下载好之后放到环境变量文件夹。

下载脚本文件夹[MPV_lazy](https://github.com/hooke007/MPV_lazy/tree/main/portable_config/scripts/contextmenu_gui)到mpv的配置目录`/home/<username>/.config/mpv/scripts/contextmenu_gui`，即 contextmenu_gui 文件夹位于 scripts 内。

在[MPV_lazy_script-opts](https://github.com/hooke007/MPV_lazy/tree/main/portable_config/script-opts)下载如下两个脚本配置文件放在`/home/<username>/.config/mpv/script-opts`目录下：A.`contextmenu_gui_engine.conf` 该文件设定菜单所用的默认字体，其中，必须保证 tcltkBin 指向你实际下载使用的tcl/tk二进制文件 默认值为 tclsh。B.`contextmenu_gui.conf` 提供了可自定义的空档位滤镜/着色器各十个，可以根据示例和说明进行适配你的本机修改。

编辑`.config/mpv/input.conf`键盘快捷键配置，添加如下代码，将鼠标右键设置为菜单（原默认右键为暂停）、回车键为全屏、鼠标左键双击为暂停：

```
#右键唤起菜单，也可以根据自己的喜好换成别的按键。
MOUSE_BTN2   script-message-to contextmenu_gui contextmenu_tk
# 全屏切换(回车键及小键盘确认键)
Enter    cycle fullscreen
KP_ENTER  cycle fullscreen
# 双击左键 播放/暂停
MBTN_LEFT_DBL  cycle pause
```

⑦ mpv窗口置顶插件

下载[ontop-playback.lua](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/ontop-playback.lua)脚本文件放在`/home/<username>/.config/mpv/scripts/`目录下，然后在`/home/<username>/.config/mpv/mpv.conf`中添加如下参数：

```
#设置置顶播放
ontop=yes
```
其作用如下：使 MPV 在暂停时禁用置顶，并在恢复播放时重新启用置顶；请注意，如果在暂停之前没有启用 ontop，那么它将不会执行任何操作。

⑧ 控制Youtube视频加载画质

使用mpv播放youtube视频时，默认是直接自动播放youtube可以加载的最高画质的视频格式，但是我们如果不想自动加载最高画质，而是自动加载我们指定的画质，就要使用[mpv-ytdlautoformat](https://github.com/Samillion/mpv-ytdlautoformat)。把文件`ytdlautoformat.lua`放到`/home/<username>/.config/mpv/scripts/`目录下即可。

其默认设置是如果URL是Youtube或Twitch, ytdl-format 设置是: `480p, 30 FPS and no VP9 codec` 。no VP9 codec是脚本默认的，但可修改，编辑`ytdlautoformat.lua` 文件`local enableVP9 = true`，即可允许使用VP9 codec。

⑨ 使用mpv自动下载B站弹幕并加载

linux系统下使用方法如下：

在[MPV-Play-BiliBili-Comments-Plus](https://github.com/Duter2016/MPV-Play-BiliBili-Comments-Plus)下载`scripts/bilibiliAssert`下面的三个脚本文件到mpv的配置目录`/home/<username>/.config/mpv/scripts/bilibiliAssert`，然后修改如下两个文件：

将`～/.config/mpv/scripts/bilibiliAssert/GetBiliDanmuCID.py`中如下代码中`dh`替换为你的`<pc username>`

`file = open("/home/dh/.config/mpv/scripts/bilibiliAssert/bilicid", 'w')`

然后，命令别名 alias：

打开用户配置文件 `~/.bash_profile` ， 在文件最后添加如下 alias（注意是英文半角单引号，mpvb名字可以自定义）：
```
# 添加qt6的qdbus的PATH，否则klipper的qdbus通信失败
export PATH=$PATH:/usr/lib/qt6/bin
# mpv带弹幕播放在线视频
alias mpvb='mpv $(qdbus org.kde.klipper /klipper org.kde.klipper.klipper.getClipboardContents)'
```
上面剪贴板参数根据你使用的剪贴板工具，自己修改为以下可参考的对应参数：

* Plasma KDE桌面默认剪切板工具为`$(qdbus org.kde.klipper /klipper org.kde.klipper.klipper.getClipboardContents)`
* Parcellite 为 `$(parcellite --clipboard)`
* xclip 为 `$(xclip --clipboard)`
* xsel 为 `$(xsel --clipboard)`

保存后回到命令行执行以下命令使其生效：
`source ~/.bash_profile`

**使用方法：**

这里我们假设已经在网页复制了B站视频网址到剪贴板中，则在终端执行如下命令就可以立即播放了：

`mpvb`

或者用mpv原始的命令也可以：

`mpv <url>`

mpv播放后将会自动加载弹幕，按下按键`b`会重新载入弹幕,弹幕以字幕方式加载，如需隐藏按下`v`即可。如果希望更改快捷键，在main.lua中最后一行修改想要的快捷键。

也可以为uosc添加memo菜单：

编辑`/home/<username>/.config/mpv/input.conf`文件，添加如下一行代码即可（点击左下角三道线即是）：

```
# script-binding reLoadDanmaku #! ReLoadDanmaku
```

⑩ 让mpv播放视频弹幕更平滑、不模糊

默认情况下，mpv加载B站视频弹幕，视频大概使用的30帧，弹幕视觉效果上一跳一跳的，看起来有点模糊。如果没有安装补帧插件，可以将下列配置直接粘贴到`/home/<username>/.config/mpv/mpv.conf`中，可以让弹幕更清楚一些(通过帧采样强制视频以指定帧率输出)：

```
# 让弹幕更平滑
# 与补帧插件冲突，启用补帧插件就不用加这个
# 注意这行尽量放配置文件的前面，最好放第一个
vf=lavfi="fps=fps=60:round=down"
```

关于加载B站弹幕，只要知道所看视频的cid就行了，在播放界面查看源码，Ctrl+F搜索`cid=`，后面的数字就是了。
弹幕下载地址为`http://comment.bilibili.com/<cid>.xml`，这就是B站的xml弹幕文件。mpv加载弹幕需要转ASS格式，转ASS格式可用[【bilibili ASS 弹幕在线转换】](https://tiansh.github.io/us-danmaku/bilibili/)或者是离线的[【Danmuku2Ass】](https://github.com/m13253/danmaku2ass)，转换后加载就可以了。

（3）安装方便调用MPV的revda

**附加：**也可安装支持B站、油管、虎牙的[revda](https://github.com/THMonster/Revda)

`yay -S revda-git`

revda也是调用的mpv,并且支持弹幕。只需要获取视频播放地址的代码就可以，当想要打开bilibili视频时，它支持av号、bv号、ep号、ss号，多p视频如果想通过av、bv号或者ss、ep号打开，请在编号后加上:n（n为视频p数）打开，例如：你想打开av123456的第三p，请输入av123456:3，bv号与ss号同理。。比如三国演义的播放地址为“`https://www.bilibili.com/bangumi/play/ep327612?from_spmid=666.25.episode.0&from_outer_spmid=..0.0`”，那么播放播放第三集代码就是“ep327612:3”。

详细使用方法见[Revda wiki](https://github.com/THMonster/Revda/wiki/1-%E5%9F%BA%E7%A1%80%E7%94%A8%E6%B3%95)

另外，安装revda时，同时安装了cli程序dmlive,这样也可以直接使用-u参数、后接https链接可播放该链接所指向的直播间或视频（**带B站弹幕，支持ss、ep号**）：

`dmlive -u <url>`

（4）为MPV设置代理

① 修改配置文件mpv.conf

在 mpv.conf 写入这些，并根据注释自行更改。

```
# 你应该将下面的 http://localhost:3128 自行更改为你的代理地址
# 我只不过是将官方的示例换了一种写法而已

# 让 mpv 使用 http(s) 代理
http-proxy=http://127.0.0.1:1080
# 让 yt-dlp 使用 http(s) 代理
ytdl-raw-options-append=proxy=http://127.0.0.1:1080
# 虽然 yt-dlp 支持 socks，但由于 FFmpeg 的原因还是无法使用
```

注意！如果设置了 `--http-proxy` ，环境变量 `http_proxy` 将被忽略。

② 用sh脚本控制mpv代理的开关

参考[《sed在匹配行前面添加注释，或者取消注释》](https://blog.csdn.net/qq_39677803/article/details/121899559)和[《基于输入数字选择运行命令的Linux Shell脚本编程指南》]（https://www.bunian.cn/11681.html）写一个sh脚本控制代理的开关，如下是思路：

```
# 取消以“1080”结尾的行前面的注释符
sed -i "/^#.*1080$/s/^#//" mpv.conf

# 给以“1080”结尾的行前面全部加上注释符
sed -i "s/^[^#].*1080$/#&/g" mpv.conf
```

在目录`/home/<username>/.config/mpv/`下新建脚本文件`mpv_proxy.sh`”，脚本内容如下：

```
#!/bin/bash

echo "开始设置mpv代理，输入数字选择要运行的命令："
echo "1 - 开启mpv和yt-dlp的 proxy 代理"
echo "2 - 关闭mpv和yt-dlp的 proxy 代理"
read -p "输入你的选择（输入数字1-2）：" CHOICE

case $CHOICE in
    1)
        echo ""
        sed -i "/^#.*1080$/s/^#//" /home/dh/.config/mpv/mpv.conf
        echo "已开启mpv和yt-dlp的 proxy 代理！"
        ;;
    2)
        echo ""
        sed -i "s/^[^#].*1080$/#&/g" /home/dh/.config/mpv/mpv.conf
        echo "已关闭mpv和yt-dlp的 proxy 代理！"
        ;;
    *)
        echo "无效的输入！"
        ;;
esac

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

#任意键退出 开始
echo ""
# echo "组合键 CTRL+C 终止运行脚本命令! ..."
echo "按任意键退出对话框..."
char=`get_char`
#任意键退出 结束
```

然后，再在目录`/home/<username>/.config/mpv/`下建立一个desktop快捷方式`MpvProxy.desktop`，内容如下：

```
#!/usr/bin/env xdg-open

[Desktop Entry]
Encoding=UTF-8
Name=MpvProxy
Name[zh_CN]=mpv代理
Exec=sh /home/<username>/.config/mpv/mpv_proxy.sh
Type=Application
Terminal=true
Comment[zh_CN]=开关mpv和yt-dlp的代理通道
Icon=/home/<username>/.config/mpv/mpvproxy.png
Categories=Network;
```

最后，把`MpvProxy.desktop`加入开始菜单就可以了！

（5）使用yt-dlp增强mpv流媒体解析能力、解锁登陆用户分辨率

① 使用cookie

现如今各大视频平台纷纷限制了非登陆用户的观看清晰度，直接拖链接到mpv中往往只有480p甚至360p，使用cookie可以解锁限制。

参照[yt-dlp#configuration](https://github.com/yt-dlp/yt-dlp#configuration)，创yt-dlp配置目录及config文件`.config/yt-dlp/config`，添加一行`--cookies-from-browser [浏览器名称]`，意思是使用某浏览器的cookies。这样就视为使用你在该浏览器的登陆信息观看了，可以解锁登陆用户可使用的最高分辨率。

支持的浏览器包括但不限于（可通过`yt-dlp --help`获得）：brave, chrome, chromium, Edge, firefox,opera, safari, vivaldi。

比如使用firefox的cookies：`--cookies-from-browser firefox`

使用Edge的cookies：`--cookies-from-browser Edge`。

**注意：**yt-dlp默认是稳定版的浏览器，比如稳定版Edge浏览器默认cookie目录为`~/.config/microsoft-edge`，上述参数是有效的，但如说使用的是dev开发版Edge,cookie目录就变为`~/.config/microsoft-edge-dev`了，上述参数要修改为`--cookies-from-browser Edge:~/.config/microsoft-edge-dev`。

②选择视频解码格式

参见：[https://github.com/yt-dlp/yt-dlp#sorting-formats](https://github.com/yt-dlp/yt-dlp#sorting-formats)

通过`.config/yt-dlp/config`中使用`--format-sort`参数设置。

vcodec默认视频编码选择优先级：`AV01>vp9.2>vp9>h265>h264`

如果改为avc(h264)优先,`+`反转优先级列表，可组合使用，`.config/yt-dlp/config`中使用如下参数：

`--format-sort +vcodec:avc`

将优先级改为`h264 > h265 > vp9 > vp9.2 > AV01`

（6）个人配置参数分享

仅供参考，有些配置是个人习惯，看注释修改。

mpv.conf：

```
# 让弹幕更平滑
# 与补帧插件冲突，启用补帧插件就不用加这个
# 注意这行尽量放配置文件的前面，最好放第一个
vf=lavfi="fps=fps=60:round=down"

# required so that the 2 UIs don't fight with uosc each other
osc=no
# uosc provides its own seeking/volume indicators, so you also don't need this
osd-bar=no
# uosc will draw its own window controls if you disable window border，是否关闭窗口装饰（边框）
border=yes
# 设置置顶播放
ontop=yes
# 开启gpu渲染,使用一个内置的画质方案预设
#profile=gpu-hq
# 指定应使用的硬件视频解码API，默认值 no 为始终使用软解。
#hwdec=no
# 启用任何在白名单中的硬件解码器，auto-safe不像 auto，该模式不会尝试启用未知或已知不良的解码方案，但不支持部分设置滤镜。
hwdec=auto-safe
# 对限定范围内的编码尝试硬解，特殊值 all 即任意格式都尝试硬解，当前版本默认值 h264,vc1,hevc,vp8,vp9,av1,prores
hwdec-codecs="h264,vc1,hevc,vp8,vp9,av1,prores"
# 记忆上次播放的位置
save-position-on-quit
# 后面数字是字幕轨，不用的时候就注释掉
#secondary-sid=2
# 当播放视频时，在终端显示视频或歌曲标题及艺术家名字
term-playing-msg='Title: ${media-title}'
# 仅播放音频流时，显示窗口
force-window=yes

# s 视频截图，包含字幕，S 视频截图，不带字幕
# <默认 jpg|(同前)jpeg|png|webp|jxl|avif>
screenshot-format             = jpg
# <0-100> JPEG的质量，默认 90
screenshot-jpeg-quality       = 90
# 用与源视频相同的色度半采样写入JPEG，默认 yes
screenshot-jpeg-source-chroma = yes
# <0-9> PNG压缩等级，过高的等级影响性能，默认 7
#screenshot-png-compression    = 7
# <0-5> PNG的压缩过滤器。默认值 5 即可实现最佳压缩率
#screenshot-png-filter         = 5
# <0-15> JXL的视觉模型距离，0为质量无损，0.1为视觉无损，默认值 1 相当于JPEG的90质量
#screenshot-jxl-distance       = 1
# <1-9> JXL压缩等级，过高的等级影响性能，默认 4
#screenshot-jxl-effort         = 4
# 使用适当的色彩空间标记屏幕截图（并非所有格式受支持）默认 yes
#screenshot-tag-colorspace     = yes
# 尽可能使用高位深作截屏，可能导致巨大的文件体积（并非所有格式受支持），默认 yes
#screenshot-high-bit-depth     = yes
# 示例即默认值。可额外选填路径，例值 "~~desktop/MPV-%P-N%n"
screenshot-template           = "mpv-shot%n"
# 截图保存路径。默认为空，例值（保存截图在桌面）"~~desktop/"
screenshot-directory          = "~/图片/"

# 你应该将下面的 http://127.0.0.1:1080 自行更改为你的代理地址
# 我只不过是将官方的示例换了一种写法而已
# 让 mpv 使用 http(s) 代理
#http-proxy=http://127.0.0.1:1080
# 让 yt-dlp 使用 http(s) 代理
#ytdl-raw-options-append=proxy=http://127.0.0.1:1080
# 虽然 yt-dlp 支持 socks，但由于 FFmpeg 的原因还是无法使用
```

input.conf:

```
F     script-binding quality_menu/video_formats_toggle #! Stream Quality > Video
Alt+f script-binding quality_menu/audio_formats_toggle #! Stream Quality > Audio

#右键唤起菜单，也可以根据自己的喜好换成别的按键。
MOUSE_BTN2   script-message-to contextmenu_gui contextmenu_tk
# 全屏切换(回车键及小键盘确认键)
Enter    cycle fullscreen
KP_ENTER  cycle fullscreen
# 双击左键 播放/暂停
MBTN_LEFT_DBL  cycle pause

# script-binding reLoadDanmaku #! ReLoadDanmaku
```

### 4.2.5 资源播放器zyplayer

（1）新版的资源播放器zyplayer

`yay -S zyplayer-bin`

（2）老版的资源播放器zy-player

`yay -S zy-player-appimage`

或者

`yay -S zy-player-bin`

建议到[项目主页](https://github.com/Hunlongyu/ZY-Player)下载安装`v2.8.5`版，新版本`v2.8.8`有功能阉割（没有影视推荐模块了）！

### 4.2.6 rhythmbox

`sudo pacman -Syu rhythmbox`

**解决 Rhythmbox 中文乱码问题:**

Rhythmbox 是一款很优秀的音乐播放器， 但是在处理中文时却不太友好， 导入歌曲时中文会变成乱码。这个问题也是很好解决的。
Ctrl+Alt+T打开终端，输入以下内容:

`sudo gedit /etc/profile`

在打开文件最后输入一下内容:

```
export GST_ID3_TAG_ENCODING=GBK:UTF-8:GB18030
export GST_ID3V2_TAG_ENCODING=GBK:UTF-8:GB18030
```

保存修改， 终端输入一下内容使修改生效:

`source /etc/profile`

重启 Rhythmbox， 重新导入歌曲即可。

### 4.2.7 音频剪辑audacity

`sudo pacman -Syu audacity`

# 五、办公类软件配置

## 5.1 office编辑类

### 5.1.1 安装wps（社区版）

安装中文版wps-office-cn执行：

``` 
yay wps-office
# 选择三个包：wps-office-cn wps-office-mui-zh-cn wps-office-mime-cn
```
① 如果选择安装中文版的wps-office-cn，则在wps-office-cn每次使用退出后，在后台都会驻留一个云服务进程wpscloudsvr，使用如下命令去掉wpscloudsvr的可执行权限就可以禁止该进程启动了：

`sudo chmod -x /usr/lib/office6/wpscloudsvr`

该方法本来是wpsoffice软件包里wps官方写在某个文件中的禁用后台驻留进程的方法，并且官方声明：该方法在解决驻留进程的同时，也会导致wpsoffice无法登录帐号。所以请权衡之后再决定是否使用。

② 如果你是使用的国际版的wps-office，则在wps-office每次使用退出后，在后台都会驻留一个wpsoffice进程，使用如下命令去掉wpsoffice的可执行权限就可以了：

`sudo chmod -x /usr/lib/office6/wpsoffice`

③ 没有桌面右键新建wps格式文档菜单

debian系deb包安装完，wps 会在`/usr/share/templates/`下生成模板文件，如果没有这些模板文件，桌面右键新建是没有新建wps文档的选项的。Arch Linux安装后，右键新建没有wps文档菜单，只需要解压别的桌面版复制出来模板文件，放到`/usr/share/templates/`目录即可。

④ 修正当`freetype2 版本号 > 2.13.0`时，WPS字体加粗时，渲染问题变成一坨黑的问题。两种方法：

a.降级freetype2版本号为 `2.13.0-1`(可以使用，但使用b方案更好)。

`sudo downgrade freetype2`

然后会列出一系列freetype2的版本，用数字选择需要的版本`2.13.0-1`即可。

b.安装wps的专用补丁`freetype2-wps`。该方法思路是将旧版 freetype2 动态链接库复制到 `/usr/lib/office6` 目录下即可。

```
yay -S freetype2-wps
```

### 5.1.2 安装wps-office-365

安装中文版wps-office-365执行：

``` 
yay -S wps-office-365
```
① 在wps-office-365每次使用退出后，在后台都会驻留一个云服务进程wpscloudsvr，不想wpscloudsvr后台在主wps进程退出后停留后台，可以使用如下方法：

A.使用如下命令去掉wpscloudsvr的可执行权限就可以禁止该进程启动了：

`sudo chmod -x /opt/kingsoft/wps-office/office6/wpscloudsvr`

该方法本来是wps-office软件包里wps官方写在某个文件中的禁用后台驻留进程的方法，并且官方声明：该方法在解决驻留进程的同时，也会导致wps-office无法登录帐号。所以请权衡之后再决定是否使用。

wps-office-365使用网络上的激活码激活后，同时如果尝试登陆wps账号，在网络抓包中发现key会被读取并传送给服务器，这个过程可能会由于一些原因key被绑定或封杀。所以，一般使用网络上的激活码激活后，最好不登陆wps账号，仅使用wps的离线功能。

B.不想wpscloudsvr后台在主wps进程退出后停留后台，又不想完全禁用wpscloudsvr的话，有以下2种方法：

(a)可以使用 [https://github.com/7Ji/wpscloudsvr-wrapper](https://github.com/7Ji/wpscloudsvr-wrapper) ，这个项目会替换wpscloudsvr，启动后会作为wpscloudsvr的父进程fork启动真正的wpscloudsvr并会在托盘区生成一个图标（名称为 WPS云服务）。所有wps进程退出后，可以点击托盘图标退出，其会将wpscloudsvr正确结束。

(b)可以以 `systemd-run --user -- wps` 的形式启动相应进程，wpscloudsvr会和主进程一起被systemd user套入一个`Type=oneshot`的临时`.service`中，当主进程退出时，wpscloudsvr会作为service的孤儿进程被杀死。这个方案存在问题是wpscloudsvr会和首个主进程绑定，若保留其后启动的wps窗口而关闭首个，则wpscloudsvr会直接退出，不会等待其余wps进程。

② 没有桌面右键新建wps的03格式的`.doc、.xls、.ppt`格式文档菜单

wps-office-365默认只提供的右键新建07格式的文档。debian系社区版的wps-office-cn的deb包安装完，wps 会在`/usr/share/templates/`下生成模板文件，桌面右键新建包含03和07格式的wps文档的选项。Arch Linux安装后，右键新建没有03格式的wps文档菜单，只需要解压别的桌面版复制出来模板文件，放到`/usr/share/templates/`目录即可。

③ wps-office-365 激活

wps-office-365默认只有30天的试用时间。到期后，可以选择如下两种方法继续使用：

A.重置试用时间

`quickstartoffice stop && rm ~/.config/Kingsoft/AuthInfo.conf`

B.使用政企版激活码激活

如果有企业单位提供的政企版的激活码，可以成功激活wps-office-365。但是如果使用的政企版激活码，最好不要登陆账户，防止key被绑定或封杀导致激活失败（因为使用的政企单位的激活码激活后，一般要求激活后绑定如个人微信登陆、学校或企业邮箱账号、手机等，如果登陆未绑定的账号，可能会被识别）。例如，我使用的如下政企版wps-365激活码激活成功：`694BF-YUDBG-EAR69-BPRGB-ATQXH`。

另外，参考[ubuntu中文论坛的帖子](https://forum.ubuntu.org.cn/viewtopic.php?t=494609)，替换使用其提供的改造文件后，可以使用常规key进行激活。启动后使用常规key进行激活，整个过程很简单，就是修改oem文件，添加一些键值，类似上面介绍的原理。这个也是帖子方案附件文件的核心，由于各种情况不保证有效性。最后，一定要保存好激活后的验证文件，方便之后重装或对抗key被封，特殊情况下你需要将验证文件设为特殊权限，阻止被软件修改。同时如果尝试登陆wps账号，在网络抓包中发现key会被读取并传送给服务器，这个过程可能会由于一些原因key被绑定或封杀，所以一般激活后，最好不登陆wps账号，仅使用wps的离线功能。

C.备份激活文件：
主要激活文件license2.dat在目录`/opt/kingsoft/.auth/` 目录下，备份该目录即可。

④ 最新官方wps-office-365安装包已经同时包含了xiezuo协作和fonts字体，aur已经拆分协作到wps-office-365-xiezuo、拆分字体到wps-office-365-fonts，都是单独的包了！

如果单独安装了wps-office-365-xiezuo，协作默认会开机自动启动，执行`rm ~/.config/autostart/xiezuo.desktop`删除启动项目，即可解决。

【参考】：

* [forum ubuntu](https://forum.ubuntu.org.cn/viewtopic.php?t=494609)
* [aur wps-office-365](https://aur.archlinux.org/packages/wps-office-365?O=10)

### 5.1.3 安装 LibreOffice

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

### 5.1.4 retext

`sudo pacman -Syu retext`

### 5.1.5 安装texstudio

`sudo pacman -Syu texstudio`

### 5.1.6 安装 tinytex

（1）按照谢大神写的教程 [https://yihui.org/tinytex/#for-other-users]， 终端执行如下命令：

`wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh`

老版本文章中使用的旧版本的tinytex,使用的`wget -qO- "http://yihui.org/gh/tinytex/tools/install-unx.sh" | sh`进行安装（老版本中自带镜像加速），现在改用上面的命令脚本安装新版的tinytex。但是新版的sh脚本中下载安装包直接使用的github的原始地址，没有代理的情况下，安装十分满或无法下载安装。如果你直接使用上面的命令下载不动，使用下面的方法修改一下sh脚本，使用github下载镜像：

**① 规范修改镜像下载地址**

使用如下链接`https://yihui.org/tinytex/install-bin-unix.sh`下载脚本install-bin-unix.sh。然后用你使用的文本编辑器打开，找到：

```
if [ -z $TINYTEX_VERSION ]; then
  TINYTEX_URL="https://github.com/rstudio/tinytex-releases/releases/download/daily/$TINYTEX_INSTALLER"
else
  TINYTEX_URL="https://github.com/rstudio/tinytex-releases/releases/download/v$TINYTEX_VERSION/$TINYTEX_INSTALLER-v$TINYTEX_VERSION"
fi
```

在如上两个链接前加上`https://ghproxy.com/`修改为：

```
if [ -z $TINYTEX_VERSION ]; then
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/daily/$TINYTEX_INSTALLER"
else
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/v$TINYTEX_VERSION/$TINYTEX_INSTALLER-v$TINYTEX_VERSION"
fi
```
 注意，如上链接地址下载的是`TinyTeX-1`，只包含约90个 LaTeX packages，我们可以选择修改如下代码，下载`TinyTeX`，其包含更多的LaTeX packages（详细介绍见[tinytex-releases](https://github.com/rstudio/tinytex-releases)）：

` TINYTEX_INSTALLER=${TINYTEX_INSTALLER:-"TinyTeX-1"}`修改为` TINYTEX_INSTALLER=${TINYTEX_INSTALLER:-"TinyTeX"}`

**② 暴力修改镜像下载地址**

①的修改有点麻烦，我们直接修改如下代码，直接安装`TinyTeX`：

```
if [ -z $TINYTEX_VERSION ]; then
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/daily/$TINYTEX_INSTALLER"
else
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/v$TINYTEX_VERSION/$TINYTEX_INSTALLER-v$TINYTEX_VERSION"
fi
```
为
```
if [ -z $TINYTEX_VERSION ]; then
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/daily/TinyTeX"
else
  TINYTEX_URL="https://ghproxy.com/https://github.com/rstudio/tinytex-releases/releases/download/daily/TinyTeX"
fi
```

安装过程比较漫长， 慢慢等待安装完成即可。

在安装过程中如果意外中断， 或者安装完后报错`.TinyTeX/bin/*/tlmgr: not found`， 一般也是网络问题导致的安装不完全， 重新安装即可。

安装过程中，输出有如下几行：

```
tlmgr: setting option sys_bin to /home/dh/.local/bin.
tlmgr: updating /home/dh/.TinyTeX/tlpkg/texlive.tlpdb
tlmgr: setting default package repository to https://mirror.ctan.org/systems/texlive/tlnet
tlmgr: updating /home/dh/.TinyTeX/tlpkg/texlive.tlpdb
```

从输出中信息，CTAN默认使用的官方源[http://mirror.ctan.org/systems/texlive/tlnet]，速度相当慢！
可以从 CTAN mirrors 选择一个镜像， 然后用 options 参数来指定， 如在终端执行如下命令，清华大学的镜像（推荐） ：

`export CTAN_REPO="https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet"`

或者可以使用 TeXLive 包管理器 tlmgr 更改：

```
# 更改到清华大学镜像需要在命令行中执行: 
tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet

# 更改到上海交大镜像需要在命令行中执行: 
tlmgr option repository https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/tlnet/
```

如果tlmgr修改镜像时报错，就需要先执行一下如下命令：

`export PATH=$PATH:/home/usename/.TinyTeX/bin/x86_64-linux`

（2）将其添加到 path(这里如果你用的是 zsh,把 bashrc 改成 zshrc， 其他类推),方法如下：

终端执行命令

`gedit ~/.bashrc`

在打开的文件最后添加如下内容：

`export PATH=$PATH:/home/usename/.TinyTeX/bin/x86_64-linux`

执行如下命令重新部署一下：

`source ~/.bashrc`

（3）先安装perl环境

`sudo pacman -S perl`

安装 XeLaTeX 中文编译引擎。 终端执行：

`sudo pacman -Syu texlive-xetex`

至此， 支持环境已经完成， 如果你不要使用 Latex 进行高级编辑，后面的可以不安装了。 如果需要， 那么就继续下面的操作！

（4）安装中文支持包， 使用的是 xeCJK， 中文处理技术也有很多， xeCJK 是成熟且稳定的一种。

`sudo pacman -Syu texlive-langchinese`

继续安装一些可能必须的模块， 终端依次执行：

`tlmgr install xecjk`

`tlmgr install ctex`

（5）使用维护

维护命令可以通过“`tlmgr --help`” 命令获取。

① 使用如下命令查找组件信息， 如终端运行：

`tlmgr search --file --global "/xecjk"`

② 显示本机已安装的 Texlive 组件， 终端运行：

`tlmgr info --list --only-installed --data name,size`

③ 报错“File xxx not found.”

出现类似如下提示：
`! LaTeX Error: File `xeCJK.sty' not found.`

出现类似上面的报错时， 不要慌， 这就是有些你需要的包没导入， 可以通过如下步骤解决：

(A) 进行缺失模块搜索， 终端执行：

`tlmgr search --global --file "/xeCJK.sty"`

出现如下类似信息：
```
tlmgr: package repository http://mirror.las.iastate.edu/tex-archive/systems/texlive/tlnet (verified)
xecjk:
texmf-dist/tex/xelatex/xecjk/xeCJK.sty
```
这表明缺失的模块是 xecjk。 下面安装

(B) 进行安装缺失模块， 终端执行

`tlmgr install xecjk`

卸载就是“`tlmgr remove [模块]`” 了。 基本碰到包缺失的问题， 这么做就没事了。

④ 列示需要更新的包， 终端执行：

`tlmgr update --list`

更新全部

`tlmgr update --self --all`

⑤ 使用图形界面， 终端执行：

`tlmgr gui`

（6）Latex 文档转 word 格式

目前 Latex 格式文档还没有十分完美的方法转换为 word 格式。目前，转换效果比较好的方法，是使用 pandoc 软件。

`sudo pacman -S haskell-pandoc`

 Pandoc 的使用方法可以参考[https://www.jianshu.com/p/dc62b915920e](https://www.jianshu.com/p/dc62b915920e)。 

以下为两个常用转换命令：

① 常规不指定格式转换：

`pandoc 测试文件.tex -o 测试文件.docx`

② 指定 docx 模板样式并转 docx：

`pandoc -s m.tex -S --reference-docx reference.docx -o m.docx`

### 5.1.7

## 5.2 阅读类

### 5.2.1 安装xournalpp

`sudo pacman -Syu xournalpp`

### 5.2.2 电子书calibre

（1）通过Arch Linux 官方源安装

使用如下命令通过Arch源安装：

`sudo pacman -Syu calibre`

**注意：**通过Arch Linux 官方源安装的calibre无法启动“ebook-viewer”。报错原因是（html5-parser与lxml的依赖库libxml2版本不一致。）：

`RuntimeError: html5-parser and lxml are using different versions of libxml2. This happens commonly when using pip installed versions of lxml. Use pip install --no-binary lxml lxml instead. libxml2 versions: html5-parser: (2, 11, 4) != lxml: (2, 10, 3)`

（2）使用calibre官方二进制包安装

calibre 的二进制安装包括了其所有依赖项的私有版本。它可以在32位和64位英特尔兼容计算机上运行。要安装或升级，只需将以下命令复制粘贴到终端并按Enter键即可：

`sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin`

当您在等待下载完成时，请考虑为 calibre 的开发提供支持。

通过二进制包安装的calibre卸载方法为在终端运行如下卸载脚本：

`/usr/bin/calibre-uninstall`

（3）用calibre阅读电子书如何调整行间距

打开你想阅读的电子书，在calibre电子书查看器中，依次“`右键 - 首选项 - 样式`”，然后， 在css样式框里添加自定义样式，如下：

`body{line-height:36px}`

如果以上代码对样式无效，就换下面的代码：

`p{line-height:36px}`

总有一个适合你！另外，把36px换成行倍2em也可以！

### 5.2.3 PDF阅读器 masterpdfeditor

masterpdfeditor功能十分强大，堪称linux界最强pdf阅读器！安装：

`yay -S masterpdfeditor`

masterpdfeditor5安装后，如果没有激活，在编辑完pdf文档后，保存会有水印。在win下，masterpdfeditor5的keygen注册机激活软件比较多，但是在linux几乎没有可用的破解激活软件可用（曾经在github下有masterpdfeditor的破解项目，但是现在项目已经不存在了）！好在目前还存在masterpdfeditor5在linux下的破解激活版本，新版本使用旧版本的激活文件目前还能使用（只是打开软件后，查看软件版本号，会不一致，但不影响使用）。下面是激活方法：

① 首先，阻断masterpdfeditor的激活联网，修改hosts文件，添加如下内容：

```
# block masterpdfeditor
127.0.0.1 reg.code-industry.net
```

② 下载其他linux下可使用的破解激活版本：

目前，找到的破解激活版本，到页面[《Master PDF Editor 5.9.85 / 5.9.61》](https://www.cybermania.ws/apps/master-pdf-editor/)，找到“(Cracked Linux Installer) Linux64 (Thanks to Team Skyfall )”，点击“[【Download】](https://krakenfiles.com/view/eVlESIlo7a/file.html)”下载“`MasterPDFEditor5.9.10Linux64.7z`”。

③ 替换激活文件：

先备份原启动文件`/opt/master-pdf-editor-5/masterpdfeditor5`为`/opt/master-pdf-editor-5/masterpdfeditor5_BACKUP`。然后，解压下载的“`MasterPDFEditor5.9.10Linux64.7z`”，将解压得到的文件`MasterPDFEditor5.9.10Linux64/crack/masterpdfeditor5`复制到目录`/opt/master-pdf-editor-5/`下。这样再次打开masterpdfeditor，就是已经激活的了！

### 5.2.4 福昕PDF阅读器

直接到官网下载linux amd64版本的安装包解压，双击安装即可！也可以从AUR安装构建包（但反馈bug比较多，不如直接安装官方的二进制包）：

`yay -S foxitreader`

### 5.2.5 pdf 分割工具

`sudo pacman -Syu pdfarranger`

### 5.2.6 文献阅读 cajviewer

`yay cajviewer`

## 5.3 笔记及记忆类

### 5.3.1 安装vnote

`yay -S vnote`

### 5.3.2 思维导图xmind

`yay -S xmind`

### 5.3.3 anki

`yay -S anki `

### 5.3.4 词典Goldendict

新版本的webkit-qt6版本（建议安装这个）：

`yay -S goldendict-ng` 

webkit-qt5版本（很久不更新了，存在icu冲突）：

`yay -S goldendict` 

**（1） 离线字典安装**

离线字典下载地址： [http://abloz.com/huzheng/stardict-dic/](http://abloz.com/huzheng/stardict-dic/)

下载完成后进入文件所在目录执行下面命令：

```
tar -xjvf filename.tar.bz2
mv directory(目录名) /usr/share/goldendict/dic
```

或则执行：

`tar -xjvf filename.tar.bz2 -C /usr/share/goldendict/dic`

**（2） 在线字典配置**

然后， 添加有道、 Bing、 汉词、 海词等在线翻译词典（建议只添加有道在线翻译词典， 一个足矣） 。

```
在线词典： 有道词典 http://dict.youdao.com/search?q=%GDWORD%&ue=utf8
海词 http://dict.cn/%GDWORD%
汉典 http://www.zdic.net/sousuo/?q=%GDWORD%
bing http://cn.bing.com/dict/search?q=%GDWORD%
```

PS. 另外，还可以考虑安装`pot-translation`,在线翻译功能比较强大！

## 5.4 会议类

### 5.4.1 安装腾讯会议：

`yay -S wemeet`


# 六、开发类软件配置

## 6.1 sublime-text

`yay sublime-text-4`

（1）禁用sublime检测更新及注册码

在 hosts 文件中添加如下内容：

```
#sublime license
127.0.0.1 sublimetext.com
127.0.0.1 sublimehq.com
0.0.0.0 license.sublimehq.com
0.0.0.0 45.55.255.55
0.0.0.0 45.55.41.223
127.0.0.1 www.sublimetext.com
127.0.0.1 telemetry.sublimehq.com
#sublime license
```

安装 sublime后，在菜单栏中选择 `help>>enter license`，把许可证复制到出现的框里， 点击 use license 就可以了， 破解之后就不会显示 unregistered字样。

禁用 Sublime检测新版本， 设置 `Preferences >> Settings-User`：添加`"update_check": false`。然后，再以root用户模式下如（sudo） 启动 sublime， 再输入一次激活码进行激活（否则， root模式下 sublime 仍为未激活） 。

（2）使用 Package Control 组件

安装 package control 组件， 然后直接在线安装：
按 `Ctrl+ '(此符号为 tab 按键上面的按键)` 调出 console（注： 避免热键冲突），粘贴以下代码到命令行并回车：

`import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())`

上面的代码复制到红线地方，按回车键，会看到下面出现东西在左右摆动，说明正在下载。

（3）安装插件

A.菜单栏点击 `Preferences >> Package Control >> Add Channel`, 输入这个地址回车：

`https://raw.githubusercontent.com/wilon/sublime/master/download/channel_v3.json`

会自动添加一行"channels"字段：

```
"channels":
[
	"https://raw.githubusercontent.com/wilon/sublime/master/download/channel_v3.json"
],
```

此包每日更新。

B.加载更快的办法

如果还是太慢您可以指定本地channel_v3.json地址，方法如下：

①下载json文件，GitHub下载地址：

[https://raw.githubusercontent.com/wilon/sublime/master/download/channel_v3.json](https://raw.githubusercontent.com/wilon/sublime/master/download/channel_v3.json)

②菜单栏点击并打开：`Preferences: Package Settings >> Package Control >> sublime Settings - User`
添加一行"channels"字段：

```
"channels":
[
	"channel_v3.json所在目录/channel_v3.json"
],
```

（4）安装一些推荐扩展

①MarkDown Editing   ②ColorPicker颜色选择器   ③SublimeREPL 在 Sublime Text 中运行各种语言  
④SublimeLinter高亮提示编写代码不规范和错误   ⑤SideBarEnhancements右键菜单增强插件   ⑥Alignment 代码对齐 
⑦SublimeTmpl 快速生成文件模板     ⑧ConvertToUTF8    ⑨Bracket Highlighter 匹配括号引号和html标签
⑩ Emmet(Zen Coding)快速生成HTML代码段 ⑪ Sublime CodeIntel 代码自动提示

（5）汉化

在进行 Sublime Text 的汉化之前，首先需要前往 Github 上去下载一下 Sublime 的汉化包。Sublime Text 汉化包：

[https://github.com/MRLP0524/Sublime-Text-Chinesize](https://github.com/MRLP0524/Sublime-Text-Chinesize)

点击下载后，我们将其解压缩，得到一个文件 Default.sublime-package。

之后我们需要去找到目录 `/home/用户名/.config/sublime-text/Installed Packages` 以及目录`/root/.config/sublime-text/Installed Packages` 下。并将我们的汉化包直接拖进 Installed Packages 文件夹即可。这时候我们的Submlie汉化就完成了。汉化完成后，也可以输入中文了！

（6）设置markdown实时预览

使用package control安装插件，快捷键Ctrl+Shift+P调出命令面板，找到 `Install Package`选项并回车，稍微等待几秒，然后在出现的列表中搜索安装`MarkdownEditing`、`MarkdownPreview`、`MarkdownLivePreview`、`sync view scroll`四个插件，选中后回车即可安装，安装完成后会弹出“Package Control Messages”的文件。

（7）解决MarkdownEditing 去除左侧空白+更改主题等

MarkdownEditing	:一个提高Sublime中Markdown编辑特性的插件。进入 `Preferences -> Package Settings -> Markdown Editting -> Markdow GFM Settings - Default & Markdow GFM Settings - User` ，修改为如下内容：

```
{
	"color_scheme": "Packages/Color Scheme - Legacy/Cobalt.tmTheme",  //"color_scheme"

	// Layout
	"draw_centered": false,  //决定两侧是否留白，默认为true，修改为false去除左侧空白
	"word_wrap": true, //自动换行
	"wrap_width": 0, //决定每行最大字数，默认设定为80，0为自动切换

	// Line
	"line_numbers": true, //显示行号，默认为false

	//修改Markdown关联文件
	"extensions":
	[
		"md",
		"mdown",
		//"txt"
	],

	//修改光标样式
	"caret_extra_top" : 1, //超出光标上方的额外距离
	"caret_extra_bottom" : 1, //超出光标下方的额外距离
	"caret_extra_width" : 1, //超出光标宽度

}

```

（8）设置预览和同步滚动热键

Sublime Text支持自定义快捷键，syncviewscroll、MarkdownPreview和MarkdownLivePreview默认没有快捷键，我们可以自己置快捷键。方法是在Preferences -> Key Bindings-user打开的文件中的括号中添加代码：
```
    //MarkdownPreview 热键
    { "keys": ["alt+b"], "command": "markdown_preview", "args": {"target": "browser", "parser":"markdown"}  },
    // MarkdownLivePreview 热键
    {
        "keys": ["alt+m"],
        "command": "open_markdown_preview"
    },
    //Sync View Scroll 热键
    { "keys": ["alt+s"], "command": "toggle_sync_scroll" }
```
这样"alt+b" 可在浏览器中预览，"alt+m" 可在sublime中分栏预览，"alt+s" 可在sublime中打开分栏预览后，再同步滚动。

（9）在终端中通过命令使用sublime编辑文本

打开用户配置文件 `~/.bash_profile` ，添加如下alias：

`alias subl="'usr/bin/subl'"`

如果不添加别名，也可以选择将路径添加到环境变量下。这里的路径根据实际情况可能会有所不同。

保存后回到命令行执行以下命令使其生效：

`source ~/.bash_profile`

命令行使用方法：

这里我们假设在命令行用SublimeText打开book.txt，则执行如下：

`subl book.txt`

以后在命令行下查看或编辑文本文件，如果不想使用vim就可以直接使用"subl"命令将其在SublimeText编辑器打开了。

（10）报错处理

打开时报错：`Error trying to parse file:Invalid escape in  Packages\Pser\Default(windows).sublime-keymap:2:1`

菜单 `Preferences>>Key Bindings（按键绑定-用户）`打开文件`/User/Default ().sublime-keymap`，然后用“`//`”把第二行注释掉即可。

## 6.2 汉化文件编译poedit

`sudo pacman -Syu poedit`

## 6.3 python-pip

`sudo pacman -Syu python-pip python-setuptools`

消除pip3安装模块时的错误：

`sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED`

## 6.4 Python 安装第三方模块（pip3）

确保已安装 python-pip 和 python-setuptools：

`sudo pacman -S python-pip python-setuptools`

（1）然后终端中执行如下命令安装第三方常用模块：

注意：不要使用sudo权限安装，使用类如`sudo pip3 install send2trash`模式安装python模块，会导致安装软件时，出现大量的python模块冲突报错。

```
pip3 install send2trash
pip3 install requests
pip3 install beautifulsoup4
pip3 install selenium
pip3 install openpyxl
pip3 install PyPDF2
pip3 install python-docx（安装 python-docx， 而不是 docx）
pip3 install imapclient
pip3 install pyzmail
pip3 install twilio
pip3 install pillow
pip3 install python3-xlib（仅在 Linux 上）
pip3 install pyautogui
pip3 install pyperclip
pip3 install urllib3
pip3 install pytz
pip3 install soupsieve
pip3 install certifi
pip3 install jeepney
pip3 install lxml
pip3 install pysocks
pip3 install baidu-aip （百度OCR）
```

（2）python-pip或pip3源使用国内镜像，提升模块下载速度。

对于 python 开发，pip3 安装软件包国外的源下载速度实在太慢， 且常出现下载后安装出错问题。 所以把pip3 安装源替换成国内镜像， 可以大幅提升下载速度， 还可以提高安装成功率。

**国内源：**

```
#  现在基本要求使用 https 源，要注意。
清华： https://pypi.tuna.tsinghua.edu.cn/simple
阿里云： http://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
华中理工大学： http://pypi.hustunique.com/
山东理工大学： http://pypi.sdutlinux.org/
豆瓣： http://pypi.douban.com/simple/
```

① 临时使用：

可以在使用 pip3 的时候加参数`-i https://pypi.tuna.tsinghua.edu.cn/simple`，例如： 

`pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pyspider`

这样就会从清华这边的镜像去安装 pyspider 库。

② 永久修改， 一劳永逸：

Linux 下，如果你使用的为 pip 9.0 及更新的版本， 那么配置文件为` ~/.config/pip/pip.conf`。 修改 `~/.config/pip/pip.conf`， 内容如下：

```
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host=pypi.douban.com
```

已测试可用、 有效。

如果你使用的为 pip 8.x.x 或更老的版本， 那么配置文件目录为 `$HOME/.pip/pip.conf` (没有就创建一个文件夹及文件。 文件夹要加“.” ， 表示是隐藏文件夹)

（3）小补充：

使用如下命令查看 pip 的版本：

`pacman -Q python-pip`

使用以下命令， 它会告诉你 pip 配置文件的不同位置:

`pip config -v list`

如果使用非 HTTPS 加密源（如豆瓣源） ， 在执行命令发生错误， 在命令最后加上`--trusted-host pypi.douban.com`，即

`pip install django -i http://pypi.douban.com/simple --trusted-host pypi.douban.com`

## 6.5 安装开源版vscodium

`sudo pacman -Syu code`

## 6.6 安装git-cola

`yay git-cola`

注意：上述从Arch Linux的AUR中安装git-cola编译过程中如果存在冲突，无法正常安装，是python模块使用sudo权限安装造成的（即`sudo pip3`），先用sudo权限卸载相关模块，然后pip3安装即可。也可以在[pkgs.org](https://pkgs.org/download/git-cola)下载Arch Linux的zst离线安装包，比如我下载的【Chaotic AUR x86_64 Third-Party】的[git-cola-4.2.1-3-any.pkg.tar.zst](https://archlinux.pkgs.org/rolling/chaotic-aur-x86_64/git-cola-4.2.1-3-any.pkg.tar.zst.html),下载后，使用如下命令安装即可：

`sudo pacman -U git-cola-4.2.1-3-any.pkg.tar.zst`

实测可用！

也可以暂用gitg、smartgit等：

`sudo pacman -S gitg`   //免费

`sudo pacman -S smartgit`  //非完全免费，需注册

## 6.7 数据库管理 sqlitebrowser

`sudo pacman -Syu sqlitebrowser`

# 七、游戏类软件配置




# 常见问题

## (一)系统级常见问题

### 1. sudo: service：找不到命令

在执行 sudo service 命令时遇到 `command not found` 的错误提示，可以尝试使用 systemctl 命令来代替，或者安装相应的支持包来获得 service 命令的支持。

`sudo service bluetooth start`

改为

`sudo systemctl start bluetooth`

### 2. 关于很久没有更新系统，再次更新系统提示错误

先更新 archlinux-keyring 这个包：

`pacman -S archlinux-keyring`

如果也使用了 [archlinuxcn] 仓库，那把 archlinuxcn-keyring 也更新一下：

`yay -S archlinux-keyring`

最后，更新系统：

`pacman -Syyu`

### 3. 启动blueman提示“bulez守护进程没有运行”

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

### 4. 启动时grub界面报错vconsole

启动时grub界面报错：“systemctl status systemd-vconsole-setup.service”

进入系统后，修改`/etc/vconsole.conf`文件内容，将如下内容：

```
KEYMAP=cn
FONT=
FONT_MAP=
```

修改为如下即可：

```
KEYMAP=us
FONT=
FONT_MAP=
```

### 5. 启动时grub报错systemd-modules-load.service

启动时grub界面报错：“systemctl status systemd-modules-load.service”，然后进入系统后，运行`sudo systemctl status systemd-modules-load.service`，报错详细信息为：

`systemd-modules-load[604]: Failed to insert module 'tp_smapi': No such device`

原因是我使用了thinkpad的电源管理模块tp_smapi，但是[tp_smapi](https://github.com/linux-thinkpad/tp_smapi)声明：

```
tp_smapi Does not work on:
* X230 and newer
* T430 and newer
* Any ThinkPad Edge
* Any ThinkPad Yoga
* Any ThinkPad L series
* Any ThinkPad P series
```
我安装后电池阈值设置生效，却报错。也就是说tp_smapi在我的X240上部分生效，但不完全能运行，所以报错 “Failed to insert module 'tp_smapi-lts'”。可以更换使用受支持的tpapi-bat。

### 6.pip3 install 模块提示 error

当使用`pip3 install 模块`时，提示如下错误：

```
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try 'pacman -S
    python-xyz', where xyz is the package you are trying to
    install.
    
    If you wish to install a non-Arch-packaged Python package,
    create a virtual environment using 'python -m venv path/to/venv'.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip.
    
    If you wish to install a non-Arch packaged Python application,
    it may be easiest to use 'pipx install xyz', which will manage a
    virtual environment for you. Make sure you have python-pipx
    installed via pacman.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

临时解决办法有如下两种：

**第一种方法：**

将如下目录文件`/usr/lib/python3.12/EXTERNALLY-MANAGED`重命名为`EXTERNALLY-MANAGED_backup`。这种方法可能在再次升级python主程序后，还要再次修改。

**第二种方法：**

在如下目录文件`/home/dh/.config/pip/pip.conf`中添加如下参数：

```
[global]
break-system-packages = true
```

### 7.pip3 install 模块提示 error-using the `--user` option

当使用`pip3 install 模块`时，最终提示类似如下错误：

```
ERROR: Could not install packages due to an OSError: [Errno 13] Permission denied: '/usr/lib/python3.12/site-packages/xxxxx-xx.x.dist-info/LICENSE'
Consider using the `--user` option or check the permissions.
```

解决方法就是，给予当前普通用户组（即你的用户名）对`/usr/lib/python3.12/site-packages/`目录的可执行权限：

① 以root权限打开`/usr/lib/python3.12/site-packages/`目录；

② 右键点击`/usr/lib/python3.12/site-packages/`目录，点击“属性”，切到“权限”标签页下，然后在“所有者”下“用户：”、“用户组：”后填写你的用户名和用户组名，例如我的都是“dh”。

③ 再次执行`pip3 install 模块`，一般就可以成功安装模块了！

## (二)应用软件常见问题

### 1. 软件不能输入中文，或输入汉字时跳字母

在相关软件启动命令中加入输入法环境变量即可。以下以Chrome浏览器为例。

修改Chrome浏览器的desktop快捷方式文件：

把 `/usr/share/applications` 目录下的 `google-chrome.desktop` 复制到`/home/dh/.local/share/applications` 下，同时，把 `google-chrome.desktop` 中的如下内容：

`Exec=chromium-browser %U`

修改为

`Exec=env QT_IM_MODULE=fcitx chromium-browser %U`

即，给`Exec=`添加上参数：`env QT_IM_MODULE=fcitx`

### 2.wayland下，系统垃圾清理软件Bleachbit不能以root模式运行

尝试在 Wayland桌面环境中通过 su、sudo 或 pkexec 以 root 身份运行图形应用程序Bleachbit，将失败并出现类似以下的错误：

```
Traceback (most recent call last):
  File "/usr/bin/bleachbit", line 40, in <module>
    bleachbit.Unix.is_display_protocol_wayland_and_root_not_allowed()
  File "/usr/share/bleachbit/Unix.py", line 748, in is_display_protocol_wayland_and_root_not_allowed
    bleachbit.Unix.root_is_not_allowed_to_X_session()
  File "/usr/share/bleachbit/Unix.py", line 739, in root_is_not_allowed_to_X_session
    result = General.run_external(['xhost'], clean_env=False)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/share/bleachbit/General.py", line 147, in run_external
    p = subprocess.Popen(args, stdout=stdout,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/subprocess.py", line 1026, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.11/subprocess.py", line 1953, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'xhost'
```

**错误提示分析：**

这是因为在 Wayland 之前，可以通过创建 Polkit 策略来正确实现具有提升权限的 GUI 应用程序，或者更危险的方法是通过在命令前面加上 sudo 在终端中运行命令来完成。但在 （X）Wayland 下，这不再起作用，因为默认设置为只允许启动 X 服务器的用户将客户端连接到它。

**解决方法：**

一种通用但不安全的解决方法，使用xhost来允许任何图形应用程序在wayland下以 root 身份运行。安装`xorg-xhost`：

```
sudo pacman -S xorg-xhost
```

然后，如果你在启动程序添加了参数`pkexec`，那么直接点击启动图标就可以了。如果你使用`sudo <程序>`命令运行程序，那么就需要继续下面的操作：
使用如下命令添加允许root用户访问本地用户的X会话权限，请以当前（非特权）用户身份执行以下命令：

```
xhost si:localuser:root
```

若要在应用程序关闭后删除此访问权限，请执行以下操作：

```
xhost -si:localuser:root
```

# 附件部分

## 1. thinkfan 的 thinkfan.conf文件内容

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

## 2. TLP 的 tlp.conf文件内容

```
# ------------------------------------------------------------------------------
# /etc/tlp.conf - TLP user configuration (version 1.4)
# See full explanation: https://linrunner.de/tlp/settings
#
# Settings are read in the following order:
#
# 1. Intrinsic defaults
# 2. /etc/tlp.d/*.conf - Drop-in customization snippets
# 3. /etc/tlp.conf     - User configuration (this file)
#
# Notes:
# - In case of identical parameters, the last occurence has precedence
# - This also means, parameters enabled here will override anything else
# - However you may append values to a parameter already defined as intrinsic
#   default or in a previously read file: use PARAMETER+="add values"
# - IMPORTANT: all parameters here are disabled; remove the leading '#' if you
#   like to enable a feature without default or have a value different from the
#   default
# - Default *: intrinsic default that is effective when the parameter is missing
#     or disabled by a leading '#'; use PARAM="" to disable an intrinsic default
# - Default <none>: do nothing or use kernel/hardware defaults
# -
# ------------------------------------------------------------------------------
# tlp - Parameters for power saving

# Set to 0 to disable, 1 to enable TLP.
# Default: 1

TLP_ENABLE=1

# Control how warnings about invalid settings are issued:
#   0=disabled,
#   1=background tasks (boot, resume, change of power source) report to syslog,
#   2=shell commands report to the terminal (stderr),
#   3=combination of 1 and 2
# Default: 3

TLP_WARN_LEVEL=3

# Operation mode when no power supply can be detected: AC, BAT.
# Concerns some desktop and embedded hardware only.
# Default: <none>

TLP_DEFAULT_MODE=BAT

# Operation mode select: 0=depend on power source, 1=always use TLP_DEFAULT_MODE
# Note: use in conjunction with TLP_DEFAULT_MODE=BAT for BAT settings on AC.
# Default: 0

TLP_PERSISTENT_DEFAULT=0

# Power supply classes to ignore when determining operation mode: AC, USB, BAT.
# Separate multiple classes with spaces.
# Note: try on laptops where operation mode AC/BAT is incorrectly detected.
# Default: <none>

#TLP_PS_IGNORE="BAT"

# Seconds laptop mode has to wait after the disk goes idle before doing a sync.
# Non-zero value enables, zero disables laptop mode.
# Default: 0 (AC), 2 (BAT)

DISK_IDLE_SECS_ON_AC=0
DISK_IDLE_SECS_ON_BAT=2

# Dirty page values (timeouts in secs).
# Default: 15 (AC), 60 (BAT)

MAX_LOST_WORK_SECS_ON_AC=15
MAX_LOST_WORK_SECS_ON_BAT=60

# Select a CPU frequency scaling governor.
# Intel processor with intel_pstate driver:
#   performance, powersave(*).
# Intel processor with intel_cpufreq driver (aka intel_pstate passive mode):
#   conservative, ondemand, userspace, powersave, performance, schedutil(*).
# Intel and other processor brands with acpi-cpufreq driver:
#   conservative, ondemand(*), userspace, powersave, performance, schedutil(*).
# Use tlp-stat -p to show the active driver and available governors.
# Important:
#   Governors marked (*) above are power efficient for *almost all* workloads
#   and therefore kernel and most distributions have chosen them as defaults.
#   You should have done your research about advantages/disadvantages *before*
#   changing the governor.
# Default: <none>

CPU_SCALING_GOVERNOR_ON_AC=schedutil
CPU_SCALING_GOVERNOR_ON_BAT=powersave

# Set the min/max frequency available for the scaling governor.
# Possible values depend on your CPU. For available frequencies see
# the output of tlp-stat -p.
# Notes:
# - Min/max frequencies must always be specified for both AC *and* BAT
# - Not recommended for use with the intel_pstate scaling driver, use
#   CPU_MIN/MAX_PERF_ON_AC/BAT below instead
# Default: <none>

CPU_SCALING_MIN_FREQ_ON_AC=800000
CPU_SCALING_MAX_FREQ_ON_AC=2900000
#CPU_SCALING_MIN_FREQ_ON_BAT=0
#CPU_SCALING_MAX_FREQ_ON_BAT=0

# Set Intel CPU energy/performance policies HWP.EPP and EPB:
#   performance, balance_performance, default, balance_power, power.
# Values are given in order of increasing power saving.
# Notes:
# - HWP.EPP: requires kernel 4.10, intel_pstate scaling driver and Intel Core i
#   6th gen. or newer CPU
# - EPB: requires kernel 5.2 or module msr and x86_energy_perf_policy from
#   linux-tools, intel_pstate or intel_cpufreq scaling driver and Intel Core i
#   2nd gen. or newer CPU
# - When HWP.EPP is available, EPB is not set
# Default: balance_performance (AC), balance_power (BAT)
# !!!!!!!! Warning !!!!!!!!!
# When use power-profiles-daemon, Default will be not set,
# please use below items in /var/lib/power-profiles-daemon/state.ini
#    1) "balanced" means "balance_performance" in tlp
#    2) "power-saver" means "power" in tlp
#    3) "performance" means "performance" in tlp
# Default: <none>
# !!!!!!!!!!!!!!!!!!!!!!!!!!
# My thinkpad X 240 is EPB.

CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# Set Intel CPU P-state performance: 0..100 (%).
# Limit the max/min P-state to control the power dissipation of the CPU.
# Values are stated as a percentage of the available performance.
# Requires intel_pstate or intel_cpufreq driver and Intel Core i 2nd gen. or
# newer CPU.
# Default: <none>

CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
#CPU_MIN_PERF_ON_BAT=0
#CPU_MAX_PERF_ON_BAT=30

# Set the CPU "turbo boost" (Intel) or "turbo core" (AMD) feature:
#   0=disable, 1=allow.
# Note: a value of 1 does *not* activate boosting, it just allows it.
# Default: <none>

CPU_BOOST_ON_AC=1
#CPU_BOOST_ON_BAT=0

# Set the Intel CPU HWP dynamic boost feature:
#   0=disable, 1=enable.
# Requires intel_pstate scaling driver in 'active' mode and Intel Core i
# 6th gen. or newer CPU.
# Default: <none>

#CPU_HWP_DYN_BOOST_ON_AC=1
#CPU_HWP_DYN_BOOST_ON_BAT=0

# Minimize number of used CPU cores/hyper-threads under light load conditions:
#   0=disable, 1=enable.
# Default: 0 (AC), 1 (BAT)

SCHED_POWERSAVE_ON_AC=0
SCHED_POWERSAVE_ON_BAT=1

# Kernel NMI Watchdog:
#   0=disable (default, saves power), 1=enable (for kernel debugging only).
# Default: 0

#NMI_WATCHDOG=0

# Select platform profile:
#   performance, balanced, low-power.
# Controls system operating characteristics around power/performance levels,
# thermal and fan speed. Values are given in order of increasing power saving.
# Note: check the output of tlp-stat -p to determine availability on your
# hardware and additional profiles such as: balanced-performance, quiet, cool.
# Default: <none>
# !!!!!!!! Warning !!!!!!!!!
# When use power-profiles-daemon, please use below items in
# /var/lib/power-profiles-daemon/state.ini
#    1) "balanced" is default mode
#    2) "power-saver" mode means "low-power" in ppd
#    3) "performance" mode
# !!!!!!!!!!!!!!!!!!!!!!!!!!


#PLATFORM_PROFILE_ON_AC=performance
#PLATFORM_PROFILE_ON_BAT=low-power

# Define disk devices on which the following DISK/AHCI_RUNTIME parameters act.
# Separate multiple devices with spaces.
# Devices can be specified by disk ID also (lookup with: tlp diskid).
# Default: "nvme0n1 sda"

#DISK_DEVICES="nvme0n1 sda"

# Disk advanced power management level: 1..254, 255 (max saving, min, off).
# Levels 1..127 may spin down the disk; 255 allowable on most drives.
# Separate values for multiple disks with spaces. Use the special value 'keep'
# to keep the hardware default for the particular disk.
# Default: 254 (AC), 128 (BAT)

DISK_APM_LEVEL_ON_AC="254 254"
DISK_APM_LEVEL_ON_BAT="128 128"

# Exclude disk classes from advanced power management (APM):
#   sata, ata, usb, ieee1394.
# Separate multiple classes with spaces.
# CAUTION: USB and IEEE1394 disks may fail to mount or data may get corrupted
# with APM enabled. Be careful and make sure you have backups of all affected
# media before removing 'usb' or 'ieee1394' from the denylist!
# Default: "usb ieee1394"

#DISK_APM_CLASS_DENYLIST="usb ieee1394"

# Hard disk spin down timeout:
#   0:        spin down disabled
#   1..240:   timeouts from 5s to 20min (in units of 5s)
#   241..251: timeouts from 30min to 5.5 hours (in units of 30min)
# See 'man hdparm' for details.
# Separate values for multiple disks with spaces. Use the special value 'keep'
# to keep the hardware default for the particular disk.
# Default: <none>

#DISK_SPINDOWN_TIMEOUT_ON_AC="0 0"
#DISK_SPINDOWN_TIMEOUT_ON_BAT="0 0"

# Select I/O scheduler for the disk devices.
# Multi queue (blk-mq) schedulers:
#   mq-deadline(*), none, kyber, bfq
# Single queue schedulers:
#   deadline(*), cfq, bfq, noop
# (*) recommended.
# Separate values for multiple disks with spaces. Use the special value 'keep'
# to keep the kernel default scheduler for the particular disk.
# Notes:
# - Multi queue (blk-mq) may need kernel boot option 'scsi_mod.use_blk_mq=1'
#   and 'modprobe mq-deadline-iosched|kyber|bfq' on kernels < 5.0
# - Single queue schedulers are legacy now and were removed together with
#   the old block layer in kernel 5.0
# Default: keep

#DISK_IOSCHED="mq-deadline mq-deadline"

# AHCI link power management (ALPM) for SATA disks:
#   min_power, med_power_with_dipm(*), medium_power, max_performance.
# (*) Kernel 4.15 (or newer) required, then recommended.
# Multiple values separated with spaces are tried sequentially until success.
# Default:
#  - "med_power_with_dipm max_performance" (AC)
#  - "med_power_with_dipm min_power" (BAT)

#SATA_LINKPWR_ON_AC="med_power_with_dipm max_performance"
#SATA_LINKPWR_ON_BAT="med_power_with_dipm min_power"

# Exclude SATA links from AHCI link power management (ALPM).
# SATA links are specified by their host. Refer to the output of
# tlp-stat -d to determine the host; the format is "hostX".
# Separate multiple hosts with spaces.
# Default: <none>

#SATA_LINKPWR_DENYLIST="host1"

# Runtime Power Management for NVMe, SATA, ATA and USB disks
# as well as SATA ports:
#   on=disable, auto=enable.
# Note: SATA controllers are PCIe bus devices and handled by RUNTIME_PM further
# down.

# Default: on (AC), auto (BAT)

#AHCI_RUNTIME_PM_ON_AC=on
#AHCI_RUNTIME_PM_ON_BAT=auto

# Seconds of inactivity before disk is suspended.
# Note: effective only when AHCI_RUNTIME_PM_ON_AC/BAT is activated.
# Default: 15

#AHCI_RUNTIME_PM_TIMEOUT=15

# Power off optical drive in UltraBay/MediaBay: 0=disable, 1=enable.
# Drive can be powered on again by releasing (and reinserting) the eject lever
# or by pressing the disc eject button on newer models.
# Note: an UltraBay/MediaBay hard disk is never powered off.
# Default: 0

#BAY_POWEROFF_ON_AC=0
#BAY_POWEROFF_ON_BAT=0

# Optical drive device to power off
# Default: sr0

#BAY_DEVICE="sr0"

# Set the min/max/turbo frequency for the Intel GPU.
# Possible values depend on your hardware. For available frequencies see
# the output of tlp-stat -g.
# Default: <none>

#INTEL_GPU_MIN_FREQ_ON_AC=0
#INTEL_GPU_MIN_FREQ_ON_BAT=0
#INTEL_GPU_MAX_FREQ_ON_AC=0
#INTEL_GPU_MAX_FREQ_ON_BAT=0
#INTEL_GPU_BOOST_FREQ_ON_AC=0
#INTEL_GPU_BOOST_FREQ_ON_BAT=0

# AMD GPU power management.
# Performance level (DPM): auto, low, high; auto is recommended.
# Note: requires amdgpu or radeon driver.
# Default: auto

#RADEON_DPM_PERF_LEVEL_ON_AC=auto
#RADEON_DPM_PERF_LEVEL_ON_BAT=auto

# Dynamic power management method (DPM): balanced, battery, performance.
# Note: radeon driver only.
# Default: <none>

#RADEON_DPM_STATE_ON_AC=performance
#RADEON_DPM_STATE_ON_BAT=battery

# Graphics clock speed (profile method): low, mid, high, auto, default;
# auto = mid on BAT, high on AC.
# Note: radeon driver on legacy ATI hardware only (where DPM is not available).
# Default: default

#RADEON_POWER_PROFILE_ON_AC=default
#RADEON_POWER_PROFILE_ON_BAT=default

# Wi-Fi power saving mode: on=enable, off=disable.
# Default: off (AC), on (BAT)

#WIFI_PWR_ON_AC=off
#WIFI_PWR_ON_BAT=on

# Disable Wake-on-LAN: Y/N.
# Default: Y

WOL_DISABLE=Y

# Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
# A value of 0 disables, >= 1 enables power saving.
# Note: 1 is recommended for Linux desktop environments with PulseAudio,
# systems without PulseAudio may require 10.
# Default: 1

#SOUND_POWER_SAVE_ON_AC=1
#SOUND_POWER_SAVE_ON_BAT=1

# Disable controller too (HDA only): Y/N.
# Note: effective only when SOUND_POWER_SAVE_ON_AC/BAT is activated.
# Default: Y

#SOUND_POWER_SAVE_CONTROLLER=Y

# PCIe Active State Power Management (ASPM):
#   default(*), performance, powersave, powersupersave.
# (*) keeps BIOS ASPM defaults (recommended)
# Default: <none>

#PCIE_ASPM_ON_AC=default
#PCIE_ASPM_ON_BAT=default

# Runtime Power Management for PCIe bus devices: on=disable, auto=enable.
# Default: on (AC), auto (BAT)

#RUNTIME_PM_ON_AC=on
#RUNTIME_PM_ON_BAT=auto

# Exclude listed PCIe device adresses from Runtime PM.
# Note: this preserves the kernel driver default, to force a certain state
# use RUNTIME_PM_ENABLE/DISABLE instead.
# Separate multiple addresses with spaces.
# Use lspci to get the adresses (1st column).
# Default: <none>

#RUNTIME_PM_DENYLIST="11:22.3 44:55.6"

# Exclude PCIe devices assigned to the listed drivers from Runtime PM.
# Note: this preserves the kernel driver default, to force a certain state
# use RUNTIME_PM_ENABLE/DISABLE instead.
# Separate multiple drivers with spaces.
# Default: "mei_me nouveau radeon", use "" to disable completely.

#RUNTIME_PM_DRIVER_DENYLIST="mei_me nouveau radeon"

# Permanently enable/disable Runtime PM for listed PCIe device addresses
# (independent of the power source). This has priority over all preceding
# Runtime PM settings. Separate multiple addresses with spaces.
# Use lspci to get the adresses (1st column).
# Default: <none>

#RUNTIME_PM_ENABLE="11:22.3"
#RUNTIME_PM_DISABLE="44:55.6"

# Set to 0 to disable, 1 to enable USB autosuspend feature.
# Default: 1

#USB_AUTOSUSPEND=1

# Exclude listed devices from USB autosuspend (separate with spaces).
# Use lsusb to get the ids.
# Note: input devices (usbhid) and libsane-supported scanners are excluded
# automatically.
# Default: <none>

#USB_DENYLIST="1111:2222 3333:4444"

# Exclude audio devices from USB autosuspend:
#   0=do not exclude, 1=exclude.
# Default: 1

#USB_EXCLUDE_AUDIO=1

# Exclude bluetooth devices from USB autosuspend:
#   0=do not exclude, 1=exclude.
# Default: 0

#USB_EXCLUDE_BTUSB=0

# Exclude phone devices from USB autosuspend:
#   0=do not exclude, 1=exclude (enable charging).
# Default: 0

#USB_EXCLUDE_PHONE=0

# Exclude printers from USB autosuspend:
#   0=do not exclude, 1=exclude.
# Default: 1

#USB_EXCLUDE_PRINTER=1

# Exclude WWAN devices from USB autosuspend:
#   0=do not exclude, 1=exclude.
# Default: 0

#USB_EXCLUDE_WWAN=0

# Allow USB autosuspend for listed devices even if already denylisted or
# excluded above (separate with spaces). Use lsusb to get the ids.
# Default: 0

#USB_ALLOWLIST="1111:2222 3333:4444"

# Set to 1 to disable autosuspend before shutdown, 0 to do nothing
# Note: use as a workaround for USB devices that cause shutdown problems.
# Default: 0

#USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN=0

# Restore radio device state (Bluetooth, WiFi, WWAN) from previous shutdown
# on system startup: 0=disable, 1=enable.
# Note: the parameters DEVICES_TO_DISABLE/ENABLE_ON_STARTUP/SHUTDOWN below
# are ignored when this is enabled.
# Default: 0

#RESTORE_DEVICE_STATE_ON_STARTUP=0

# Radio devices to disable on startup: bluetooth, nfc, wifi, wwan.
# Separate multiple devices with spaces.
# Default: <none>

#DEVICES_TO_DISABLE_ON_STARTUP="bluetooth nfc wifi wwan"

# Radio devices to enable on startup: bluetooth, nfc, wifi, wwan.
# Separate multiple devices with spaces.
# Default: <none>

#DEVICES_TO_ENABLE_ON_STARTUP="wifi"

# Radio devices to disable on shutdown: bluetooth, nfc, wifi, wwan.
# Note: use as a workaround for devices that are blocking shutdown.
# Default: <none>

#DEVICES_TO_DISABLE_ON_SHUTDOWN="bluetooth nfc wifi wwan"

# Radio devices to enable on shutdown: bluetooth, nfc, wifi, wwan.
# (to prevent other operating systems from missing radios).
# Default: <none>

#DEVICES_TO_ENABLE_ON_SHUTDOWN="wwan"

# Radio devices to enable on AC: bluetooth, nfc, wifi, wwan.
# Default: <none>

#DEVICES_TO_ENABLE_ON_AC="bluetooth nfc wifi wwan"

# Radio devices to disable on battery: bluetooth, nfc, wifi, wwan.
# Default: <none>

#DEVICES_TO_DISABLE_ON_BAT="bluetooth nfc wifi wwan"

# Radio devices to disable on battery when not in use (not connected):
#   bluetooth, nfc, wifi, wwan.
# Default: <none>

#DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth nfc wifi wwan"

# Battery Care -- Charge thresholds
# Charging starts when the charge level is below the START_CHARGE_THRESH value
# when the charger is connected. It stops when the STOP_CHARGE_THRESH value is
# reached.
# Required hardware: Lenovo ThinkPads and select other laptop brands are driven
# via specific plugins, the actual support status is shown by tlp-stat -b.
# For more explanations and vendor specific details refer to
#   https://linrunner.de/tlp/settings/battery.html
# Notes:
# - ThinkPads may require external kernel module(s), refer to the output of
#   tlp-stat -b
# - Vendor specific parameter value ranges are shown by tlp-stat -b
# - If your hardware supports a start *and* a stop threshold, you must
#   specify both, otherwise TLP will refuse to apply the single threshold
# - If your hardware supports only a stop threshold, set the start value to 0

# BAT0: Primary / Main / Internal battery (values in %)
# Note: also use for batteries BATC, BATT and CMB0
# Default: <none>

START_CHARGE_THRESH_BAT0=46
STOP_CHARGE_THRESH_BAT0=50

# BAT1: Secondary / Ultrabay / Slice / Replaceable battery (values in %)
# Note: primary on some laptops
# Default: <none>

START_CHARGE_THRESH_BAT1=46
STOP_CHARGE_THRESH_BAT1=50

# Restore charge thresholds when AC is unplugged: 0=disable, 1=enable.
# Default: 0

RESTORE_THRESHOLDS_ON_BAT=1

# Control battery care drivers: 0=disable, 1=enable.
# Default: 1 (all)

#NATACPI_ENABLE=1
#TPACPI_ENABLE=1
#TPSMAPI_ENABLE=1

# ------------------------------------------------------------------------------
# tlp-rdw - Parameters for the radio device wizard

# Possible devices: bluetooth, wifi, wwan.
# Separate multiple radio devices with spaces.
# Default: <none> (for all parameters below)

# Radio devices to disable on connect.

#DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
#DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
#DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"

# Radio devices to enable on disconnect.

#DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
#DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
#DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""

# Radio devices to enable/disable when docked.

#DEVICES_TO_ENABLE_ON_DOCK=""
#DEVICES_TO_DISABLE_ON_DOCK=""

# Radio devices to enable/disable when undocked.

#DEVICES_TO_ENABLE_ON_UNDOCK="wifi"
#DEVICES_TO_DISABLE_ON_UNDOCK=""
```


