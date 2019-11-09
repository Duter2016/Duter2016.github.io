[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/home-assistant/home-assistant-iOS/blob/master/LICENSE)


博客的搭建教程修改自 [Hux](https://github.com/Huxpro/huxpro.github.io) 和[BY](https://github.com/qiubaiying/qiubaiying.github.io)
 
更为详细的教程戳这 [《利用 GitHub Pages 快速搭建个人博客》](http://www.jianshu.com/p/e68fba58f75c) 或 [wiki](https://github.com/qiubaiying/qiubaiying.github.io/wiki/%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B)

>
### [查看博客戳这里 👆](http://duter2016.github.io)

## 本仓库博客实现的附加功能（相对Fork的仓库）  

+ Gitalk评论功能略改（启用）
+ Valine评论功能（启用）
+ Intensedebate评论功能（未启用，可选）
+ 社交分享按钮（默认关闭，_config.yml中开启）
+ 网易云音乐功能
+ 网站访问点击量和访问人数功能
+ 网站运行时间功能
+ 添加“归档”分页
+ 优化“标签”分页，并添加标签浮动选择按钮
+ 添加“留言板”分页
+ 增加全站搜索功能（双击Ctrl，或点击右下角的蓝色圆圈启动）
+ 增加全局“返回顶部”按钮
+ 增加文章页面“编辑”、“查看源码”按钮
+ 添加首页下拉菜单式分页导航
+ 增加post页面“相关文章”模块
+ 添加“文章置顶”功能
+ 添加“书单”分页
+ 添加“说说”分页
+ 网站汉化

**目录**  

[TOC]


* [1.环境](#1环境)
* [2.开始](#2开始)
* [3.撰写博文](#3撰写博文)
* [4.侧边栏](#4侧边栏)
* [5.Mini About Me](#5mini-about-me)
* [6.Featured Tags](#6featured-tags)
* [7.Social-media Account](#7social-media-account)
* [8.Friends](#8friends)
* [9.Keynote Layout](#9keynote-layout)
* [10.Comment](#10comment)
   * [（1）Disqus](#1disqus)
   * [（2）Gitalk](#2gitalk)
   * [（3）使用intensedebate添加评论](#3使用intensedebate添加评论)
   * [（4）使用Valine添加评论](#4使用valine添加评论)
* [11.Analytics](#11analytics)
* [12.Customization](#12customization)
* [13.Header Image](#13header-image)
* [14.SEO Title](#14seo-title)
* [15.关于收到"Page Build Warning"的 Email](#15关于收到page-build-warning的-email)
* [16.添加文章访问量功能[不蒜子]：](#16添加文章访问量功能不蒜子)
* [17.添加网站运行时间：](#17添加网站运行时间)
* [18.文章置顶：](#18文章置顶)
* [19.书单和说说](#19书单和说说)
* [致谢](#致谢)
* [License](#license)


### 1.环境

如果你安装了 [jekyll](http://jekyllcn.com/)，那你只需要在命令行输入`jekyll serve` 或 `jekyll s`就能在本地浏览器中输入`http://127.0.0.1:4000/`预览主题，对主题的修改也能实时展示（需要强刷浏览器）。



### 2.开始

你可以通用修改 `_config.yml`文件来轻松的开始搭建自己的博客:

```
# Site settings
title: BY Blog                    # 你的博客网站标题
SEOTitle: 柏荧的博客 | BY Blog		# SEO 标题
description: "Hey"	   	   # 随便说点，描述一下

# SNS settings      
github_username: qiubaiying     # 你的github账号
jianshu_username: e71990ada2fd  # 你的简书ID。

# Build settings
# paginate: 10              # 一页你准备放几篇文章
```

Jekyll官方网站还有很多的参数可以调，比如设置文章的链接形式...网址在这里：[Jekyll - Official Site](http://jekyllrb.com/) 中文版的在这里：[Jekyll中文](http://jekyllcn.com/).

### 3.撰写博文

要发表的文章一般以 **Markdown** 的格式放在这里`_posts/`，你只要看看这篇模板里的文章你就立刻明白该如何设置。

yaml 头文件长这样:

```
---
layout:     post   				    # 使用的布局（不需要改）
title:      这是文章正标题 				# 标题 
subtitle:      这是副标题                  #副标题
date:       2019-10-01 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutbs.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id: 1359xxxxxx        # 网易云音乐单曲嵌入
music-idfull: 293xxxxxxx        # 网易云音乐歌单嵌入
tags:								#标签
    - Python
---
```

### 4.侧边栏

看右边:
![](https://raw.githubusercontent.com/qiubaiying/qiubaiying.github.io/master/img/readme-side.png)

设置是在 `_config.yml`文件里面的`Sidebar settings`那块。

```
# Sidebar settings
sidebar: true  #添加侧边栏
sidebar-about-description: "简单的描述一下你自己"
sidebar-avatar: /img/avatar-by.jpg     #你的大头贴，请使用绝对地址.注意：名字区分大小写！后缀名也是
```

侧边栏是响应式布局的，当屏幕尺寸小于992px的时候，侧边栏就会移动到底部。具体请见bootstrap栅格系统 <http://v3.bootcss.com/css/>


### 5.Mini About Me

Mini-About-Me 这个模块将在你的头像下面，展示你所有的社交账号。这个也是响应式布局，当屏幕变小时候，会将其移动到页面底部，只不过会稍微有点小变化，具体请看代码。

### 6.Featured Tags

看到这个网站 [Medium](http://medium.com) 的推荐标签非常的炫酷，所以我将他加了进来。
这个模块现在是独立的，可以呈现在所有页面，包括主页和发表的每一篇文章标题的头上。

```
# Featured Tags
featured-tags: true  
featured-condition-size: 1     # A tag will be featured if the size of it is more than this condition value
```

唯一需要注意的是`featured-condition-size`: 如果一个标签的 SIZE，也就是使用该标签的文章数大于上面设定的条件值，这个标签就会在首页上被推荐。
 
内部有一个条件模板 `{% if tag[1].size > {{site.featured-condition-size}} %}` 是用来做筛选过滤的.

### 7.Social-media Account

在下面输入的社交账号，没有的添加的不会显示在侧边框中。新加入了[简书](https:/www.jianshu.com)链接, <http://www.jianshu.com/u/e71990ada2fd>

	# SNS settings
	RSS: false
	jianshu_username: 	jianshu_id 
	zhihu_username:     username
	facebook_username:  username
	github_username:    username
	# weibo_username:   username
	
	

![](http://ww4.sinaimg.cn/large/006tKfTcgy1fgrgbgf77aj308i02v748.jpg)

### 8.Friends

好友链接部分。这会在全部页面显示。

设置是在 `_config.yml`文件里面的`Friends`那块，自己加吧。

```
# Friends
friends: [
    {
        title: "BY Blog",
        href: "https://qiubaiying.github.io/"
    },
    {
        title: "Apple",
        href: "https://apple.com/"
    }
]
```


### 9.Keynote Layout

HTML5幻灯片的排版：

![](https://camo.githubusercontent.com/f30347a118171820b46befdf77e7b7c53a5641a9/687474703a2f2f6875616e677875616e2e6d652f696d672f626c6f672d6b65796e6f74652e6a7067)

这部分是用于占用html格式的幻灯片的，一般用到的是 Reveal.js, Impress.js, Slides, Prezi 等等.我认为一个现代化的博客怎么能少了放html幻灯的功能呢~

其主要原理是添加一个 `iframe`，在里面加入外部链接。你可以直接写到头文件里面去，详情请见下面的yaml头文件的写法。

```
---
layout:     keynote
iframe:     "http://huangxuan.me/js-module-7day/"
---
```

iframe在不同的设备中，将会自动的调整大小。保留内边距是为了让手机用户可以向下滑动，以及添加更多的内容。


### 10.Comment

博客不仅支持 [Disqus](http://disqus.com)和Intensedebate 评论系统,还加入了 [Gitalk](https://gitalk.github.io/) 评论系统，[支持 Markdwon 语法](https://guides.github.com/features/mastering-markdown/)，cool~

#### （1）Disqus

优点：国际比较流行，界面也很大气、简洁，如果有人评论，还能实时通知，直接回复通知的邮件就行了；

缺点：评论必须要去注册一个disqus账号，分享一般只有Facebook和Twitter，另外在墙内加载速度略慢了一点。想要知道长啥样，可以看以前的版本点[这里](http://brucezhaor.github.io/about.html) 最下面就可以看到。

> Node：有很多人反映 Disqus 插件加载不出来，可能墙又架高了，有条件的话翻个墙就好了~

**使用：**

**首先**，你需要去注册一个Disqus帐号。**不要直接使用我的啊！**

**其次**，你只需要在下面的 yaml 头文件中设置一下就可以了。

```
# 评论系统
# Disqus（https://disqus.com/）
disqus_username: qiubaiying
```

#### （2）Gitalk

优点：界面干净简洁，利用 Github issue API 做的评论插件，使用 Github 帐号进行登录和评论，最喜欢的支持 Markdown 语法，对于程序员来说真是太 cool 了。

缺点：配置比较繁琐，每篇文章的评论都需要初始化。

**使用：**

参考我的这篇文章：[《为博客添加 Gitalk 评论插件》](http://qiubaiying.top/2017/12/19/%E4%B8%BA%E5%8D%9A%E5%AE%A2%E6%B7%BB%E5%8A%A0-Gitalk-%E8%AF%84%E8%AE%BA%E6%8F%92%E4%BB%B6/)

#### （3）使用intensedebate添加评论  
先去IntenseDebate注册一个账号。  

在Jekyll站点的_includes目录下创建intensedebate-comments.html文件。  
文件内容如下(**[]替换为{}**)。'xxxxxxxxxxxxx'是IntenseDebate注册完以后得到的脚本代码。

```
[% if page.comments != false %]
  <!-- 显示评论 -->
  <script>
  var idcomments_acct = 'xxxxxxxxxxxxx';
  var idcomments_post_id;
  var idcomments_post_url;
  </script>
  <span id="IDCommentsPostTitle" style="display:none"></span>
  <script type='text/javascript' src='https://www.intensedebate.com/js/genericCommentWrapperV2.js'></script>
  <!-- 显示评论计数 -->
  <script>
  var idcomments_acct = 'xxxxxxxxxxxxx';
  var idcomments_post_id;
  var idcomments_post_url;
  </script>
  <script type="text/javascript" src="https://www.intensedebate.com/js/genericLinkWrapperV2.js"></script>
[% endif %]
```

在站点配置文件_config.yml中添加评论配置参数，方便灵活的enable/disable评论功能。

```
  # intensedebate评论系统开关
intensedebate_comments: true
```

在post.html文件末尾后面添加代码引用intensedebate-comments.html来显示评论框(**[]替换为{}**)：

```
	       <!-- intensedebate 评论框 start -->
	       [% if site.intensedebate_comments %]
                      [% include intensedebate-comments.html %]
               [% endif %]
	       <!-- intensedebate 评论框 end -->
```
#### （4）使用Valine添加评论  
参阅我的博文[Jekyll添加Valine评论「邮件通知和评论列表头像」](https://duter2016.github.io/2019/09/18/Jekyll%E6%B7%BB%E5%8A%A0Valine%E8%AF%84%E8%AE%BA-%E9%82%AE%E4%BB%B6%E9%80%9A%E7%9F%A5%E5%92%8C%E8%AF%84%E8%AE%BA%E5%88%97%E8%A1%A8%E5%A4%B4%E5%83%8F/)。


### 11.Analytics

网站分析，现在支持百度统计和Google Analytics。需要去官方网站注册一下，然后将返回的code贴在下面：

```
# Baidu Analytics
ba_track_id: 4cc1f2d8f3067386cc5cdb626a202900

# Google Analytics
ga_track_id: 'UA-49627206-1'            # 你用Google账号去注册一个就会给你一个这样的id
ga_domain: huangxuan.me			# 默认的是 auto, 这里我是自定义了的域名，你如果没有自己的域名，需要改成auto。
```

### 12.Customization

如果你喜欢折腾，你可以去自定义这个模板的 Code。

**如果你可以理解 `_include/` 和 `_layouts/`文件夹下的代码（这里是整个界面布局的地方），你就可以使用 Jekyll 使用的模版引擎 [Liquid](https://github.com/Shopify/liquid/wiki)的语法直接修改/添加代码，来进行更有创意的自定义界面啦！**

### 13.Header Image

博客每页的标题底图是可以自己选的，看看几篇示例post你就知道如何设置了。
  
标题底图的选取完全是看个人的审美了。每一篇文章可以有不同的底图，你想放什么就放什么，最后宽度要够，大小不要太大，否则加载慢啊。

> 上传的图片最好先压缩，这里推荐 imageOptim 图片压缩软件，让你的博客起飞。

但是需要注意的是本模板的标题是**白色**的，所以背景色要设置为**灰色**或者**黑色**，总之深色系就对了。当然你还可以自定义修改字体颜色，总之，用github pages就是可以完全的个性定制自己的博客。

### 14.SEO Title

我的博客标题是 **“BY Blog”** 但是我想要在搜索的时候显示 **“柏荧的博客 | BY Blog”** ，这个就需要 SEO Title 来定义了。

其实这个 SEO Title 就是定义了<head><title>标题</title></head>这个里面的东西和多说分享的标题，你可以自行修改的。

### 15.关于收到"Page Build Warning"的 Email

由于jekyll升级到3.0.x,对原来的 pygments 代码高亮不再支持，现只支持一种-rouge，所以你需要在 `_config.yml`文件中修改`highlighter: rouge`.另外还需要在`_config.yml`文件中加上`gems: [jekyll-paginate]`.

同时,你需要更新你的本地 jekyll 环境.

使用`jekyll server`的同学需要这样：

1. `gem update jekyll` # 更新jekyll
2. `gem update github-pages` #更新依赖的包

使用`bundle exec jekyll server`的同学在更新 jekyll 后，需要输入`bundle update`来更新依赖的包.

> Note：
> 可以使用 `jekyll -s` 命令在本地实时配置博客，提高效率。详见 [Jekyll.com](http://jekyllcn.com/)

参考文档：[using jekyll with pages](https://help.github.com/articles/using-jekyll-with-pages/) & [Upgrading from 2.x to 3.x](http://jekyllrb.com/docs/upgrading/2-to-3/)

### 16.添加文章访问量功能[不蒜子]：
在_includes目录下的head.html中添加

`<script async src="//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>`

在_includes目录下的footer.html中添加如下代码，这样文章底部有了统计访问量功能，pv的方式，单个用户连续点击n篇文章，记录n次访问量：  

`<span id="busuanzi_container_site_pv">本站总访问量：<span id="busuanzi_value_site_pv"></span>次</span>`

在_layouts目录下的post.html中添加如下代码，这样每篇文章有了统计访问量功能，uv的方式，单个用户连续点击n篇文章，只记录1次访客数：  

`<span id="busuanzi_container_page_pv"> | 访问量：<span id="busuanzi_value_page_pv"></span> 次</span>`

### 17.添加网站运行时间：
在_includes目录下的head.html中添加

直接将以下代码加入_post文件夹的footer.html文件的合适位置，将代码：

```
<span id="htmer_time" style="color: red;"></span>
```

放在你认为合适的地方显示网站运行时间。  

然后，在footer.html文件的合适位置（我放在最后）添加如下代码：  

```
<!-- 计算网站运行时间 -->
<span style="font-size:12px;"><script language=JavaScript> 
 function secondToDate(second) {
     if (!second) {
        return 0;
     }

 var time = new Array(0, 0, 0, 0, 0);

 if (second >= 365 * 24 * 3600) {
     time[0] = parseInt(second / (365 * 24 * 3600));
     second %= 365 * 24 * 3600;
 }  

 if (second >= 24 * 3600) {
     time[1] = parseInt(second / (24 * 3600));
     second %= 24 * 3600;
 }

 if (second >= 3600) {
     time[2] = parseInt(second / 3600);
     second %= 3600;
 }

 if (second >= 60) {
     time[3] = parseInt(second / 60);
     second %= 60;
 }

 if (second > 0) {
     time[4] = second;
 }
    return time;
}
</script>

<!-- 动态显示网站运行时间 -->
<script type="text/javascript" language="javascript">
    function setTime() {
        var create_time = Math.round(new Date(Date.UTC(2018, 05, 05, 0, 0, 0)).getTime() / 1000);
        var timestamp = Math.round((new Date().getTime() + 8 * 60 * 60 * 1000) / 1000);
        currentTime = secondToDate((timestamp - create_time));
        currentTimeHtml = '本站已安全运行' + currentTime[0] + '年' + currentTime[1] + '天' + currentTime[2] + '时' + currentTime[3] + '分' + currentTime[4] + '秒';
        document.getElementById("htmer_time").innerHTML = currentTimeHtml;
    }
    setInterval(setTime, 1000);
</script></span>
```

### 18.文章置顶
在文章参数里面添加 `istop: true` 属性会让该博文置顶显示。但该文章在原始位置依旧会显示，这就意味址如果你置顶了第一页的文章，你会在第一页看到两篇文章。

如果想要修改博文置顶的逻辑可以在 index.html 文件中修改。比如，在index.html中的“普通文档流”中添加如下代码，就可以使该文章在原始位置不再显示（我已修改，如果你不想打乱原来的日期排序，你可以改回去）：
```
{% if post.istop %}
{% else %}
^^^^^^^^
{% endif %}
```
即修改后变为：

```
<!--普通文档流开始-->
{% for post in paginator.posts %}
{% if post.istop %}
{% else %}
<div class="post-preview">
    <a href="{{ post.url | prepend: site.baseurl }}" target="_blank">
        <h2 class="post-title">
            {{ post.title }}
        </h2>
        {% if post.subtitle %}
        <h3 class="post-subtitle">
            {{ post.subtitle }}
        </h3>
        {% endif %}
        <div class="post-content-preview">
            {{ post.content | strip_html | truncate:200 }}
        </div>
    </a>
    <p class="post-meta">
        作者: {% if post.author %}{{ post.author }}{% else %}{{ site.title }}{% endif %} | {{ post.date | date: "%Y-%m-%d" }} | {% for tag in post.tags %}<a href="{{ site.baseurl }}/tags/#{{ tag }}" title="{{ tag }}" target="_blank"> {{ tag }}</a>{% endfor %}
    </p>
</div>
<hr>
{% endif %}
{% endfor %}
```

### 19.书单和说说

使用说明详见《[_data目录Readme.md](https://github.com/Duter2016/Duter2016.github.io/tree/master/_data)》

## 致谢

1. 这个模板是从这里 [Hux](https://github.com/Huxpro/huxpro.github.io) 和[BY](https://github.com/qiubaiying/qiubaiying.github.io)fork 的, 感谢这几个作者。 
2. 感谢 Jekyll、Github Pages 和 Bootstrap!

## License

遵循 MIT 许可证。有关详细,请参阅 [LICENSE](https://github.com/qiubaiying/qiubaiying.github.io/blob/master/LICENSE)。

