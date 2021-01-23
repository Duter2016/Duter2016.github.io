---
layout:     post
title:      Git或Git-cola在Push时如何避免重复输入密码
subtitle:   也可以使git或git-cola不重复输入密码
date:       2021-01-23
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Git
---

> 我使用的是Linuxmint，桌面环境为mate（属于Gnome系），本文“Libsecret-牢记 Linux Mint 和 Ubuntu 中的 Git 凭证”方法在mate桌面已测试通过。你如果使用的是KDE桌面环境，你可以参考后面的KDE钱包的方法！

当你想使用外部的 git 仓库托管服务，比如 Github 或者 Gitee，你需要自己授权,每次Push推送时，都要输入用户名和密码是繁重和恼人的事情。Git 内置了凭证助手`credential.helper`机制，允许选择持久化凭证的方式，进行认证授权登录。它提供了两个开箱即用的选项（cache缓存或明文存储），适用各种桌面环境，我们将在第二部分介绍。

但您并不局限于这两个选项——您可以安装更安全、更便捷的解决方案：**只需要第一次输入ssh keys的认证授权密码，此后再次使用便不再需要输入密码**。我们将在第一部分（适用Gnome系桌面）和第三部分（适用kde桌面）介绍。

## 一、适用于Gnome系桌面（如mate）的方法

### Libsecret-牢记LinuxMint和Ubuntu中的Git凭证(由GNOME实现)

输入用户名和密码每次推送都是繁重和恼人的事情，libsecret 证书存储可以解决这个问题。

在 Linux 上存储 Git 凭证的最佳方式曾经是 GNOME Keyring (libgnome-Keyring) ，但由于它是针对 GNOME 的，因此自2014年1月以来一直不推荐使用。对于 Git 版本2.11 + ，您应该使用基于 libsecret 的凭据助手。

#### 1)走了点弯路，尝试GNOME Keyring

##### (1)有用点的弯路

**划重点：**在我的系统上gnome-keyring是已经默认安装了。

一翻搜索，在网上找了一堆相关的文章，好多都无效，又找到了“Archlinux wiki”上关于GNOME Keyring的介绍[《GNOME-Keyring》](https://wiki.archlinux.org/index.php/GNOME/Keyring)。根据文章，可以使用 seahorse 管理 GNOME Keyring 的SSH keys等内容：

```
sudo apt-get install seahorse
```
![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/07/git-ssh001.png)

安装seahorse还是有用的，方便查看SSH keys。

##### (2)山路十八弯，弯的有点知识,"见牛羊"了

然后文章[《GNOME-Keyring》](https://wiki.archlinux.org/index.php/GNOME/Keyring)又告诉我了**重点**:“Integration with applications”，即GNOME Keyring可与应用程序集成，并提到了“Git integration”（ Git 集成）！

这是一个有用的知识点，无论这一点能否成功，但毕竟找到了可用线索。开始折腾！

文中提到，当您推入 HTTPS 时，GNOME keyring 在 Git 中非常有用。但需要有安装 libsecret包，我在软件管理器中并找不到libsecret，于是在新立得包管理器中搜索“libsecret”，找到了已安装的“libsecret-1-0_0.20.3-0ubuntu1”，以为没有问题可以使用了！

继续按照指引设置Git来使用 credential.helper:

```
$ git config --global credential.helper /usr/lib/git-core/git-credential-libsecret
```

输入以上命令如果提示：
```
credential helper 有多个
error 无法用一个值覆盖多个值,使用一个正则表达式……

```

这是`~/.gitconfig`中有多个credential.helper取值造成的，那就改为输入：
```
git config --global --replace-all credential.helper /usr/lib/git-core/git-credential-libsecret
```
执行后没有任何提示，表示修改完成。

但是在git-cola进行推送时，却提示：

```
/usr/lib/git-core/git-credential-libsecret: not found
```
进入目录/usr/lib/git-core/下才发现git-credential-libsecret不存在！这可能就是“在 Linux 上存储 Git 凭证的最佳方式曾经是 GNOME Keyring (libgnome-Keyring) ，但由于它是针对 GNOME 的，因此自2014年1月以来一直不推荐使用”这句话要表达的吧！在[《git-core no longer includes support for gnome-keyring integration》](https://bugzilla.redhat.com/show_bug.cgi?id=1474414)可以看到解释。

#### 2)走上正规，正确使用Libsecret

相同的搜索关键词又找到了[《Libsecret - remember Git credentials in Linux Mint and Ubuntu securely》](https://www.softwaredeveloper.blog/git-credential-storage-libsecret)。继续振腾（没想到成功了），Libsecret-牢记LinuxMint和Ubuntu中的Git凭证！

在 Linux 上存储 Git 凭证，对于 Git 版本2.11 + ，您应该使用基于 libsecret 的凭据助手。这里安装和配置Libsecret只需要4个命令，先执行一个命令：
```
sudo apt-get install libsecret-1-0 libsecret-1-dev
```
这时，在`/usr/share/doc/git/contrib/credential/`中是没有`libsecret`文件的，需要自己编译生成。那就再依次执行三个命令：

```
cd /usr/share/doc/git/contrib/credential/libsecret

sudo make

git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
```
这样在`/usr/share/doc/git/contrib/credential/`中已经有`libsecret`文件了。凭证也生效了！

此后，在git或git-cola中push推送文件时，只需要第一次输入用户名和密码，此后每次推送都不再需要输入用户名和密码了！

官方描述- [wiki.gnome.org-projects-libsecret](https://wiki.gnome.org/Projects/Libsecret)


## 二、适用于各种桌面（如gnome系或kde）的方法

### 1)缓存credential helper (开箱即用)

缓存非常安全，因为只将数据保存在内存中。对于安全性而言，这没有问题，但是每次打开新会话时，都需要再次键入凭据。

如果出于某种原因你不想安装任何东西，至少使用 cache:

```
$ git config --global credential.helper 'cache'
```
默认情况下，内存会在900秒(15分钟)后被清除，但是可以使用可选的超时参数进行更改秒数来缓存凭据，使用超时参数(本例中为60分钟) :
```
$ git config --global credential.helper 'cache --timeout=3600'
```
如果需要取消设置缓存，执行：

```
$ git config --unset --global credential.helper 'cache'
$ git config --unset --global credential.helper 'cache --timeout=3600'
```

在超时执行命令之前，先清除凭据缓存:
```
$ git credential-cache exit
```

检查使用帮助手册:
```
$ man git-credential-cache
$ man gitcredentials
```

### 2)Store存储credential helper (开箱即用)

这个方法存储保存您的用户名和密码在... 纯文本文件！它是完全不安全的，只有当你不关心你的帐户时才使用它(例如在某种研讨会上)。

在根目录用touch创建文件 `.git-credentials`：

```
touch ~/.git-credentials
```

进入终端， 输入如下命令：
```
git config --global credential.helper store
```

执行完后查看根目录下的.gitconfig文件，会多了一项：
```
[credential]

    helper = store
```
重新开启git会发现git push时不用再输入用户名和密码。

## 三、适用于KDE桌面的方法


在使用 git 时，在KDE桌面环境中要避免重复输入密码，一个解决方案是需要使用 KDE 钱包，类似于“Libsecret牢记LinuxMint和Ubuntu中的Git凭证”的方法。

在 KDE 钱包中存储密码，你需要安装 ksshaskpass 包(限kde桌面环境):

```
$ sudo apt-get install ksshaskpass
```

然后配置 git 来使用它:
```
$ git config --global core.askpass /usr/bin/ksshaskpass
```

或者你可以使用 GIT_ASKPASS 环境变量:
```
$ export GIT_ASKPASS=`which ksshaskpass`
```

## 总结

由于我使用的mate桌面，第一种方法已测试，对Git-cola也是有效的！第二种的cache方法也测试可以使用，store明文密码方法不安全、没有测试。没有KDE桌面，第三种方法没有测试。

## 参考文献

* [《Libsecret - remember Git credentials in Linux Mint and Ubuntu securely》](https://www.softwaredeveloper.blog/git-credential-storage-libsecret)

* [《GNOME-Keyring》](https://wiki.archlinux.org/index.php/GNOME/Keyring)

