---
layout:     post
title:      Arch Linux 常用命令总结
subtitle:   pacman yay等命令使用方法
date:       2023-06-09
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Arch Linux
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


## 六、一些有用的命令总结

### 1.获取设备信息

**（1）简要信息**

可以使用能显示系统图标的 `neofetch`，在终端中输入：（需要下载 `neofetch` 软件包）

```bash
neofetch
```

或者使用功能更强大的 `inxi`：（需要在 AUR 中下载 `inxi` 软件包）

```bash
sudo inxi -b
```

**（2）详细信息**

在终端中输入：

```bash
sudo inxi -Fa
```

**（3）内核版本**

在终端中输入：

```bash
uname -a
```

**（4）操作系统版本**

在终端中输入：（需要 `lsb-release` 软件包）

```bash
lsb_release -a
```

### 2.进程、内存、日志管理

**（1）命令行进程查看器**

在终端中输入：（需要 `htop` 软件包）

```bash
htop
```

**（2）内存使用情况**

`free` 显示系统中已用和未用的物理内存和交换内存、共享内存和内核使用的缓冲区的总和

在终端中输入：（默认单位是 KiB，即 1024 字节）

```bash
free
```

**Linux 的内存策略和使用指南可以参考这个网站：[Linux ate my RAM](https://www.linuxatemyram.com/)**

**（2）上一次关机的系统日志**

```bash
journalctl -rb -1
```

### 3.文件权限与属性

**（1）查看文件权限与属性**

查看当前目录下所有文件（包括目录文件，即文件夹）的权限与属性：

```bash
ls -l
```

输出部分开头由 10 位字母或 `-` 符号组成，如 `drwxr-xr-x`

第一个字母代表文件类型，`d` 表示目录文件，`-` 表示普通文件

后面 9 个字母代表文件的权限：第 1-3 个字母代表所有者对文件的权限，第 4-6 个字母代表用户组对该文件的权限，第 7-9 个字母代表所有其他用户对该文件的权限

其中 `r` 代表读取权限，`w` 代表修改权限，`x` 代表执行权限（非可执行文件，如文本文件，本身就没有执行权限），`-` 代表没有该类型的权限

**（2）修改文件权限**

在终端里使用 `chmod` 命令可以修改文件权限：

```bash
chmod (who)=(permissions) (file_name)
```

其中的 `(who)` 是一个或者多个字母，可以是 `u`（所有者）、`g`（用户组）、`o`（所有其他用户）、`a`（以上所有，等价于 `ugo`）

权限 `(permissions)` 用 `r`、`w`、`x` 表示

中间的 `=` 符号是覆盖性的，`chmod` 命令允许使用 `+` 或 `-` 从现有集合中添加和减去权限，例如：

```bash
chmod u+x (file_name)
```

可以给文件添加所有者的可执行权限

`chmod` 也可以用数字来设置权限，此时 `r=4`、`w=2`、`x=1`，如 `rwxr-xr-x` 等于 `755`，这样可以同时编辑所有者、用户组和其他用户的权限：

```bash
chmod 755 (file_name)
```

大多数目录被设置为 `755`，以允许所有者读取、写入和执行，但拒绝被其他所有人写入

非可执行的文件通常是 `644`，以允许所有者读取和写入，但允许其他所有人读取，可执行文件则为 `744`

如果要递归修改，可以加入 `-R` 参数

更多设置和用法参考以下网址：

[File permissions and attributes -- ArchWiki](https://wiki.archlinux.org/title/File_permissions_and_attributes)

**（3）修改文件用户组**

在终端里使用 `chgrp` 命令可以修改文件所属的用户组：

```bash
chgrp (group_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

**（4）修改文件所有者**

在终端里使用 `chown` 命令可以修改文件所有者：

```bash
chown (user_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

也可以同时修改所有者和用户组：

```bash
chown (user_name):(group_name) (file_name)
```

### 4.文件操作命令

**（1）查看并转换编码**

查看编码的命令为：

```bash
file -i (file_name)
```

其中 `charset` 一栏的输出即为文件编码

转换编码可以使用系统预装的 `iconv`，方法为：

```bash
iconv -f (from_encoding) -t (to_encoding) (from_file_name) -o (to_file_name)
```

该方法适合对文本文件转换编码，对 ZIP 压缩包和 PDF 文件等二进制文件则无法使用

`iconv` 支持的编码格式可以用 `iconv -l` 查看

**（2）转换图片格式**

这需要 `imagemagick` 软件包，它提供了 `convert` 等命令

例如批量将图片从 PNG 格式转换为 JPG 格式：

```bash
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
```

**（3）查找命令**

`grep` 命令的用法为在文件或命令输出中查找字符串，例如：

```bash
grep (pattern) (file_pattern)
```

即为在当前目录文件名符合 `file_pattern` 的文件中查找字符串 `pattern`

又例如：

```bash
pamac list | grep (pattern)
```

可以查询已安装的软件包中名字含有 `pattern` 的软件包

**（4）获取命令执行的时间**

使用 `time` 命令在任何命令前面可以获取命令执行的时间：

```bash
time (command)
```

输出有三行：`real` 一行是命令执行的总时间，`user` 一行是指令执行时在用户态（user mode）所花费的时间，`sys` 一行是指令执行时在内核态（kernel mode）所花费的时间

**（5）命令行比较两个文件**

可以用 Linux 自带的 `diff` 命令，它可以逐行比较两个文件（如果是二进制文件则直接输出是否存在差异）：

```bash
diff (file_name_1) (file_name_2)
```

这里的文件也可以换成路径，详细用法可以用 `diff --help` 查询

**（6）批量更改文件名**

可以用 Linux 自带的 `rename` 命令：

```bash
rename -- "(old_name)" "(new_name)" (files)
```

这里的参数 `--` 是为了防止在 `"old_name"` 中出现连字符导致识别错误（将其识别为参数）而添加的

例如将本文件夹下所有文件的文件名中空格改为下划线，即执行：

```bash
rename -- " " "_" ./*
```

详细用法可以用 `rename --help` 查询

**（7）批量更改文件**

推荐使用 `sed` 命令处理：

```bash
sed -ie 's/(old_string)/(new_string)/g' (files)
```

## 七、常见命令错误

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