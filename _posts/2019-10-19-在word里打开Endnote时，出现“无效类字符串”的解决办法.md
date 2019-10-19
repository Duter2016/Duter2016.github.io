---
layout:     post   				    # 使用的布局（不需要改）
title:      在word里打开Endnote时，出现“无效类字符串”的解决办法 				# 标题 
subtitle:      EndNote 疑难解答                 #副标题
date:       2019-10-19 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-desk.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:         # 网易云音乐单曲嵌入
music-idfull:         # 网易云音乐歌单嵌入
tags:								#标签
    - EndNote
    - 疑难解答
---

### 方法一：

**All Other Versions**

If you have never run the EndNote program under the account you’re current logged in as, you may get an “Invalid Class String” error when you try to use the tools in Word. To fix this:

1.  Close out of Word.
2.  Open the EndNote program and a library.
3.  Open Word and try to use the tools. They should function as expected.

You only need to open the programs in this order the first time in order to establish the link between Word and EndNote properly.

You may also get this error if the program was installed under a different account than the one you are currently logged in under. On a Windows 2000/XP/Vista/7 system you must install the program while logged in as the user who will be running the program, and this account must have administrative rights to the local machine in order for the registry to be updated correctly. Rerun the installation under these conditions and the error should be resolved.

This error may also be caused if you are using a different version of EndNote than the version of the CWYW tools that are installed in Word. Make sure that the version of EndNote that’s currently open matches the version of the tools in Word when you go to “Tools > EndNote”(in Word 2000/XP/2003) or look at the “Add-Ins” tab in Word 2007. The name of that “EndNote” submenu should be the same number as your current version of EndNote (for example, EndNote X1 will have an “EndNote X1″ submenu in word 2000/XP/2003). Only EndNote X1 and later will have an “EndNote” tab in Word 2007, and only EndNote X4 will have a tab in Word 2010.  
**EndNote X1 and later on Windows Vista/7**

1.  Close all open programs.
2.  Go to the EndNote program folder. This is typically  
    `C:\Program Files\EndNote XX`
    or  
    `C:\Program Files (X86)\EndNote XX`   
    Where XX represents your version of EndNote
3.  Right click on EndNote.exe and select “Run as administrator.”
4.  With EndNote open, click on the Start Menu. In the search box type “regedit” (without quotes) and hit enter on your keyboard to launch the Registry Editor.
5.  Expand the “HKEY\_CLASSES\_ROOT” folder and locate the key:  
    “EndNote11.AddinServer” (for X1)  
    “EndNote12.AddinServer” (for X2)  
    “EndNote13.AddinServer” (for X3)  
    “EndNote14.AddinServer” (for X4)
6.  Right Click on the AddinServer key and select Permissions.
7.  Click Advanced. Then click Add.
8.  In object name, type “Everyone” (without quotes) and click Ok.
9.  In the Permissions entry window， 在“允许”选择“完全控制” and then choose OK.
10.  Close the Registry Editor and close EndNote.
11.  Start EndNote and your word processor normally and try the tools.

摘自：[http://www.endnote.com/support/faqs/CWYW/faq13.asp#vista](http://www.endnote.com/support/faqs/CWYW/faq13.asp#vista)

### 方法二：
EndNote工具栏出现无效字符串怎么破？点击<a href=)在Word的工具栏出现「无效字符串」或「Invalid Class String」错误提示，这错误是怎么造成的，又该怎么解决呢？

#### 1.EndNote工具栏出现无效字符串原因分析
---------------------

点击[EndNote](http://www.howsci.com/tag/endnote/)在[Word](http://www.howsci.com/tag/word/)的工具栏出现「无效字符串」错误，大多数原因是因为Word中的CWYW和EndNote版本不一致造成的。

神马意思？举个例子可能更清楚。比如以前安装的是EndNote X6，现在升级为EndNote X7。但是Word中的EndNote工具栏版本还是停留在EndNote X6水平，此时如果点击Word中的EndNote工具栏，就可能出现「无效字符串」或「Invalid Class String」错误提示。

另外[EndNote](http://www.howsci.com/tag/endnote/) X以前的版本如果安装的用户不同，也会出现上述错误。

神马意思？比如一个电脑有两个及其以上的用户，其中一个用户安装了EndNote，但是如果使用另一用户登陆电脑的话，此时使用EndNote就会出现无效字符串的错误。不过EndNote X系以后版本这个错误已经修正了。

#### 2.EndNote工具栏出现无效字符串解决方法
---------------------

明白了原因，解决起来也就简单多了。

**EndNote X以前的版本**

如果一个电脑有多个用户，当前用户使用EndNote时出现无效字符串的错误。解决方法是需要使用当前用户再次安装一下EndNote。

注意当前用户必须是管理员权限用户。

**Windows Vista或者Windows 7以上的用户**

因为微软自从Windows Vista及其后系统，为了系统安全，引用一个用户权限控制UAC功能。虽然系统安全性增加了，但是也会因此引起很多问题。

最简单的解决方法是关闭用户UAC功能。打开控制面板→系统和安全→更改用户账户控制设置，把控制条拉到最后，成为「从不通知」，然后确定即可。此时再次重新修复安装一下EndNote即可。

但是我个人不并建议这样做，因为这样系统的安全性就降低了。我更建议是使用[EndNote安装出现error1723怎么破](http://www.howsci.com/endnote-error1723.html)一文提到的使用管理员权限安装EndNote的安装方法。

到此应该问题解决了，如果还解决，那么请继续。

**修改注册表**

注意此项操作是危险操作，请选做好注册表备份。

使用「Win+R」或者开始→运行，输入「regedit」，打开注册表编辑器。

展开「HKEY\_CLASSES\_ROOT」键值，找到EndNoteXX.AddinServer，注意此处的XX因EndNote版本不同数字也不同，例如EndNote X7此处就是EndNote17.AddinServer。

右键点击EndNote17.AddinServer，打开新的对话框，选择「权限」。

看看当前用户的权限应该是这样的

*   完全控制：允许
*   读取：允许

如果权限不是这样的，那么选择「高级」→「编辑」一下权限即可。

如果还不行或者根本就不知道当前用户是谁!，好吧，那就新建一个用户吧。在用户的权限控制，如上图，选择「添加」。在输入对称名称来选择中输入「Everyone」，然后「检查名称」→「确定」即可。

此时就会发现多了一个用户「Everyone」，然后给予此用户权限为

*   完全控制：允许
*   读取：允许

确定，关闭注册表编辑器即可。有时可能需要重启一下电脑。

> 注：如果在注册表里面找不到EndNote17.AddinServer这一项的话，就把所有关于EndNote的注册表项都重复以上的权限设置，并把你当前用户的权限也设置为“完全控制”就可以了，本站（锐经）站长在一台电脑上遇到了这个情况，这样处理后可以正常使用了！

> 另外，在word中使用EndNote时，一定要先打开EndNote，然后再打开你要编辑的word文档！
