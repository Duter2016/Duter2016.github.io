---
layout:     post
title:      VSCode 使用 Todo Tree 添加标记配置
subtitle:   添加TODO NOTE等标记的配置
date:       2021-04-20
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Git
    - VSCode
---

## 1. 添加 Todo Tree 扩展

在搜索框中输入todo，检索出来的第一个结果Todo Tree就是需要安装的。点击右下角的install，等待其完成安装。

## 2. 对 Todo Tree 进行配置

首先，快捷键 ctrl + ,打开设置。

然后，点击右上角的这个图形，进入设置的 json 文件。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2021/04/Todo%20tree.png)

将以下内容粘贴至打开文件的最外层的大括号{}内：

```
    //todo-tree settings
    "todo-tree.general.tags": [
        "TODO",
        "FIXME",
        "TAG",
        "DONE",
        "NOTE",
        "BUG",
        "HACK",
    ],
    "todo-tree.regex.regex": "((%|#|//|<!--|^\\s*\\*)\\s*($TAGS)|^\\s*- \\[( |x|X)\\])",
    "todo-tree.regex.regexCaseSensitive": true,
    "todo-tree.tree.showScanModeButton": true,
    "todo-tree.highlights.defaultHighlight": {
        "foreground": "white",
        "background": "purple",
        "icon": "check",
        "rulerColour": "purple",
        "type": "tag",
        "iconColour": "purple"
    },
    "todo-tree.highlights.customHighlight": {
        "TODO": {
            "background": "red",
            "rulerColour": "red",
            "iconColour": "red"
        },
        "FIXME": {
            "background": "yellow",
            "icon": "beaker",
            "rulerColour": "yellow",
            "iconColour": "yellow",
        },
        "BUG": {
            "background": "yellow",
            "icon": "beaker",
            "rulerColour": "yellow",
            "iconColour": "yellow",
        },
        "TAG": {
            "background": "blue",
            "icon": "tag",
            "rulerColour": "blue",
            "iconColour": "blue",
            "rulerLane": "full"
        },
        "DONE": {
            "background": "green",
            "icon": "issue-closed",
            "rulerColour": "green",
            "iconColour": "green",
        },
        "NOTE": {
            "background": "#f90",
            "icon": "note",
            "rulerColour": "#f90",
            "iconColour ": "#f90"
        }
```

此正则表达式要求markdown中`[ ]`的todo格式需要为：

```
如下的格式“- [ ] 测试”

如下的格式“- [x] 测试”

```

> 注：不要使用默认的配置，默认配置的正则表达式会不匹配开始的符号，造成匹配很多错误的标记！
