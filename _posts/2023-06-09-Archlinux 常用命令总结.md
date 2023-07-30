---
layout:     post
title:      Archlinux 常用命令总结
subtitle:   pacman yay等命令使用方法
date:       2023-06-09
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - ArchLinux
    - Linux
---



## 一、pacman命令

**更新系统：**

`pacman -Syu`


### 1.pacman安装、升级软件包

**安装过程中，若不小心终止了 pacman 进程，则需要先删除 `/var/lib/pacman/db.lck` 才能再次启动 pacman！**

（1）安装一个或者多个指定的软件包：

①通过-S后面跟包名的命令，只在官方源仅搜索软件包全名的包：

`pacman -S 软件包名`

② 通过-Syu后面跟包名的命令，会直接在官方源搜索带有`foo`关键词的所有包（包名和简介中只要出现foo都会被一网打尽）：

`pacman -Syu 软件包名`

（2）同步远程软件库与本地软件库，并且更新系统的所有软件包，但不包括不在软件库中的“本地安装的”包：

`pacman -Syu`
 
（3）**强制**同步远程与本地存储库，并更新系统（**一般使用 -Syu 即可**）

`pacman -Syyu`

（4）同步软件包，让本地的包数据库与远程的软件仓库同步，但不升级系统

`pacman -Syy`

（5）安装时遇到文件冲突，并强制覆盖：

`pacman -S –overwrite 要覆盖的文件模式**`  //强制pacman`覆盖与给模式匹配的文件

（6）下载包而不安装它：

`pacman -Sw 软件包名`

`pacman -Syyw 软件包名`   //下载较新的软件包，但不安装

**pacman参数：**

* `-S` 代表同步synchronization，它的意思是 `pacman` 在安装之前先与远程软件库进行同步。
* `y` 代表更新本地主程序包存储库，是主程序包数据库的本地副本
* `yy` 代表强制更新
* `u` 代表系统更新


### 2.pacman卸载软件包

（1）卸载一个指定的软件包，并且**删除它的所有依赖包**。
`pacman -R 软件包名`

（2）删除一个包，以及**删除被本软件依赖但不被其他包使用的依赖包**：

`pacman -Rs 软件包名`

（3）删除软件包，及**删除其所有没有被其他已安装软件包使用的依赖包**

`sudo pacman -Rns 软件包名`

（4）**删除孤立包**

`pacman -Rns $(pacman -Qtdq)`

也可以使用 `pacman -Rsc $(pacman -Qtdq)` 

**pacman参数：**

* `-R` 删除remove 
* `s` 查询搜索
* `-d` 依赖包depend
* `-t` 不需要的包
*`n` pacman 删除某些程序时会备份重要配置文件，在其后面加上.pacsave扩展名。-n 选项可以避免备份这些文件

### 3.pacman查找软件包

（1）在**远程网络软件包仓库**的数据库中搜索包，包括包的名称和描述：

`pacman -Ss 字符串1 字符串2 ...`

（2）查找**已在本地安装**的软件包：

`pacman -Qs 字符串1 字符串2 ...`

（3）检查**本地已安装包**的相关**信息**

`pacman -Qi 软件包名`

（4）在本地已安装包中**找出已安装孤立包**。

`pacman -Qdt`

（5）根据文件路径及文件名**在本地已安装的软件包中**查找文件所属包

`pacman-Qo 文件路径/文件名`

（6）查看哪些包属于一个`软件包组`，运行：

`pacman -Sg gnome软件包组名`

（7）根据**文件名**在**远程软包中**查找它**所属**的包：

`pacman -F 文件名`

（8）查询**某个命令**在**远程软件包**中属于哪个包（即使没有安装）

`pacman -F 命令字符串`

（9）更新命令查询文件列表数据库

`sudo pacman -Fy`

（10）查看一个包的依赖树：

`pactree 软件包名`

**pacman参数：**

* `-Q` 查询本地已安装软件包的数据库
* `-S` 查询远程软件包仓库
* `-F` 查询文件在远程软包仓库中它所以所属的包
* `s` 查询搜索
* `o` 查询
* `i` 查询信息information
* `g` 群组group
* `-d` 依赖包depend
* `-t` 不需要的包
* `-dt` 合并标记孤立包

### 4.pacman清除缓存

`pacman` 将其下载的包存储在 `/var/cache/Pacman/pkg/` 中，并且不会自动删除旧版本或卸载的版本。这有一些优点：

* ① 它允许**降级**一个包，而不需要通过其他来源检索以前的版本。
* ② 已卸载的软件包可以轻松地直接从缓存文件夹重新安装。

但是，有必要定期清理缓存以防止文件夹增大。

（1）要删除当前未安装的所有缓存包和未使用的同步数据库，请执行：

`pacman -Sc`

（2）要从缓存中删除所有文件，请使用清除选项两次，这是最激进的方法，不会在缓存文件夹中留下任何内容：

`pacman -Scc`  //（一般不使用）

（3）`paccache -r` # 删除已安装和未安装包的所有缓存版本，但最近 3 个版本除外（一般不使用）

**pacman参数：**

* `-S` 代表pacman在清理之前先与远程软件库进行同步，确认不需要的缓存包和本地软件包数据库。
* `c` 代表“一个”清除clean
* `cc` 强调是清除clean两次，强调删除所有缓存文件

### 5.pacman安装本地或者第三方的包

（1）安装不是来自远程存储库的“本地”包：

`pacman -U 本地软件包路径.pkg.tar.xz`

（2）安装官方存储库中未包含的“远程”软件包：

`pacman -U http://www.example.com/repo/example.pkg.tar.xz`

**pacman参数：**

* `-U` 代表使用本地包更新

### 6.降级软件包

两种方法：

（1）在 `/var/cache/pacman/pkg/` 中找到旧软件包（包括旧 AUR 软件包），双击打开安装实现手动降级。

也可以配合如下命令在仓库中下载某个版本的包，然后手动安装：

`pacman -Sw 软件包名`

（2）使用downgrade命令

`sudo downgrade 软件包名`

然后会列出一系列的该软件的版本，用数字选择一个你需要的版本即可！

## 二、yay命令

yay是一个AUR Helper，他可以执行pacman的几乎所有操作，yay虽然可以使用pacman的所有`<operation>`，并在此基础上添加了很多额外用法。

**更新系统：**

`yay`

### 1.yay安装软件包

(1)仅执行`yay`更新系统

等同于 `yay -Syu`

当我们仅执行`yay`，后面不跟任何参数时，yay会执行操作`yay -Syu`，他会先调用pacman更新源的数据库、更新所有从源内安装的软件包，并检查你的AUR包有没有更新。

(2)`yay 软件包名`

等同于 `yay -Syu 软件包名`

通过yay后面直接跟包名的命令会让yay直接在官方源和AUR内搜索带有`软件包名`关键词的包（包名和简介中只要出现foo都会被一网打尽）。

（3）`yay -S 软件包名`

通过-S后面直接跟包名的命令，会让yay直接在官方源和AUR内安装指定`软件包名`的包。

### 2.yay卸载软件包

基本与pacman参数相同。

### 3.yay查找软件包

基本与pacman参数相同。

### 4.yay清理缓存

基本与pacman参数相同。

（1）清理不需要的依赖

`yay -Yc`

（2）清理全部软件安装包：

`yay -Scc`

**效果类似于：** 如果使用了 yay 来安装 AUR 中的软件包的话，可以选择清理 yay 的缓存目录：

`rm -rf ~/.cache/yay`

(3)清理无用的孤立软件包：

`yay -Rns $(yay -Qtdq)`

若显示 error: no targets specified (use -h for help) 则说明没有孤立软件包需要清理

(4)清理指定的孤立软件包：

`yay -Rn (package_name)`

### 5.yay软件包降级

在 archlinux 上偶尔会出现某一个包的最新版本有各种问题的情况，此时需要降级该包以正常使用，包可以是普通软件，也可以是内核。为了使用 downgrade 额外的命令需要先安装 downgrade：

`yay -S downgrade`

安装此包即可，使用方法也很简单，downgrade 后加上需要降级的包名即可，随后会提示你选择需要降级到的版本，点选即可。

### 6.yay其他命令

（1）打印系统统计信息

`yay -Ps`

（2）yay 支持在下载时修改 PKGBUILD 文件，方法是

`yay -S --editmenu (package_name)`


**yay参数：**

```
-Y (--yay)
-Y行为其实是yay的默认行为，当你没有加其他的行为参数时，yay就会执行-Y参数，可以跟--gendb和-c。

-P(--show)
执行特定的Print操作。可以跟的[option]有-c、-f、-d、-g、-n、-s、-u、-w、-q

-g(--currentconfig)
Print当前的yay配置。

-G(--getpkgbuild)
后跟包名。需要注意的是，如果指定的包不存在于官方源，则无法输出，后跟-f、-p参数。
如果希望仅获取来自AUR（即排除第三方源的干扰）的PKGBUILD，后需跟-a参数。
yay -Gpa
yay -Ga

-p(--print)
Print指定包的PKGBUILD。
```

## 三、其他安装、卸载相关命令

### 1.从 PKGBUILD 安装软件

在 PKGBUILD 所在的文件夹内执行：

`makepkg -si`

即可安装

### 2.pacman和yay常用查询系统安装信息命令


* `-Qe`：显示用户安装的软件包

* `-Qn`：显示从官方镜像中下载的软件

* `-Qm`：显示从 AUR 中下载的软件

* `-Qs`：显示本地库的包


## 四、vim 的 命令模式 

在`命令模式`下，可以用一些快捷指令来对文本进行操作：

*   此时处在 vim 的 `命令模式` 。在 `命令模式` 下，可以用一些快捷指令来对文本进行操作
*   输入 `a` 进入 vim 的 `编辑模式` ，此时即可输入任意文本进行编辑
*   在输入完成后按下 Esc 键，即可从 `编辑模式` 退出到 `命令模式` 。此时输入 `:wq` 即可保存并退出 vim

*   `:wq` —— 保存退出
*   `:q!` —— 不保存，强制退出
*   `dd` —— 删除一行
*   `2dd` —— 删除两行
*   `gg` —— 回到文本第一行
*   `shift` + `g` —— 转到文本最后一行
*   `/xxx` —— 在文中搜索 xxx 内容。回车 `Enter` 搜索，按 `n` 键转到下一个
*   `?xxx` —— 反向搜索



### 五、 系统服务

命令 systemctl 的用法。以 dhcpcd 服务为例：

```
systemctl start dhcpcd # 启动服务
systemctl stop dhcpcd # 停止服务
systemctl restart dhcpcd # 重启服务
systemctl reload dhcpcd # 重新加载服务以及它的配置文件
systemctl status dhcpcd # 查看服务状态
systemctl enable dhcpcd # 设置开机启动服务
systemctl enable --now dhcpcd # 设置服务为开机启动并立即启动这个单元
systemctl disable dhcpcd # 取消开机自动启动
systemctl daemon-reload dhcpcd # 重新载入 systemd 配置。扫描新增或变更的服务单元、不会重新加载变更的配置
```





## 六、常见命令错误

### 1.pacman 排除常见错误

#### （1）提交事务失败（文件冲突）

> "Failed to commit transaction (conflicting files)" 错误

如果你看到以下报错：
```
error: could not prepare transaction
error: failed to commit transaction (conflicting files)
package: /path/to/file exists in filesystem
Errors occurred, no packages were upgraded.
```
这是因为 pacman 检测到文件冲突，不会为你覆盖文件。

解决这个问题的一个安全方法是首先检查另一个包是否拥有这个文件（pacman-Qo 文件路径）。

#### （2）提交事务失败（包无效或损坏）

> "Failed to commit transaction (invalid or corrupted package)" 错误

在 `/var/cache/pacman/pkg/` 中查找 `.part` 文件（部分下载的包），并将其删除。这通常是由在 `pacman.conf` 文件中使用自定义 `XferCommand` 引起的。

#### （3）初始化事务失败（无法锁定数据库）

> "Failed to init transaction (unable to lock database)" 错误

当 `pacman` 要修改包数据库时，例如安装包时，它会在 `/var/lib/pacman/db.lck` 处创建一个锁文件。这可以防止 `pacman` 的另一个实例同时尝试更改包数据库。

如果 `pacman` 在更改数据库时被中断，这个过时的锁文件可能仍然保留。如果你确定没有 `pacman` 实例正在运行，那么请删除锁文件。

检查进程是否持有锁定文件：

`lsof /var/lib/pacman/db.lck`

如果上述命令未返回任何内容，则可以删除锁文件：

`rm /var/lib/pacman/db.lck`

如果你发现 lsof 命令输出了使用锁文件的进程的 PID，请先杀死这个进程，然后删除锁文件。