---
layout:     post   				    # 使用的布局（不需要改）
title:      Jekyll添加Valine评论「邮件通知和评论列表头像」				# 标题 
subtitle:   Valine评论系统 #副标题
date:       2019-09-18 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutzl.jpg 	#这篇文章标题背景图片
catalog: true 						# 是否归档
music-id:       # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - Blog
---

```
已适配v1.4.0+评论系统
```

# Jekyll: 添加Valine评论(邮件通知、评论列表头像)  

## 感谢：
+ [Francs's blog](https://postgres.fun/20190107095300.html)的文章：  
[《Hexo: 添加Valine评论(邮件通知、评论列表头像)》](https://postgres.fun/20190107095300.html)  

+ [Deserts](https://deserts.io/valine-admin-document/)的文章：  
[《Valine Admin 配置手册》](https://deserts.io/valine-admin-document/)  

本文根据以上两位博主的文章修改，绝大部分内容为以上两位博主的功劳！十分感谢！修改后，Valine评论系统可以完美使用于Jekyll。

## 1、关于 Valine 模块  

之所以选择 Valine 模块，一方面因为 Valine 评论模块延续了Jekyll和Hexo模板简洁的风格，两者匹配得可谓天衣无缝，另一方面国内可选的评论模块有些已经不再支持，有些模块的UI不太喜欢。  

[Valine](https://valine.js.org/) 诞生于2017年8月7日，是一款基于 Leancloud 的快速、简洁且高效的无后端评论系统，支持但不限于静态博客。

具有以下特性：

*   快速
*   安全
*   Emoji
*   无后端实现
*   MarkDown 全语法支持
*   轻量易用(~15kb gzipped)
*   文章阅读量统计 v1.2.0+

## 2、Valine 部署  

Valine 是基于 [leancloud国际版](https://leancloud.app/)的评论模块，评论数据都存储在 Leancloud 平台，因此需要先在 [leancloud](https://leancloud.app/) 申请帐号。（国内版无域名的，将停止服务）。

### (1)申请 Leancloud 帐号
--------------------------------------

申请 Leancloud 步骤比较简单，首先进行 Leancloud 控制台创建应用(个人使用开发版)，之后获取应用的 App ID 和 App Key，后面配置博客的主题配置文件会用到。

### （2）配置安全域名
--------------------

登录leancloud控制台，选择 设置 -> 安全中心 -> Web 安全域名，这里设置成博客的域名地址和本地地址即可，如图:

[![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine001.png)

## 3、配置Jekyll主题配置文件


修改博客主题配置文件 `_config.yml`，方便灵活的enable/disable评论功能。配置 Valine 的 enable、appid、appkey 等参数，添加代码如下:  

```
# Valine评论系统开关
# Valine.
# You can get your appid and appkey from https://leancloud.app
# more info please open https://valine.js.org
valine:
  enable: true
  appid:  xxxxxxxx # your leancloud app id
  appkey: xxxxxxxx # your leancloud app key
  notify: true # mail notifier , https://github.com/xCss/Valine/wiki，v1.4.0+ 已废弃
  verify: true # Verification code，v1.4.0+ 已废弃
  placeholder: 非Github帐号登录用户，在此处留言 # comment box placeholder
  avatar:   # gravatar style
  guest_info: 昵称,邮件,网址 # custom comment header
  pageSize: 10 # pagination size
  # path: window.location.pathname #  v1.4.0+不要使用参数“app_key: '{{ site.valine.appkey }}',”
  recordIP: true # 是否记录评论者IP
  enableQQ: true # 是否启用昵称框自动获取QQ昵称和QQ头像, 默认关闭
  avatar_cdn: https://sdn.geekzu.org/avatar/    # gravatar头像镜像
  serverURLs: https://xxxxxxxx.api.lncldglobal.com # 把前8位字符xxxxxxxx替换成你自己AppID的前8位字符，leancloud国际版添加该参数，国内版无需
```

以上的 appid和appkey为本文开始在Leancloud创建应用的 App ID 和 App Key。  

在Jekyll站点的_includes目录下创建valine_comments.html文件。文件内容如下([]替换为{})：    

```
<br>
<h4 align="left">「游客及非Github用户留言」：</h4>    
<div id="comments"></div>
    <!--Leancloud 操作库:-->
    <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
    <!--Valine 的核心代码库:-->
    <script src='//lib.baomitu.com/valine/latest/Valine.min.js'></script>
    <script>
         new Valine([
            av: AV,
            el: '#comments',
            app_id: '[[ site.valine.appid ]]',
            app_key: '[[ site.valine.appkey ]]',
            placeholder: '[[ site.valine.placeholder ]]',
            notify: '[[ site.valine.notify ]]',
            verify: '[[ site.valine.verify ]]',
	    recordIP: '{{ site.valine.recordIP }}',
            enableQQ: '{{ site.valine.enableQQ }}',
            avatar: '{{ site.valine.avatar }}',
            avatar_cdn: '{{ site.valine.avatar_cdn }}',
            serverURLs: '{{ site.valine.serverURLs }}',
        ])
    </script>
```

在post.html文件末尾后面（或你认为合适的位置）添加代码引用valine_comments.html来显示评论框([]替换为{})：  

```
	       <!-- Valine 评论框 start -->
	       [% if site.valine.enable %]
                      [% include valine_comments.html %]
           [% endif %]
	       <!-- Valine 评论框 end -->
```

**国际版用户注意** valine1.4.16版本开始，serverURLs参数参考：[国际版域名问题导致评论无法显示和评论](https://github.com/xCss/Valine/issues/340)。
自定义服务器的URL需要到LeanCloud后台查看。打开后台之后进入`设置` -`应用凭证` ，找到`域名白名单Domain whitelist`，里面的Request domain里面的那个xxxxxxxx.api.lncldglobal.com就是你需要指定的服务器URL。其中xxxxxxxx就是各位的AppID的前8位字符。

## 4、评论模块验证

之后访问博客，可以看到如下评论模块：

[![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine002.png)

并且可以留言评论了，以上就是 Valine 模块的基本部署过程。

## 5、开启 Valine 评论邮件通知  

以上使用 Valine 模块实现了最基本的评论功能，但功能还需要完善，例如评论邮件通知、评论管理等功能，正好 [Valine Admin](https://github.com/DesertsP/Valine-Admin) 可以满足需求，Valine Admin 是Valine评论模块的扩展和增强。

这块内容主要参考 [valine-admin-document](https://deserts.io/valine-admin-document/)。  


> 近期更改了Github用户名请留意，仓库链接更新为https://github.com/DesertsP/Valine-Admin.git


### （1）云引擎"一键"部署

1.在[Leancloud](https://leancloud.cn/dashboard/#/apps)云引擎设置界面，填写代码库并保存：[https://github.com/DesertsP/Valine-Admin.git](https://github.com/DesertsP/Valine-Admin.git)  

![设置仓库](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine003.png)

2.在设置页面，设置环境变量以及 Web 二级域名。

![环境变量](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine004.png)

变量|示例|说明
-|-|-
SITE\_NAME|Deserts|[必填]博客名称
SITE\_URL|[https://panjunwen.com](https://panjunwen.com)|[必填]首页地址
SMTP\_SERVICE|QQ|[新版支持]邮件服务提供商，支持 QQ、163、126、Gmail 以及 [更多](https://nodemailer.com/smtp/well-known/#supported-services)
SMTP_USER|xxxxxx@qq.com|[必填]SMTP登录用户
SMTP\_PASS|ccxxxxxxxxch|[必填]SMTP登录密码（QQ邮箱需要获取独立密码）
SENDER\_NAME|Deserts|[必填]发件人
SENDER\_EMAIL|xxxxxx@qq.com|[必填]发件邮箱
ADMIN\_URL|https://xxx.leanapp.cn/|[建议]Web主机二级域名，用于自动唤醒
BLOGGER\_EMAIL|xxxxx@gmail.com|[可选]博主通知收件地址，默认使用SENDER\_EMAIL
AKISMET\_KEY|xxxxxxxxxxxx|[可选]Akismet Key 用于垃圾评论检测，设为MANUAL\_REVIEW开启人工审核，留空不使用反垃圾

**以上必填参数请务必正确设置。**  

二级域名用于评论后台管理，如[https://deserts.leanapp.us](https://deserts.leanapp.us) 。

![二级域名](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine005.png)

3.切换到部署标签页，分支使用master，点击部署即可

![一键部署](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine006.png)

第一次部署需要花点时间。

![部署过程](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine007.png)

4.评论管理。访问设置的二级域名`https://二级域名.leanapp.us/sign-up`，注册管理员登录信息，如：[https://deserts.leanapp.us/sign-up](https://deserts.leanapp.us/sign-up)  
    ![管理员注册](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine008.png)


> 注：使用原版Valine如果遇到注册页面不显示直接跳转至登录页的情况，请手动删除\_User表中的全部数据。  

此后，可以通过`https://二级域名.leanapp.us/`管理评论。

5.定时任务设置  

目前实现了两种云函数定时任务：(1)自动唤醒，定时访问Web APP二级域名防止云引擎休眠；(2)每天定时检查24小时内漏发的邮件通知。  

进入云引擎-定时任务中，创建定时器，创建两个定时任务。  

选择self-wake云函数，Cron表达式为`0 0/30 7-23 * * ?`，表示每天早6点到晚23点每隔30分钟访问云引擎，`ADMIN_URL`环境变量务必设置正确：

![唤醒云引擎](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine009.png)

选择resend-mails云函数，Cron表达式为`0 0 8 * * ?`，表示每天早8点检查过去24小时内漏发的通知邮件并补发：

![通知检查](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine010.png)

**添加定时器后记得点击启动方可生效。**  

**目前Leancloud已经开启了定时任务的流控，定时任务存在每天第一次无法激活的问题**，好在已经有大神提供了解决方案，又可以愉快的玩耍了，接下来按照[《解决LeanCLoud定时唤醒失败的流控问题》](https://duter2016.github.io/2020/06/09/%E8%A7%A3%E5%86%B3LeanCLoud%E5%AE%9A%E6%97%B6%E5%94%A4%E9%86%92%E5%A4%B1%E8%B4%A5%E7%9A%84%E6%B5%81%E6%8E%A7%E9%97%AE%E9%A2%98/)
设置一下就OK了！
**至此，Valine Admin 已经可以正常工作，更多以下是可选的进阶配置。**  

### (2)邮件通知模板

邮件通知模板在云引擎环境变量中设定，可自定义通知邮件标题及内容模板。  

环境变量|示例|说明
-|-|-
MAIL\_SUBJECT|`${PARENT\_NICK}，您在${SITE\_NAME}上的评论收到了回复`|[可选]@通知邮件主题（标题）模板
MAIL\_TEMPLATE|见下文|[可选]@通知邮件内容模板
MAIL\_SUBJECT\_ADMIN|`${SITE\_NAME}上有新评论了`|[可选]博主邮件通知主题模板
MAIL\_TEMPLATE\_ADMIN|见下文|[可选]博主邮件通知内容模板

邮件通知包含两种，分别是被@通知和博主通知，这两种模板都可以完全自定义。默认使用经典的蓝色风格模板（样式来源未知）。  

默认被@通知邮件内容模板如下：

```
<div style="border-top:2px solid #12ADDB;box-shadow:0 1px 3px #AAAAAA;line-height:180%;padding:0 15px 12px;margin:50px auto;font-size:12px;"><h2 style="border-bottom:1px solid #DDD;font-size:14px;font-weight:normal;padding:13px 0 10px 8px;">您在<a style="text-decoration:none;color: #12ADDB;" href="${SITE_URL}" target="_blank">            ${SITE_NAME}</a>上的评论有了新的回复</h2> ${PARENT_NICK} 同学，您曾发表评论：<div style="padding:0 12px 0 12px;margin-top:18px"><div style="background-color: #f5f5f5;padding: 10px 15px;margin:18px 0;word-wrap:break-word;">            ${PARENT_COMMENT}</div><p><strong>${NICK}</strong>回复说：</p><div style="background-color: #f5f5f5;padding: 10px 15px;margin:18px 0;word-wrap:break-word;"> ${COMMENT}</div><p>您可以点击<a style="text-decoration:none; color:#12addb" href="${POST_URL}" target="_blank">查看回复的完整內容</a>，欢迎再次光临<a style="text-decoration:none; color:#12addb" href="${SITE_URL}" target="_blank">${SITE_NAME}</a>。<br></p></div></div>
```

效果如下图：

![mail-blue-template](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine011.png)

@通知模板中的可用变量如下（注，这是邮件模板变量，是指嵌入到HTML邮件模板中的变量，请勿与云引擎环境变量混淆）：

模板变量|说明
-|-
SITE\_NAME|博客名称
SITE\_URL|博客首页地址
POST\_URL|文章地址（完整路径）
PARENT\_NICK|收件人昵称（被@者，父级评论人）
PARENT\_COMMENT|父级评论内容
NICK|新评论者昵称
COMMENT|新评论内容

默认博主通知邮件内容模板如下：

```
<div style="border-top:2px solid #12ADDB;box-shadow:0 1px 3px #AAAAAA;line-height:180%;padding:0 15px 12px;margin:50px auto;font-size:12px;"><h2 style="border-bottom:1px solid #DDD;font-size:14px;font-weight:normal;padding:13px 0 10px 8px;">您在<a style="text-decoration:none;color: #12ADDB;" href="${SITE_URL}" target="_blank">${SITE_NAME}</a>上的文章有了新的评论</h2><p><strong>${NICK}</strong>回复说：</p><div style="background-color: #f5f5f5;padding: 10px 15px;margin:18px 0;word-wrap:break-word;"> ${COMMENT}</div><p>您可以点击<a style="text-decoration:none; color:#12addb" href="${POST_URL}" target="_blank">查看回复的完整內容</a><br></p></div></div>
```

博主通知邮件模板中的可用变量与@通知中的基本一致，**`PARENT_NICK` 和 `PARENT_COMMENT` 变量不再可用。**

这里还提供一个彩虹风格的@通知邮件模板代码：

```
<div style="border-radius: 10px 10px 10px 10px;font-size:13px;    color: #555555;width: 666px;font-family:'Century Gothic','Trebuchet MS','Hiragino Sans GB',微软雅黑,'Microsoft Yahei',Tahoma,Helvetica,Arial,'SimSun',sans-serif;margin:50px auto;border:1px solid #eee;max-width:100%;background: #ffffff repeating-linear-gradient(-45deg,#fff,#fff 1.125rem,transparent 1.125rem,transparent 2.25rem);box-shadow: 0 1px 5px rgba(0, 0, 0, 0.15);"><div style="width:100%;background:#49BDAD;color:#ffffff;border-radius: 10px 10px 0 0;background-image: -moz-linear-gradient(0deg, rgb(67, 198, 184), rgb(255, 209, 244));background-image: -webkit-linear-gradient(0deg, rgb(67, 198, 184), rgb(255, 209, 244));height: 66px;"><p style="font-size:15px;word-break:break-all;padding: 23px 32px;margin:0;background-color: hsla(0,0%,100%,.4);border-radius: 10px 10px 0 0;">您在<a style="text-decoration:none;color: #ffffff;" href="${SITE_URL}"> ${SITE_NAME}</a>上的留言有新回复啦！</p></div><div style="margin:40px auto;width:90%"><p>${PARENT_NICK} 同学，您曾在文章上发表评论：</p><div style="background: #fafafa repeating-linear-gradient(-45deg,#fff,#fff 1.125rem,transparent 1.125rem,transparent 2.25rem);box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);margin:20px 0px;padding:15px;border-radius:5px;font-size:14px;color:#555555;">${PARENT_COMMENT}</div><p>${NICK} 给您的回复如下：</p><div style="background: #fafafa repeating-linear-gradient(-45deg,#fff,#fff 1.125rem,transparent 1.125rem,transparent 2.25rem);box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);margin:20px 0px;padding:15px;border-radius:5px;font-size:14px;color:#555555;">${COMMENT}</div><p>您可以点击<a style="text-decoration:none; color:#12addb" href="${POST_URL}#comments">查看回复的完整內容</a>，欢迎再次光临<a style="text-decoration:none; color:#12addb"                href="${SITE_URL}"> ${SITE_NAME}</a>。</p><style type="text/css">a:link{text-decoration:none}a:visited{text-decoration:none}a:hover{text-decoration:none}a:active{text-decoration:none}</style></div></div>
```

效果如图：

![彩虹模板](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine012.png)

### (3)垃圾评论检测

> Akismet (Automattic Kismet)是应用广泛的一个垃圾留言过滤系统，其作者是大名鼎鼎的WordPress 创始人 Matt Mullenweg，Akismet也是WordPress默认安装的插件，其使用非常广泛，设计目标便是帮助博客网站来过滤留言Spam。有了Akismet之后，基本上不用担心垃圾留言的烦恼了。  
> 启用Akismet后，当博客再收到留言会自动将其提交到Akismet并与Akismet上的黑名单进行比对，如果名列该黑名单中，则该条留言会被标记为垃圾评论且不会发布。

如果还没有Akismet Key，你可以去 [AKISMET FOR DEVELOPERS 免费申请一个](https://akismet.com/development/)；  
**当AKISMET\_KEY设为MANUAL\_REVIEW时，开启人工审核模式；**  
如果你不需要反垃圾评论，Akismet Key 环境变量可以忽略。

**为了实现较为精准的垃圾评论识别，采集的判据除了评论内容、邮件地址和网站地址外，还包括评论者的IP地址、浏览器信息等，但仅在云引擎后台使用这些数据，确保隐私和安全。**

**如果使用了本站最新的Valine和Valine Admin，并设置了Akismet Key，可以有效地拦截垃圾评论。被标为垃圾的评论可以在管理页面取消标注。**

环境变量|示例|说明
-|-|-
AKISMET\_KEY|xxxxxxxxxxxx|[可选]Akismet Key 用于垃圾评论检测

### (4)防止云引擎休眠

关于自动休眠的官方说法：[点击查看](https://leancloud.cn/docs/leanengine_plan.html#hash633315134)  

目前最新版的 Valine Admin 已经可以实现自唤醒，即在 LeanCloud 云引擎中定时请求 Web 应用地址防止休眠。对于夜间休眠期漏发的邮件通知，自动在次日早上补发。**务必确保配置中设置了ADMIN_URL环境变量，并在第5步添加了两个云函数定时任务。**

### (5)Troubleshooting  

* 部署失败，请在评论中附图，或去Github发起Issue
    
* 邮件发送失败，确保环境变量都没问题后，重启云引擎
    
    ![重启云引擎](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine013.png)
    
* 博主通知模板中不要出现`PARENT*`相关参数（请勿混用模板）
    
* 点击邮件中的链接跳转至相应评论，这一细节实现需要一点额外的代码：
    
```
<script>
    if(window.location.hash){
        var checkExist = setInterval(function() {
           if ($(window.location.hash).length) {
              $('html, body').animate({scrollTop: $(window.location.hash).offset().top-90}, 1000);
              clearInterval(checkExist);
           }
        }, 100);
    }
</script>
```

### (6)验证评论邮件通知功能

假设我为博主且游客评论时填写了邮箱，以下场景能收到博客评论通知邮件:

+ 用博主的帐号评论时，博主能收到通知邮件。  
+ 游客评论后，博主能收到通知邮件。  
+ 博主回复游客，游客能收到通知邮件。

## 6、Valine 头像设置

Valine 部署完成后使用了默认图像，查阅 [Valine官网](https://valine.js.org/avatar.html)后，了解到 Valine 使用的是 [Gravatar](https://cn.gravatar.com/)作为评论列表头像，评论时提供 Gravatar 注册的邮箱即可显示设置的头像。之后我在 Gravatar 修改头像一直没生效(gravatar.cat.net 有七天的缓存)，评论列表头像没生效问题折腾了一个月左右，早已超出了7天的缓存期，后来咨询了一位高手终于解决，这里记录下。

评论头像没有刷新的原因为：Valine 默认用的是第三方CDN，第一次请求的时候缓存源站的头像，当再请求的时候就不需要返回源站请求，可能这个第三方CDN缓存刷新时有问题导致有些用户刷新成功，有些用户没有刷新，可以通过更换其它CDN解决，这里设置成 Gravatar 的CDN。

### avatar 参数

Valine 的 avatar 参数用来设置评论头像，avatar 参数可选值如下:

[![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine014.png)

我这里将 avatar 设置成空，表示使用的是默认的评论图像。

### Gravatar 设置

登录 [gravatar](https://cn.gravatar.com/)，注册账号并设置头像，我的设置如下：

[![](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2020/05/14/valine015.png)

### 主题设置的avatar_cdn 参数主题

在主题配置文件`_config.yml`中的`# Valine评论系统开关`部分增加 avatar_cdn 参数，如下:

```
valine:
  avatar_cdn: https://sdn.geekzu.org/avatar/    # gravatar头像镜像
```

然后修改Valine模板文件`/_includes/valine_comments.html`，增加`avatar_cnd`这行代码，如下:

```
avatar_cdn: '{{ site.valine.avatar_cdn }}',
```
这样就可以了！

如下是可供你选择的gravatar镜像（其中Loli源是valine默认使用的镜像，我使用的是极客族的镜像）：
```
zeruns's Blog的镜像源：https://gravatar.zeruns.tech/avatar/
gravatar官方的www源 https://www.gravatar.com/avatar/
gravatar官方的cn源 https://cn.gravatar.com/avatar/
gravatar官方的en源 https://en.gravatar.com/avatar/
gravatar官方的secure源 https://secure.gravatar.com/avatar/
V2EX源 https://cdn.v2ex.com/gravatar/
Loli源 https://gravatar.loli.net/avatar/
极客族 https://sdn.geekzu.org/avatar/
```

## 参考

+ [valine](https://valine.js.org/)
+ [Valine Admin 配置手册](https://deserts.io/valine-admin-document/)
+ [Francs's blog](https://postgres.fun/20190107095300.html)的文章：  
[《Hexo: 添加Valine评论(邮件通知、评论列表头像)》](https://postgres.fun/20190107095300.html)  
+ [Deserts](https://deserts.io/valine-admin-document/)的文章：  
[《Valine Admin 配置手册》](https://deserts.io/valine-admin-document/)  
