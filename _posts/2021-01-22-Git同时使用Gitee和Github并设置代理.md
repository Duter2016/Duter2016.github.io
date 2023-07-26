---
layout:     post
title:     Git同时使用Gitee和Github并设置代理
subtitle:   Linux中Git设置方法及Proxy设置
date:       2021-01-22
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Git
---

# Git 同时使用 Gitee 和 Github 并设置代理


> **分别为Gitee 和 Github建立两个密钥，不同账号配置不同的密钥，为github和gitee仓库配置不同密钥。**

## 1.清除 git 的全局设置（针对已安装 git）

新安装 git 跳过。

若之前对 git 设置过全局的 `user.name` 和 `user.email`。  
类似 (用 `git config --global --list` 进行查看你是否设置)

```
$ git config --global user.name "你的名字"
$ git config --global user.email  "你的邮箱"
```

必须删除该设置

```
$ git config --global --unset user.name "你的名字"
$ git config --global --unset user.email "你的邮箱"
```

## 2.生成新的 SSH keys

### 1）GitHub 的钥匙

指定文件路径，方便后面操作：`~/.ssh/id_rsa.gitlab`

```
ssh-keygen -t rsa -f ~/.ssh/id_rsa.github -C "lx@qq.com"
```

直接回车3下，什么也不要输入，就是默认没有密码。

注意 github 和 gitee 的文件名是不同的。

### 2）Gitee 的钥匙

```
ssh-keygen -t rsa -f ~/.ssh/id_rsa.gitee -C "lx@qq.com"
```

### 3)完成后会在~/.ssh / 目录下生成以下文件

```
*   id\_rsa.github
*   id\_rsa.github.pub
*   id\_rsa.gitee
*   id\_rsa.gitee.pub
```

## 3.添加识别SSH keys新的私钥,并添加到ssh-agent

默认只读取 id\_rsa，为了让 SSH 识别新的私钥，需要将新的私钥加入到 ssh-agent 中

```
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa.github
$ ssh-add ~/.ssh/id_rsa.gitee
```

## 4. 多账号必须配置 config 文件(重点)

若无 config 文件，则需创建 config 文件

### 1)创建config文件

在 `.ssh/` 目录下新建一个名为 config 的文件。
用文本编辑器打开，并进行编辑，或执行下面命令。

```
$ touch ~/.ssh/config
```

### 2)config 里需要填的内容

亲测可以不缩进，所以方便看，建议缩进。

#### 最简配置

```
#github
Host github.com
HostName github.com
IdentityFile ~/.ssh/id_rsa.github
```

#### 完整配置

```
#Default gitHub user Self
Host github.com
HostName github.com
User your@email
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa.github
AddKeysToAgent yes

#Add gitee user
Host gitee.com
HostName gitee.com
User your@email
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa.gitee
AddKeysToAgent yes
```

下面对上述配置文件中使用到的配置字段信息进行简单解释：

> *   Host  
    它涵盖了下面一个段的配置，我们可以通过他来替代将要连接的服务器地址。  
    这里可以使用任意字段或通配符。  
    当ssh的时候如果服务器地址能匹配上这里Host指定的值，则Host下面指定的HostName将被作为最终的服务器地址使用，并且将使用该Host字段下面配置的所有自定义配置来覆盖默认的/etc/ssh/ssh\_config配置信息。
 
> *   Port  
    自定义的端口。默认为22，可不配置

> *   User  
    自定义的用户名，默认为git，设置为你的注册邮箱,也可不配置，不写邮箱，每次都报please tell who you are！
 
> *   HostName  
    真正连接的服务器地址

> *   PreferredAuthentications  
    指定优先使用哪种方式验证，支持密码和秘钥验证方式

> *   IdentityFile  
    指定本次连接使用的密钥文件

> *   AddKeysToAgent yes   
    加载到 ssh-agent，等同于`$ ssh-add ~/.ssh/id_rsa.github`

## 5.在 github 和 gitee 网站添加 ssh

### 1) Github

Github 添加SSH公钥

直达地址：[https://github.com/settings/keys](https%3A%2F%2Fgithub.com%2Fsettings%2Fkeys)

过程如下：

(1)  登录 Github

(2)  点击右上方的头像，点击 `settings`

(3)  选择 `SSH key`

(4)  点击 `Add SSH key`

在出现的界面中填写 SSH key 的名称，填一个你自己喜欢的名称即可。  
将上面拷贝的`~/.ssh/id_rsa.xxx.pub`文件内容粘帖到 key 一栏，在点击 “add key” 按钮就可以了。

添加过程 github 会提示你输入一次你的 github 密码 ，确认后即添加完毕。

### 2) Gitee  码云

码云 添加SSH公钥

直达地址：[https://gitee.com/profile/sshkeys](https%3A%2F%2Fgitee.com%2Fprofile%2Fsshkeys)

(1)  登录 Gitee

(2)  点击右上方的头像，点击 `设置`

(3)  后续步骤如 Github

添加过程 码云 会提示你输入一次你的 Gitee 密码 ，确认后即添加完毕。

## 6.测试是否连接成功

由于每个托管商的仓库都有唯一的后缀，比如 Github 的是 [git@github.com](mailto%3Agit%40github.com):\*。

所以可以这样测试：  
```
ssh -T git@github.com
```

而 gitlab 的可以这样测试：  
```
ssh -T git@gitee.com
```
如果能看到一些 Welcome 信息，说明就是 OK 的了

```
    $ ssh -T git@github.com
    
    Warning: Permanently added the RSA host key for IP address '13.250.177.223' to the list of known hosts.
    Hi dragon! You've successfully authenticated, but GitHub does not provide shell access.
    
    $ ssh -T git@gitee.com 
    
    The authenticity of host 'gitee.com (116.211.167.14)' can't be established.
    ECDSA key fingerprint is SHA256:FQGC9Kn/eye1W8icdBgrp+KkGYoFgbVr17bmjeyc.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'gitee.com,116.211.167.14' (ECDSA) to the list of known hosts.
    Hi 我是x! You've successfully authenticated, but GITEE.COM does not provide shell access.
```

结果如果出现这个就代表成功：

```
*   GitHub -> successfully
*   GitLab -> Welcome to GitLab
*   Gitee -> successfully
```

如果结果出现如下错误提示：

```
Bad owner or permissions on /home/username/.ssh/config
```
表示文件权限出现问题，需要运行如下命令就行修改权限就可以了：
```
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/*
```

**测试 clone 项目**

    $ git clone git@gitlab.com:d-d-u/java-xxx.git
    Cloning into 'java-basic'...
    remote: Enumerating objects: 3, done.
    remote: Counting objects: 100% (3/3), done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (3/3), done.
    

## 7.操作过程出现的问题或报错

```tilde\_expand\_filename: No such user```

检查是否成功的时候，报错：

```tilde_expand_filename: No such user .```

解决方法：

此问题是因为`写错了文件路径` 或者 `大小写没写对`，删除重新配置，或者复制我的改好粘贴进去。

## 8.GIT设置代理

如使用 socks5，本地 ip 和端口是 127.0.0.1:1080

### 1)仅设置github代理：

这个只设置了github的git服务走代理通道，不会对国内仓库gitee使用代理。

```
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
#取消设置的代理
git config --global --unset http.https://github.com.proxy
git config --global --unset https.https://github.com.proxy
```

### 2)设置git全面代理：

包括github、gitee等git服务全部走代理通道。

```
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080
#取消设置的代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 9.git其他参数配置

git 的配置文件在`~/.gitconfig`，仓库的配置文件是仓库内的`.git/config`。

可运行`git help git confi`g和`man git`查看更多帮助信息。

官方文档`git-config Manual Pagee`


### 1)部分设置命令：

加上`--global`参数，则设置内容对当前用户生效，不加`--global`则对当前仓库生效。

检查配置情况：`git config --list`

设置默认编辑器，如 nano： `git config --global core.editor nano`

设置默认对比工具，如 meld：`git config --global merge.tool meld`

彩色输出：`git config --global color.ui true`

**中文文件名显示**：  
`git config --global core.quotepath false（避免中文显示成数字 ）`

显示历史记录时每个提交的信息显示一行： `git --global config format.pretty oneline`

### 2)设置全局用户名和电子邮箱（不建议）
```
git config --global user.name "your name"
git config --global user.email "email@example.com
```

### 3)协议更换

如 https 替代 git 协议
```
git config --global url."https://".insteadof "git://"
git config --global url."https://github.com/".insteadof "git@github.com:"
```

### 4)设置命令别名：
`git config --global alias.<another name> status`

## 总结

以上设置完成后，就可以在linux上愉快的使用git客户端了，如Git-cola等。

## 参考文献

* [配置同时使用 Gitlab、Github、Gitee(码云) 共存的开发环境](https://www.jianshu.com/p/68578d52470c)

* [Git 相关操作](https://gist.github.com/maboloshi/7516252fba4aff0309d50ddf097a4937)



