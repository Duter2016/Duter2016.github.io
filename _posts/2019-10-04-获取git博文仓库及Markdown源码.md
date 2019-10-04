---
layout:     post   				    # 使用的布局（不需要改）
title:      获取git博文仓库及Markdown源码 				# 标题 
subtitle:   用于编辑及发布文章     #副标题
date:       2019-10-04 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-rwd.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
music-id:        # 网易云音乐单曲嵌入
music-idfull:       # 网易云音乐歌单嵌入
tags:								#标签
    - Blog
---

注：一定要先在根目录的config.yml中把参数`github_username`设置好。  

### 1、博文源码地址：
如下：

```
{% raw %}
https://raw.githubusercontent.com/{{ site.github_username }}/{{ site.github_username }}.github.io/master/{{ page.path }}
{% endraw %}
```
用途：制作查看博文源码按钮

```
{% raw %}
<a href="//raw.githubusercontent.com/{{ site.github_username }}/{{ site.github_username }}.github.io/master/{{ page.path }}" target="_blank" title="查看本文Markdown源码" >「本文源码」</a>
{% endraw %}
```
### 2、博文目录地址：
如下：

```
{% raw %}
https://github.com/{{ site.github_username }}/{{ site.github_username }}.github.io/tree/master/_posts
{% endraw %}
```
用途：制作发布文章按钮

```
{% raw %}
<a href="//github.com/{{ site.github_username }}/{{ site.github_username }}.github.io/tree/master/_posts" target="_blank" title="发布新文章" >👉「发布文章」</a>
{% endraw %}
```

### 3、博文编辑地址：
如下：

```
{% raw %}
https://github.com/{{ site.github_username }}/{{ site.github_username }}.github.io/blob/master/{{ page.path }}
{% endraw %}
```
用途：制作重新编辑原文章按钮

```
{% raw %}
<a href="//github.com/{{ site.github_username }}/{{ site.github_username }}.github.io/blob/master/{{ page.path }}" target="_blank" title="编辑本文" >编辑</a>
{% endraw %}
```
