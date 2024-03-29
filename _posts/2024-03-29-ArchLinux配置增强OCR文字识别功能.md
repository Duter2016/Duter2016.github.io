---
layout:     post
title:      Arch Linux配置增强OCR文字识别功能
subtitle:   使用tesseract实现中文OCR识别
date:       2024-03-29
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - OCR
    - Linux
---


## 一、主要思路

+ 1.利用截图软件 `flameshot` 进行截取需要被文字识别的图片，并使用`imagemagick`对图片进行四倍放大；

+ 2.利用文字识别OCR软件`tesseract`，进行识别；

+ 3.将识别到的结果输出，复制到文件和剪切板。

## 二、安装相关软件

需要安装的软件有：`tesseract`、`tesseract-data-chi_sim`、`tesseract-data-chi_sim_vert`、`tesseract-data-chi_tra`、`tesseract-data-chi_tra_vert`、`tesseract-data-eng`、`imagemagick`、`gimagereader-gtk`。

### 1.安装软件主体

(1)使用如下命令安装tesseract：

```
sudo pacman -S tesseract
```

(2)使用如下命令安装imagemagick，用于图片放大：

```
sudo pacman -S imagemagick
```

(3)安装tesseract前端GUI程序（可以不装，如果想用一下GUI,可以安装`gimagereader-gtk`或`gimagereader-qt`）：

```
sudo pacman -S gimagereader-gtk
```

### 2.安装字库

tesseract支持60多种语言的识别，使用之前需要先下载对应语言的字库。

完整字库项目地址：[https://github.com/tesseract-ocr/tessdata](https://github.com/tesseract-ocr/tessdata)  

这里我们只使用简体中文、繁体中文、英文三种字库：`tesseract-data-chi_sim`（简体中文字库）、`tesseract-data-chi_sim_vert`（简体中文垂直方向字库）、`tesseract-data-chi_tra`（繁体中文字库）、`tesseract-data-chi_tra_vert`（繁体中文字库垂直方向字库）、`tesseract-data-eng`（英文字库）。安装命令如下：

```
sudo pacman -S tesseract-data-chi_sim tesseract-data-chi_sim_vert tesseract-data-chi_tra tesseract-data-chi_tra_vert tesseract-data-eng
```

## 三、制作[shell脚本]一键识别，并输出到文件和剪切板

在目录`/home/dh/opt/tesseractOcr/`新建后缀为`.sh`的shell脚本文件，例如命名为`tesseractOcr.sh`，并在同目录下新建文件夹目录`/home/dh/opt/tesseractOcr/screenshot`。

将以下代码复制到文档`tesseractOcr.sh`：

注意：将变量SCR路径部分替换成你想要存放截图以及识别结果txt文档的路径；

```
#!/bin/env bash 
# Dependencies: tesseract imagemagick flameshot xclip(optional) 

#Name: OCR Picture for Arch Linux
#Fuction: take a screenshot and OCR the letters in the picture
#Path: /home/Username/...

#you can only scan one character at a time
SCR="/home/dh/opt/tesseractOcr/screenshot/src"
SCR2="/home/dh/opt/tesseractOcr/screenshot/src2"
# before take a screenshot, if file "SCR.png" exist, delete this file
rm -f $SCR.png
# take a shot what you wana to OCR to text, delay 2 seconds
flameshot gui -p $SCR.png -d 2000

# increase the png
mogrify -modulate 100,0 -resize 400% $SCR.png 
# should increase detection rate

# OCR by tesseract
tesseract $SCR.png $SCR &> /dev/null -l eng+chi_sim+chi_tra+chi_sim_vert+chi_tra_vert

# get the text and copy to clipboard

#sed -i 's/[[:space:]]//g' $SCR.txt # 删除空格方式1
#sed -i 's/\ //g' $SCR.txt  # 删除空格方式2
cat $SCR.txt  | sed -r 's/([^0-9a-z])?\s+([^0-9a-z])/\1\2/ig'>$SCR2.txt  # 解决每个汉字之间有空格的情况，英文单词间空格依旧保留

# if you use xclip as your clipboard, use this command:
#cat $SCR2.txt | xclip -selection clipboard

# if you use kde clipper as your clipboard, use this command:
getSCR2=$(cat $SCR2.txt)
qdbus org.kde.klipper /klipper setClipboardContents "$getSCR2"

exit
```

> 注意：中文识别情况下，有可能每个字之间都有空格，所以在脚本里添加了去除空格的代码。

添加运行权限
```
sudo chmod a+x tesseractOcr.sh
```

## 四、设置快捷键，一键调用shell脚本

打开`系统设置`，点击`键盘`--`快捷键`，右边顶部可看到`+`号，点击`+`号添加快捷键。

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/03/tesseractocr001.png)
    
命令：bash 这里换成你自己shell脚本`tesseractOcr.sh`所在的路径；例如，我这里的bash命令为：

```
bash /home/dh/opt/tesseractOcr/tesseractOcr.sh
```
添加自定义快捷键时，不要与你系统中的其他快捷键冲突，我这里设置的快捷键是“Alt+O”

这样就配置完成了。直接使用快捷键即可进入截屏模式，截取想要识别的文字区域，等待片刻后便可在指定目录生成src.png和src2.txt文件，同时，文字会自动复制到剪切板，可以直接粘贴使用。

**参考：**
* [《超简单教程——Linux下自制OCR文字识别》](https://blog.csdn.net/weixin_42301220/article/details/124059358)
* [《arch系manjaro安装OCRFeeder》](https://www.jianshu.com/p/2d0e7c41ccee)