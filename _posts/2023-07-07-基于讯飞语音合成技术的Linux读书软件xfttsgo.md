---
layout:     post
title:      基于讯飞语音合成技术的Linux读书软件xfttsgo
subtitle:   基于Ubuntu及衍生版如Linux Mint
date:       2023-07-07
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---


### 1.背景

现在linux下的edge浏览器已经不能使用朗读功能了，如果还想在浏览器中使用网页阅读功能可以安装readaloud扩展，但是因为众所周知的网络原因不大好用。于是乎试图找一个linux下单独的文本朗读软件！

经过查找，发现一个可以在linux系统下使用讯飞语音合成SDK阅读文本的软件xfttsgo！

这是作者的一个简介：

> 这是本人用讯飞语音合成技术离线开发包编写的终端阅读软件，用于阅读TXT文件（UTF-8）。可以阅读单个文件，也可以连续阅读整个目录中的所有TXT文件，并且阅读目录时能够记录阅读进度，继续阅读。能够边阅读边显示文字，也能够将TXT文件转换为WAV音频文件。

### 2.安装方法

（1）到 `[讯飞开放平台](`https://www.xfyun.cn/) 注册一个用户帐号，然后创建新应用，

![image.png](https://storage.deepin.org/thread/202307072147449986_image.png)

（2）点开你刚开创建的应用，接着下载“语音合成”->“离线语音合成(高品质版)”，

![image.png](https://storage.deepin.org/thread/202307072150294834_image.png)

注意下载时候需要实名认证！

![image.png](https://storage.deepin.org/thread/20230707215341754_image.png)

**注意：**下载“讯飞语音合成技术离线开发包”的有效期是三个月，如果过期了，请自行到 `https://www.xfyun.cn/`下载。

（3）下载xfttsgo

作者编译好的软件：[https://www.rocket049.cn/data/xfttsgo.zip](https://www.rocket049.cn/data/xfttsgo.zip)

或者源代码下载： [https://gitee.com/rocket049/xunfei-tts-offline](https://gitee.com/rocket049/xunfei-tts-offline)

（4）安装xfttsgo

先解压下载的xfttsgo.zip文件，然后打开终端进入该目录，运行下面的安装命令：

```
chmod u+x install.sh
./install.sh
```

然后做2件事：

① 编辑 `~/.xfttsgo/login-param.txt`，填入新的 `APPID`，格式是这样的：`appid = XXXXXXXX, work_dir = .`。

② 解压缩下载讯飞离线语音合成包的压缩包，用其中的 `bin/msc`目录替换掉 `HOME/.xfttsgo/msc`目录。

### 3.使用方法

使用命令如下：

```
xfttsgo [选项] [文件或目录]
可用选项:
  无参数  播放具体文件，此时'-skip'参数有效
  -d	播放目录，此时'-skip'参数无效
  -h	显示帮助信息
  -log
    	查看上次阅读记录。
  -o string
    	输出文件，保存为WAV音频文件，此时'-d -skip'参数无效
  -skip int
    	跳过段数
  -voice int
    	选择声音。1-女声，2-男声。 (default 1)
```

比如我在目录 `/home/user/下载/xfttsgo/`下放了一个utf-8编码的txt文本 `1.txt`，我使用如下命令就可以阅读了：

`xfttsgo -d /home/user/下载/xfttsgo/`

或

`xfttsgo /home/user/下载/xfttsgo/1.txt`

** 强调必须是TXT文件（UTF-8编码）**

> txt文本文档最后一定要流出一段空行，否则最后一段文本会不读取！
>
> 文本文档名字随便写，目录正确即可！

下面是我测试的《老残游记》部分文本：

![image.png](https://storage.deepin.org/thread/202307072208518619_image.png)

非常好用！

### 4.调用xfttsgo阅读网页内容

**（1）思路**

① 先选取浏览器网页想阅读的内容范围，然后快捷键“CTRl+C”（或右键复制）复制到剪贴板

② 新建文本文件`/home/user/下载/xfttsgo/web/1.txt`，然后通过如下命令将剪贴板内容保存至文本文件`/home/user/下载/xfttsgo/web/1.txt`：

`echo $(parcellite --clipboard) > /home/user/下载/xfttsgo/web/1.txt`

PS.我系统中使用的剪贴板工具是Parcellite，如果你使用的是xclip或者xsel等，把上述命令中的`parcellite`更改为`xclip`者`xsel`。

③ 用如下命令阅读刚保存的文本内容：

`xfttsgo /home/user/下载/xfttsgo/web/1.txt`

**（2）整合成快速执行的命令**

我们把上述的思路整合一下就是：
```
echo $(parcellite --clipboard) > /home/user/下载/xfttsgo/web/1.txt && xfttsgo /home/user/下载/xfttsgo/web/1.txt
```

整合后命令太长了，不方便终端输入，我们可以将这条命令通过如下两种方法快速执行命令：

① 命令别名 alias 方法：

打开用户配置文件 `~/.bash_profile` ， 在文件最后添加如下 alias（注意是英文半角单引号，xfw名字可以自定义）：

```
alias xfw='echo $(parcellite --clipboard) > /home/user/下载/xfttsgo/web/1.txt && xfttsgo /home/user/下载/xfttsgo/web/1.txt'
```
保存后回到命令行执行以下命令使其生效：

`source ~/.bash_profile`

命令行使用方法：

这里我们假设已经在网页复制了文本到剪贴板中，则在终端执行如下命令就可以立即阅读了：

`xfw`

② 利用fcitx5的快速输入功能：

如果你使用的fcitx4输入法，就使用方法①就可以了，如果你使用的fcitx5输入法，你还可以使用fcitx5的快速输入功能执行上述的整合后的长命令：

依次打开“fcitx5 设置-->选中当前输入法-->quick phrase -->添加”

keyword：`xfw`

phrase：`echo $(parcellite --clipboard) > /home/user/下载/xfttsgo/web/1.txt && xfttsgo /home/user/下载/xfttsgo/web/1.txt`

然后一路确定保存就行了。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/xfttsgo.png)

命令行使用方法：

这里我们假设已经在网页复制了文本到剪贴板中，则在fcitx5输入法输入`；xfw`，就出来上述整合命令的候选项了，直接选择上屏回车执行就好了

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/xfttsgo_01.png)

又简单了一大步！

## 参考

* [基于讯飞语音合成技术的Linux读书软件xfttsgo](https://www.rocket049.cn/xfttsgo.md)

* [xunfei-tts-offline](https://gitee.com/rocket049/xunfei-tts-offline)


