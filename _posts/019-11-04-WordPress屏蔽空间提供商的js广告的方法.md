---
layout:     post   				    # 使用的布局（不需要改）
title:      WordPress屏蔽空间提供商的js广告的方法 				# 标题 
subtitle:      wordpress博客优化2015-04-09                  #副标题
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

使用免费的空间的时候，难免在网站中会出现空间提供商的广告，但是去掉这些广告却是一个令人烦恼的问题。在这里提供一个简单的适合WordPress的方法：

1.首先，定位到以下目录下的footer.php文件：

“`根目录/空间上定义的文件夹/wp-content/themes/你使用的主体/footer.php`”；

2.在该footer.php文件的末端找到以下语句

```
</script>
<?php wp_footer(); ?>
</body>
</html>
```

然后在</body>前面添加

```
<?php exit; ?>
```

即，修改后为

```
</script>
<?php wp_footer(); ?>
<?php exit; ?>
</body>
</html>
```

3.注意，您如果使用了页面压缩类的插件，如Autoptimize，就要注意不要对JS进行压缩，否则将不能有效去除空间服务商添加的JS广告脚本。

 

**PS**.

去掉wordpress后台的类似广告的方法是修改以下路径的footer.php文件就可以：

`\wordpress\wp-includes\theme-compat\footer.php`
