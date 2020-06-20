---
layout:     post   				    # 使用的布局（不需要改）
title:      使用PicGo+GitHub图床 				# 标题 
subtitle:   方便上传图片和复制外链地址                     #副标题
date:       2020-06-20 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
apserver: netease    # 音乐平台netease/tencent/kugou/xiami/baidu
aptype: playlist    # 音乐类型song/playlist/album/search/artist
apsongid:         # 音乐song/playlist/album id
tags:								#标签
    - Git
    - Blog
    - 网页
---




## [PicGo介绍](https://github.com/Molunerfinn/PicGo)


这是一款图片上传的工具，目前支持`微博图床`，`七牛图床`，`腾讯云`，`又拍云`，`GitHub`等图床，未来将支持更多图床。

![](https://user-gold-cdn.xitu.io/2019/1/28/16893b43911d7b83?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)_Pic Go支持的图床_

在众多的图床中，我选择的GitHub图床，其它类型的图床如果你们有兴趣的话可以试一下。

## 创建自己的GitHub图床


1. 创建GitHub图床之前，需要注册/登陆GitHub账号

> 申请GitHub账号很简单，我就不演示了

2. 创建Repository

![](https://user-gold-cdn.xitu.io/2019/1/28/16893b439125b024?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _点击"New repository"按钮_ ![](https://user-gold-cdn.xitu.io/2019/1/28/16893b43d211747d?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _最后1234步骤执行_

> *   我已经建立过一个同名的repository的，所以第一步会显示红色
> *   第三步，为repository初始化一个README.md文件可以根据需求选择，非必选

3.生成一个Token用于操作GitHub repository

![](https://user-gold-cdn.xitu.io/2019/1/28/16893b43f3c6ccb3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _回到主页，点击"Settings"按钮_ ![](https://user-gold-cdn.xitu.io/2019/1/28/16893b43f97bc563?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) 
_进入页面后，点击"Developer settings"按钮_ 

![](https://user-gold-cdn.xitu.io/2019/1/28/16893b43faa50788?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _点击"Personal access tokens"按钮_

 ![](https://user-gold-cdn.xitu.io/2019/1/28/16893b4403817332?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _创建新的Token_ 

![](https://user-gold-cdn.xitu.io/2019/1/28/16893b44115f2ee3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) _填写描述，选择"repo",然后点击"Generate token"按钮_

> 注：创建成功后，会生成一串token，这串token之后不会再显示，所以第一次看到的时候，就要好好保存

## 配置PicGo

### 1. 下载运行PicGo

点击[下载](https://github.com/Molunerfinn/PicGo)

### 2. 配置图床

![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/07/picgo01.png)
_如图配置_

> *   设定仓库名的时候，是按照“账户名/仓库名的格式填写”
> *   分支名统一填写“master”
> *   将之前的Token黏贴在这里
> *   存储的路径可以按照我这样子写，就会在repository下创建一个“Images/2020/07/”文件夹(我是按照月份分类文件夹的，注意别漏了最后的斜杠)
> *   自定义域名的作用是，在上传图片后成功后，PicGo会将“自定义域名+上传的图片名”生成的访问链接，放到剪切板上`https://raw.githubusercontent.com/账户名/仓库名/master`，例如我的是`https://raw.githubusercontent.com/Duter2016/GitNote-images/master`，自定义域名需要按照这样去填写

### 3.快捷键及相关配置

![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/07/picgo02.png)

_可以按照这样配置_

> 注：可以将快捷键设置为`ctrl+shift+c`

## 总结

将上面的步骤都设置好之后，就可以让自己的Markdown文档飞起来了，每次截图之后，都可以按一下`ctrl+shift+c`，这样就会将剪切板上面的截图转化为在线网络图片链接！
