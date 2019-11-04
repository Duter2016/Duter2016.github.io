---
layout:     post   				    # 使用的布局（不需要改）
title:      为WordPress富文本编辑器添加编辑器按钮 				# 标题 
subtitle:      wordpress博客优化2015-04-11                  #副标题
date:       2019-11-04 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-ioses.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - WordPress
---

在你使用的主体目录下找到functions.php文件，打开进行编辑，添加如下代码：

```
//增强编辑器开始
function add_editor_buttons($buttons) {
$buttons[] = 'code';
$buttons[] = 'hr';
$buttons[] = 'cleanup';
$buttons[] = 'backcolor';
$buttons[] = 'formmatselect';
$buttons[] = 'fontselect';
$buttons[] = 'fontsizeselect';
$buttons[] = 'styleselect';
$buttons[] = 'sub';
$buttons[] = 'sup';
$buttons[] = 'image';
$buttons[] = 'anchor';
$buttons[] = 'wp_page';
return $buttons;
}
add_filter("mce_buttons_3", "add_editor_buttons");
//增强编辑器结束
```

保存后，看看编辑器界面是不是又多了好多按钮！
