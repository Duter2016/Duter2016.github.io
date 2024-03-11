---
layout:     post
title:      Linux下启用chromium系浏览器DRM数字版权保护功能
subtitle:   用Widevine组件恢复浏览器DRM数字版权保护功能
date:       2024-03-11
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - 浏览器
    - Linux
---


当你使用 chromium系浏览器（如ungoogled-chromium）访问流媒体网站，可能会发现一些版权内容无法播放，特别是观看一些从国外进口的影视版权资源时，非常容易遇到这个问题。比如使用 ungoogled-chromium 直接打开爱奇艺《[复仇者联盟4：终极之战](https://sspai.com/link?target=https%3A%2F%2Fwww.iqiyi.com%2Fv_19rr7q1fy0.html)》，播放器会报错：`DASH-A00000-702`

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/03/DRM001.png)

其背后原因也很简单：播放该资源需要浏览器支持 DRM 数字版权保护技术，而 Chrome 数字版权保护所需的 Widevine 组件并没有随 Chromium 项目一同开源。Widevine 是 Google 于 2010 年收购的一种数字版权保护技术，作为组件内置于 Chrome 中。其本身用于加密/解密版权内容，未包含在 Chromium 开源项目内也情有可原。

解决思路也很简单，找到最新版Widevine组件、或者最新版本的Chrome安装包，把Widevine相关文件提取出来，「搬」到指定的文件路径中，重启浏览器即可恢复浏览器 DRM 数字版权保护功能。

具体安装Widevine组件步骤如下指引：

《[How to install the Widevine CDM plugin?](https://chromium.woolyss.com/#widevine)》

上述文章指引中，其中第四步是以windows为例，介绍的Widevine组件的位置。在linux系统下Widevine组件的位置需做如下修改：

① 在目录`～/.config/chromium/WidevineCdm/`下新建文件`latest-component-updated-widevine-cdm`，文件内容为：

```
{"Path":"/opt/chromium/WidevineCdm"}
```

② 在根目录新建文件夹`/opt/chromium/WidevineCdm/`，然后将指引《[How to install the Widevine CDM plugin?](https://chromium.woolyss.com/#widevine)》中下载解压出来的文件安装如下目录结构放置：

```
WidevineCdm
  ├── LICENSE.txt
  ├── manifest.json (Note: this file contains the Widevine version or even the file paths ^^)
  │
  ├── _platform_specific
         ├── linux_x64 (Note: if it is for 64-bit linux, obviously!)
              ├── libwidevinecdm.so
```

即，文件`LICENSE.txt`和`manifest.json`放在`/opt/chromium/WidevineCdm/`目录下，文件`libwidevinecdm.so`放在`/opt/chromium/WidevineCdm/_platform_specific/linux_x64/`目录下。

重启浏览器，再次打开刚才报错的电影，此时已经可以正常播放。

**PS.**

（1）使用 `chrome://components/` 查看组件是否启用(加载)

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/03/DRM002.png)

（2）使用`chrome://media-internals/` 查看widevine 组建加载信息

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/03/DRM003.png)

（3）设置中，DRM数字版权保护的选项见`chrome://settings/content/protectedContent`

![](https://cdn.jsdelivr.net/gh/Duter2016/GitNote-images/Images/2024/03/DRM004.png)

**参考：**
* [《Chrome，但是 without Google》](https://sspai.com/post/80189)
* [《How to install the Widevine CDM plugin?》](https://chromium.woolyss.com/#widevine)