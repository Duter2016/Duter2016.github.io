---
layout:     post
title:      Linux摄像头监控软件motion的安装与配置
subtitle:   基于Linuxmint 20.2 的安装及配置
date:       2022-02-27
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---


> motion可以用来探测运动，并将探测到的运动录下视频，并邮件提醒；在未探测到运动时，实现在摄像头静止情况下，对视场的监控。

> 本篇文章基于Linuxmint 20.2 mate

## 一、安装motion

在linuxmint下安装Motion相当简单，直接在终端下运行：

``` 
sudo apt-get install motion
```

## 二 、配置motion

装好后，修改`/etc/motion/`里的相关文件名，得到这个文件`/etc/motion/motion.conf`。motion.conf就是motion程序与操作者的接口文件，通过修改motion.conf里的配置，来控制motion的运行。当在终端里运行`motion`时，会先在终端所示当前目录下寻找motion.conf，没有找到时，去寻找`/etc/motion/motion.conf`。

运行前，先修改这个文件`/etc/motion/motion.conf`，我的motion.conf配置如下：

```
# Rename this distribution example file to motion.conf
#
# This config file was generated by motion 4.2.2
# Documentation:  /usr/share/doc/motion/motion_guide.html
#
# This file contains only the basic configuration options to get a
# system working.  There are many more options available.  Please
# consult the documentation for the complete list of all options.
#

############################################################
# System control configuration parameters
############################################################

# Start in daemon (background) mode and release terminal.
# 关掉deamon模式。最好这项还是选off，否则运行motion后，就会直接在后台运行，需要用top命令查看出motion的进程号(pid)，然后再手动kill掉这个进程。
daemon off

# Start in Setup-Mode, daemon disabled.
setup_mode off

# File to store the process ID.
; pid_file value

# File to write logs messages into.  If not defined stderr and syslog is used.
; log_file value

# Level of log messages [1..9] (EMG, ALR, CRT, ERR, WRN, NTC, INF, DBG, ALL).
log_level 6

# Target directory for pictures, snapshots and movies
# 当探测到运动时，图片和视频的保存路径，默认时为/var/lib/motion/snapshots。
target_dir /home/用户名/视频/motion/snapshots

# Video device (e.g. /dev/video0) to be used for capturing.
# 设置加载USB摄像头的设备，一般都是这个video0，当使用network webcam时，需要设置netcam_url，此时，videodevice选项自动失效。
videodevice /dev/video0

# Parameters to control video device.  See motion_guide.html
; vid_control_params value

# The full URL of the network camera stream.
; netcam_url value

# Name of mmal camera (e.g. vc.ril.camera for pi camera).
; mmalcam_name value

# Camera control parameters (see raspivid/raspistill tool documentation)
; mmalcam_control_params value

############################################################
# Image Processing configuration parameters
############################################################

# Image width in pixels.
width 320

# Image height in pixels.
height 240

# Maximum number of frames to be captured per second.
framerate 15

# Text to be overlayed in the lower left corner of images
text_left CAMERA1

# Text to be overlayed in the lower right corner of images.
text_right %Y-%m-%d\n%T-%q

############################################################
# Motion detection configuration parameters
############################################################

# 设置是否使用motion detection阈值自动调节。当设置为on时，下一个设置threshold 4500自动失效。设置off时，可以由threshold指定当探测到多少像素变化时，判断为图像中有运动。
threshold_tune off

# Always save pictures and movies even if there was no motion.
emulate_motion off

# Threshold for number of changed pixels that triggers motion.
threshold 3000

# Noise threshold for the motion detection.
; noise_level 64

# Despeckle the image using (E/e)rode or (D/d)ilate or (l)abel.
despeckle_filter EedDl

# Number of images that must contain motion to trigger an event.
minimum_motion_frames 1

# Gap in seconds of no motion detected that triggers the end of an event.
# 在探测到运动后，多长时间没有运动的话就触发运动结束指令on_event_end。
event_gap 10

# The number of pre-captured (buffered) pictures from before motion.
pre_capture 3

# Number of frames to capture after motion is no longer detected.
post_capture 0

############################################################
# Script execution configuration parameters
############################################################

# Command to be executed when an event starts.
# 当探测到运动时，执行所设定目录里的文件，该文件可以是一个程序，可以是一段脚本，只要是能执行的就可以，on_motion_detected和on_motion_end都是shell脚本。。
on_event_start /etc/motion/on_motion_detected

# Command to be executed when an event ends.
# 当on_event_start开始后，即检测到运动后，若有连续10秒不再能检测到运动时，执行该选项设定的文件。10秒参数是由以下event_gap 10语句设置而来。
on_event_end /etc/motion/on_motion_end

# Command to be executed when a movie file is closed.
; on_movie_end value

############################################################
# Picture output configuration parameters
############################################################

# Output pictures when motion is detected
picture_output off

# File name(without extension) for pictures relative to target directory
picture_filename %Y%m%d%H%M%S-%q

############################################################
# Snapshot output configuration parameters
############################################################

# This parameter specifies the number of seconds between each snapshot 此参数指定每个快照之间的秒数，默认值: 0(禁用)。
# snapshot_interval 30

# 快照文件名
# snapshot_filename %t-%v-%Y%m%d%H%M%S

############################################################
# Movie output configuration parameters
############################################################

# Create movies of motion events.
movie_output on

# Maximum length of movie in seconds.
movie_max_time 60

# The encoding quality of the movie. (0=use bitrate. 1=worst quality, 100=best)
movie_quality 45

# Container/Codec to used for the movie. See motion_guide.html
movie_codec mkv

# File name(without extension) for movies relative to target directory
movie_filename %t-%v-%Y%m%d%H%M%S

############################################################
# Webcontrol configuration parameters
############################################################

# Port number used for the webcontrol.
webcontrol_port 8080

# Restrict webcontrol connections to the localhost.
webcontrol_localhost on

# Type of configuration options to allow via the webcontrol.
webcontrol_parms 0

############################################################
# Live stream configuration parameters
############################################################

# The port number for the live stream.
stream_port 8081

# Restrict stream connections to the localhost.
stream_localhost on

##############################################################
# Camera config files - One for each camera.
##############################################################
; camera /etc/motion/camera1.conf
; camera /etc/motion/camera2.conf
; camera /etc/motion/camera3.conf
; camera /etc/motion/camera4.conf

##############################################################
# Directory to read '.conf' files for cameras.
##############################################################
; camera_dir /etc/motion/conf.d

```

## 三、设置motion邮件提醒

motion配置里，参数`on_event_detected`、`on_event_end`涉及的两个shell脚本on_motion_detected和on_motion_end都是用来设置motion邮件提醒的。

on_motion_detected脚本的作用是，记录下探测到运动时的时间，即拍摄的监控视频文件的文件名的一部分。把这个时间存到`/home/用户名/视频/motion/videotime`文件中。on_motion_detected文件如下：

```
#!/bin/bash

echo "111111111111111on_motion_detected1111111111111111"

#DATE=$(%t-%v-%Y%m%d%H%M%S)

DATE=$(date +"%Y%m%d%H%M%S")

#DATE=$(date -d "-1 sec" +%Y%m%d%H%M%S)

ALARM_TIME="/home/用户名/视频/motion/videotime"

echo "$DATE" > $ALARM_TIME
```

而on_motion_end就是用来发送邮件的。它会在检测到的运动结束后，将拍下来的运动的mkv视频发送到指定邮箱里。mkv视频的文件名为一个序号+检测到运动的时间+.mkv，而检测到运动的时间，根据on_motion_detected脚本，存在`/home/用户名/视频/motion/videotime`里，理论上说只要从文件里读出时间，然后补全文件名(该序号由*号替代)，便能发出邮件。

但是，由于程序运动效率原因，有时会出现，记录的时间同开始录mkv的时间差1秒的情况，虽然只有一秒，但是足以导致找不到mkv文件，无法正确发出监控视频。由于我们设置了gap为10，即10秒内最多只有一个视频。所以，解决这个问题的办法可以是，去寻找videotime中所记录时间及其上一秒，连续两秒的视频，找到哪个发哪个。当然，结果永远是只会找到一个。

on_motion_end这个shell脚本文件如下（**注意：Arch Linux下把s-nail修改为mailx。**）：

```
#!/bin/bash

echo "111111111111111on_motion_end1111111111111111"

DIRC="/home/用户名/视频/motion/snapshots/"

VIDEOTIME="/home/用户名/视频/motion/videotime"

TIME=$(cat $VIDEOTIME)

ALARM_EMAIL="/home/用户名/视频/motion/myalarm.txt"

echo "Subject: Motion detected - $TIME - $DIRC" > $ALARM_EMAIL

echo "">> $ALARM_EMAIL

echo "Motion detected - check $TIME.mkv">>$ALARM_EMAIL

MAILBODY=$(cat $ALARM_EMAIL)

#first trying of sending the mkv video

echo $MAILBODY | s-nail -s $TIME -a $DIRC*$TIME.mkv xxxxx@foxmail.com

#second trying of sending the mkv video

TIME=$(expr $TIME - 1)

echo $MAILBODY | s-nail -s $TIME -a $DIRC*$TIME.mkv xxxxx@foxmail.com
```

由于我使用的s-nail进行系统中邮件的命令行发送，所以我上述代码中使用的

```
echo $MAILBODY | s-nail -s $TIME -a $DIRC*$TIME.mkv xxxxx@foxmail.com
```

**注意：Arch Linux下把命令中s-nail修改为mailx。**

你如果使用的其他邮件发送软件，改为你相应的命令即可。如果你也想用s-nail，可以参照我的另一篇文章进行配置：
[《linuxmint配置snail命令行发送邮件》](https://duter2016.github.io/2021/12/24/linuxmint%E9%85%8D%E7%BD%AEsnail%E5%91%BD%E4%BB%A4%E8%A1%8C%E5%8F%91%E9%80%81%E9%82%AE%E4%BB%B6/)

**重要一步：**

一定要赋予`当前linux普通用户`（不是root用户和组）两个文件`/etc/motion/on_motion_detected`和`/etc/motion/on_motion_end`的可执行权限，否则会导致只能录像，但无法发出邮件的bug（会提示类似如下错误: `line 1: /etc/motion/on_motion_end: Permission denied`
）！

这样就安装并配置好了！

### 参考

* [《linux usb摄像头 监控软件,Linux下的motion detection（最简单的办公室监控系统）》](https://blog.csdn.net/weixin_39975900/article/details/116811883)

