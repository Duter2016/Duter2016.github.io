---
layout:     post
title:      【fcitx5快速输入符号库】及【fcitx5-rime的U模式词库】
subtitle:   从rime转换出的fcitx5快速输入符号库及fcitx5-rime的U模式词库
date:       2023-07-20
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
    - 输入法
---

## 从rime转换出的【fcitx5快速输入符号库】

用excel表把fcitx5-rime上面使用的符号库`symbols.yaml`进行了转换，以使用在fcitx5自带输入法`拼音`、`双拼`的快速输入中。

几乎完整的把`symbols.yaml`中的所有符号转换为`QuickPhrase.mb`。并且使用方法上，基本完全还原了在rime上字母代表的符号集，如rime上数学符号用`/sx`,fcitx5使用该符号库后使用`;sx`可达到完全相同的效果。另添加了一些自定义的快速输入。

使用`;tsf`（提示符）可查看所有可用的快速输入。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/fcitx5%E5%BF%AB%E9%80%9F%E8%BE%93%E5%85%A5%E7%AC%A6%E5%8F%B7%E5%BA%93001.png)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/fcitx5%E5%BF%AB%E9%80%9F%E8%BE%93%E5%85%A5%E7%AC%A6%E5%8F%B7%E5%BA%93002.png)

PS. 避免输入【两位数的数字】第二个数字上屏冲突，输入带圈数字时，`1-10`直接用数字，`11-50`用数字的全拼：

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/fcitx5%E5%BF%AB%E9%80%9F%E8%BE%93%E5%85%A5%E7%AC%A6%E5%8F%B7%E5%BA%93003.png)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/fcitx5%E5%BF%AB%E9%80%9F%E8%BE%93%E5%85%A5%E7%AC%A6%E5%8F%B7%E5%BA%93004.png)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2023/07/fcitx5%E5%BF%AB%E9%80%9F%E8%BE%93%E5%85%A5%E7%AC%A6%E5%8F%B7%E5%BA%93005.png)

【fcitx5快速输入符号库】为附件中`QuickPhrase_backup.mb.zip`，【附件下载地址见文末】！

## fcitx5-rime的U模式词库

fcitx5 进步很大，已经有“U模式”了，虽然很少能用这个功能，但是别人有的，rime输入法也不能缺！

rime有强大定制性，网络上已经有分享的rime的U模式，但是挂载的词库是全拼输入法下的U模式词库！既然思路明白了，那就自己动手再改改，改成了自己用的小鹤双拼的U模式词库！

① 适用于`小鹤双拼的U模式词库`献上：

附件中下载：`rime_U模式小鹤双拼词库.zip`

现在，用“ujbjbjb”也能打出来“鑫”了！

② 使用其他输入方案的自己拿去用全拼方案的修改：

附件中下载：`rime_U模式全拼词库_chaizi.zip`

全拼方案的U模式“鑫”为“ujinjinjin”。

【附件下载地址】：链接: [https://pan.baidu.com/s/1WEHuHr73cj6k4ZkaIIEWAQ](https://pan.baidu.com/s/1WEHuHr73cj6k4ZkaIIEWAQ) 提取码: kptt 
