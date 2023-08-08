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

### 5.Archlinux 安装及配置 TLP 高级电源管理工具


#### 1）tlp 与 power-profiles-daemon的选择问题

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


#### 2）安装TLP

##### （1）卸载与tlp冲突的power-profiles-daemon

如果系统中默认安装了power-profiles-daemon。那么先禁用power-profiles-daemon.service服务，执行以下命令：

`sudo systemctl mask power-profiles-daemon.service`

然后卸载有冲突的 power-profiles-daemon 软件包：

`sudo pacman -Rs power-profiles-daemon`

或者安装TLP时，根据提示卸载也可以。

##### （2）开始安装TLP

① 对于基于 Archlinux 的系统，使用 Pacman 命令 安装 TLP：

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

> 如果你使用的内核是`linux`内核，选择安装上面的tp_smapi和acpi_call；如果你使用的`linux-lts`内核，就选择安装tp_smapi-lts和acpi_call-lts。我在系统中同时安装了linux和linux-lts内核，我两组都安装了！

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

部分2013 新出的几款 Ivy Bridge 平台的 thinkpad(X230,T430,T530), 可能会遇到无法使用 tp_smapi控制电池充电阈值的情况，例如tp_smapi 可能无法支持 T430, 但是我们还有 tpacpi-bat 可以使用控制其充电阀值（安装acpi_call和tpacpi-bat）：

`sudo pacman -S acpi_call`

`sudo pacman -S acpi_call-lts`

`sudo pacman -S tpacpi-bat`

后面进行配置。

#### 3） 配置TLP

##### (1) 设置开机启动tlp服务

对于基于 Archlinux 的系统，在启动时启用 TLP 和 TLP-Sleep 服务：

```
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service    //我的提示Unit file tlp-sleep.service does not exist.
```

##### （2）设置tlp-rdw服务

在使用(tlp-rdw包)之前需要使用NetworkManager并且需要启用NetworkManager-dispatcher.service:

`sudo systemctl enable NetworkManager-dispatcher.service`

也应该屏蔽 systemd 服务systemd-rfkill.service 以及套接字 systemd-rfkill.socket 来防止冲突，保证TLP无线设备的开关选项可以正确运行:

```
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
```

##### （3）安装图形化界面工具 TLPUI 管理工具

TLPUI（https://github.com/d4nj1/TLPUI）是用Python和GTK编写的TLP的图形界面，可以读取和显示TLP配置，显示默认值和未保存的更改以及加载tlp-stat以查看简单而完整的统计信息。

`yay -S tlpui`

##### （4）配置tpacpi-bat文件

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

##### （5）配置tlp.conf文件

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

> 参考：[Archlinux CPU调频wiki](https://wiki.archlinuxcn.org/wiki/CPU_%E8%B0%83%E9%A2%91)、[CPU调速器schedutil原理分析](https://deepinout.com/android-system-analysis/android-cpu-related/principle-analysis-of-cpu-governor-schedutil.html)

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

##### （6）关于设置后键盘灯自动亮起的问题

**注意：** Thinkpad x 系列等笔记本已经有键盘灯， 但是通过上述设置后， 还有一个问题没有解决： 就是在使用电源供电时，如果在很短的时间内不操作键盘或者鼠标（即进入空闲状态后），键盘灯总是会自动亮起！对着这个问题可以通过“系统设置-电源管理-节能”，然后点击三个选项卡，将“降低屏幕亮度”、“屏幕节能”前面的勾去掉既可以解决问题。 

#### 4）TLP常用命令

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
* [Archlinux TLP wiki](https://wiki.archlinuxcn.org/wiki/TLP)

### 6.使用 thinkfan 控制 thinkpad 风扇转速

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

### 7.显示 Intel CPU 频率（可选）不可安装，会让风扇启动失败

**安装thinkfan的用户万万不可安装[Intel P-state and CPU-Freq Manager]，其依赖libsmbios是Dell's Thermal Management Feature，会破坏thinkfan的thinkpad_hwmon温度感应**

KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/frankenfruity/plasma-pstate)

### 8.Thinkpad 笔记本安装硬盘保护模块

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

#### 4）解决 Fcitx5 中文输入法无法输入全角中括号【】

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

（3）安装emoji字体

`sudo pacman -S noto-fonts-emoji`

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
* [https://blog.csdn.net/apollo_miracle/article/details/116007968]
* [https://www.ancii.com/adj83v55p/]

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

### 15.配置插入鼠标禁用触摸板功能

Archlinux在刚安装好，时默认是安装了xf86-input-libinput和libinput的，一般不需要手动安装。并且可以在`设置>>系统设置>>输入设备>>触摸板`中设置很多项，如“打字时禁用”等。

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

`Option "SendEventsMode" "disabled-on-external-mouse"

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

**附加：**也可安装支持B站、油管、虎牙的[revda](https://github.com/THMonster/Revda)

`yay -S revda-git`

revda也是调用的mpv,并且支持弹幕。只需要获取视频播放地址的代码就可以，当想要打开bilibili视频时，它支持av号、bv号、ep号、ss号或直接输入链接，多p视频如果想通过av、bv号或者ss号打开，请在编号后加上:n（n为视频p数）打开，例如：你想打开av123456的第三p，请输入av123456:3，bv号与ss号同理。。比如三国演义的一集播放地址为“https://www.bilibili.com/bangumi/play/ep327612?from_spmid=666.25.episode.0&from_outer_spmid=..0.0”，那么播放代码就是“ep327612”。

详细使用方法见[Revda wiki](https://github.com/THMonster/Revda/wiki/1-%E5%9F%BA%E7%A1%80%E7%94%A8%E6%B3%95)

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

debian系deb包安装完，wps 会在`/usr/share/templates/`下生成模板文件，如果没有这些模板文件，桌面右键新建是没有新建wps文档的选项的。Archlinux安装后，右键新建没有wps文档菜单，只需要解压别的桌面版复制出来模板文件，放到`/usr/share/templates/`目录即可。

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

① 按照谢大神写的教程 [https://yihui.org/tinytex/#for-other-users]， 终端执行如下命令：

`wget -qO- "http://yihui.org/gh/tinytex/tools/install-unx.sh" | sh`

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

② 将其添加到 path(这里如果你用的是 zsh,把 bashrc 改成 zshrc， 其他类推),方法如下：

终端执行命令

`gedit ~/.bashrc`

在打开的文件最后添加如下内容：

`export PATH=$PATH:/home/usename/.TinyTeX/bin/x86_64-linux`

执行如下命令重新部署一下：

`source ~/.bashrc`

③ 先安装perl环境

`sudo pacman -S perl`

安装 XeLaTeX 中文编译引擎。 终端执行：

`sudo pacman -Syu texlive-xetex`

至此， 支持环境已经完成， 如果你不要使用 Latex 进行高级编辑，后面的可以不安装了。 如果需要， 那么就继续下面的操作！

④ 安装中文支持包， 使用的是 xeCJK， 中文处理技术也有很多， xeCJK 是成熟且稳定的一种。

`sudo pacman -Syu texlive-langchinese`

继续安装一些可能必须的模块， 终端依次执行：

`tlmgr install xecjk`

`tlmgr install ctex`

⑤ 使用维护

维护命令可以通过“`tlmgr --help`” 命令获取。

1） 使用如下命令查找组件信息， 如终端运行：

`tlmgr search --file --global "/xecjk"`

2） 显示本机已安装的 Texlive 组件， 终端运行：

`tlmgr info --list --only-installed --data name,size`

3） 报错“File xxx not found.”

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

4） 列示需要更新的包， 终端执行：

`tlmgr update --list`

更新全部

`tlmgr update --self --all`

5） 使用图形界面， 终端执行：

`tlmgr gui`

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

（1）设置markdown实时预览

使用package control安装插件，快捷键Ctrl+Shift+P调出命令面板，找到 `Install Package`选项并回车，稍微等待几秒，然后在出现的列表中搜索安装`MarkdownEditing`、`MarkdownPreview`、`MarkdownLivePreview`、`sync view scroll`四个插件，选中后回车即可安装，安装完成后会弹出“Package Control Messages”的文件。

（2）解决MarkdownEditing 去除左侧空白+更改主题等

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

（3）设置预览和同步滚动热键

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

### 2.汉化文件编译poedit

`sudo pacman -Syu poedit`

### 3.python-pip

`sudo pacman -Syu python-pip python-setuptools`

消除pip3安装模块时的错误：

`sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED`

### 4.安装开源版vscodium

sudo pacman -Syu code

### 5.安装git-cola

`yay git-cola`   //有依赖冲突，暂时未安装

注意：上述从Archlinux的AUR中安装git-cola编译过程中存在冲突，无法正常安装，可以在[pkgs.org](https://pkgs.org/download/git-cola)下载Archlinux的zst离线安装包，比如我下载的【Chaotic AUR x86_64 Third-Party】的[git-cola-4.2.1-3-any.pkg.tar.zst](https://archlinux.pkgs.org/rolling/chaotic-aur-x86_64/git-cola-4.2.1-3-any.pkg.tar.zst.html),下载后，使用如下命令安装即可：

`sudo pacman -U git-cola-4.2.1-3-any.pkg.tar.zst`

实测可用！

也可以暂用gitg、smartgit等：

`sudo pacman -S gitg`   //免费

`sudo pacman -S smartgit`  //非完全免费，需注册

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


### 4.启动时grub界面报错vconsole

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

### 5.启动时grub报错systemd-modules-load.service

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

### 6.

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

### 2. TLP 的 tlp.conf文件内容

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


