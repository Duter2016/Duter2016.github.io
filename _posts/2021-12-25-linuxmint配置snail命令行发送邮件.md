---
layout:     post
title:      linuxmint配置snail命令行发送邮件
subtitle:   原heirloom-mailx已不可用
date:       2021-12-25
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---

> 从ubuntu 18.04开始，`heirloom-mailx`已经不在Ubuntu官方源里提供，替而代之的是`S-nail`。由于linuxmint 20.2基于Ubuntu 20.04，因此，我们如果想使用shell命令发送邮件，我们直接选择`s-nail`就好。

> 我尝试过`mailutils+postfix`的方案，略复杂一点，所以没有使用。

## 配置 apt 源并安装S-nail


通过在终端中输入以下命令来安装 s-nail：
```
sudo apt update
sudo apt install s-nail
```

## 配置 s-nail

```
vi /etc/s-nail.rc
```

添加如下内容;

```
# 文件最后附加：
set from="xxx@qq.com"
set smtp="smtps://smtp.qq.com:465"
set smtp-auth-user="xxx@qq.com"
set smtp-auth-password="xxx" # QQ邮箱设置->账户->开启“POP3/SMTP服务”生成授权码
set smtp-auth=login
```

## 测试

```
 # 示例1：
echo "邮件内容" | s-nail  -s "邮件主题" xxx@nicholas_ksd.com
 # 示例2：
s-nail  -s "邮件主题" xxx@nicholas_ksd.com  < result.txt
```

示例1中，`echo`后写文件正文内容，`-s`后为邮件标题，后面为邮件接收人。

示例2中，为邮件正文从文档读取。

其他常用参数（可用命令`s-nail -h` 查看）：
```
-a 附件
-c 抄送
-b 密送
```

## 参考

更详细的s-nail命令参数可以查阅以下链接：

* [http://manpages.ubuntu.com/manpages/focal/en/man1/s-nail.1.html]
