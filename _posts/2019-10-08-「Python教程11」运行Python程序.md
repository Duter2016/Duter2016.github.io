---
layout:     post   				    # 使用的布局（不需要改）
title:      「Python教程11」运行Python程序				# 标题 
subtitle:      Python学习笔记                 #副标题
date:       2019-10-08 				# 时间
author:     Duter2016 						# 作者
header-img: img/post-bg-dutljl.jpg 	#这篇文章标题背景图片
header-mask: "0.1"                    # 博文页面上端的背景图片的亮度，数值越大越黑暗
catalog: true 						# 开启catalog，将在博文侧边展示博文的结构
istop: false            # 设为true可把文章设置为置顶文章
music-id:       # 网易云音乐单曲嵌入
music-idfull:       # 网易云音乐歌单嵌入
tags:								#标签
    - Python
    - 教程
---

如果你在IDLE的文件编辑器中打开了一个程序，运行它很简单，按F5或选择Run►Run Module菜单项。这是在编程时运行程序的最简单方法，但打开IDLE来运行已完成的程序可能有点累。执行Python脚本还有更方便的方法。
## 1、第一行
   所有Python程序的第一行应该是#!行，它告诉计算机你想让Python来执行这个程序。该行以#!开始，但剩下的内容取决于操作系统。
      在Windows上，第一行是 #! python3。
      在OS X，第一行是 #! /usr/bin/env python3。
      在Linux上，第一行是 #! /usr/bin/python3。
      没有#!行，你也能从IDLE运行Python脚本，但从命令行运行它们就需要这一行。
## 2、第二行（Python 中文编码）

前面章节中我们已经学会了如何用 Python 输出 "Hello, World!"，英文没有问题，但是如果你输出中文字符"你好，世界"就有可能会碰到中文编码问题。

Python 文件中如果未指定编码，在执行过程会出现报错：

```
#!/usr/bin/python
print "你好，世界";
```

以上程序执行输出结果为：

```
  File "test.py", line 2
SyntaxError: Non-ASCII character '\xe4' in file test.py on line 2, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details
```

Python中默认的编码格式是 ASCII 格式，在没修改编码格式时无法正确打印汉字，所以在读取中文时会报错。

解决方法为只要在文件开头加入` # -*- coding: UTF-8 -*-` 或者 `#coding=utf-8` 就行了  

**注意：**`#coding=utf-8` 的 = 号两边不要空格。

**实例(Python 2.0+)**

```
#!/usr/bin/python
#coding=utf-8
print "你好，世界";
```

输出结果为：

`你好，世界`

所以如果大家在学习过程中，代码中包含中文，就需要在头部指定编码。


>   注意：Python3.X 源码文件默认使用utf-8编码，所以可以正常解析中文，无需指定 UTF-8 编码。
>  注意：如果你使用编辑器，同时需要设置 py 文件存储的格式为 UTF-8，否则会出现类似以下错误信息：
```
    SyntaxError: (unicode error) ‘utf-8’ codec can’t decode byte 0xc4 in position 0:
    invalid continuation byte
```
 >>  Pycharm 设置步骤：

 >>  + 进入 file > Settings，在输入框搜索 encoding。
 >>  + 找到 Editor > File encodings，将 IDE Encoding 和 Project Encoding 设置为utf-8。
>>![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/04/15/1555338403975-1555338403982.png)

3、在OS X和Linux上运行Python程序
　　在OS X上，选择Applications►Utilities►Terminal将弹出一个终端窗口。终端窗口让你用纯文本在计算机上输入命令，而不是通过图形界面点击。要在Ubuntu Linux上打开终端窗口，就按Win（或Super）键，调出Dash并输入Terminal。  

　　终端窗口将从你的用户账户的主文件夹开始。如果我的用户名是sweigart，OS X上主文件夹在`/Users/asweigart`，Linux上在`/home/asweigart`。波浪纯字符（~）是主文件夹的快捷方式，所以你可以输入cd ~切换到主文件夹。也可以使用cd命令，将当前工作目录改变到任何其他目录。在OS X和Linux上，pwd命令将打印当前工作目录。  

　　**为了运行Python程序，将你的.py文件保存到你的主文件夹。然后，更改.py文件的权限，运行`chmod +x pythonScript.py`，使之成为可执行文件。文件权限超出了本书的范围，但如果你想在终端窗口运行程序，就需要对Python文件运行此命令。这样做之后，当你打开一个终端窗口，输入`./pythonScript.py`，就能运行该脚本。脚本顶部的`#!`行会告诉操作系统，在哪里可以找到Python解释器。**  

4、在Windows上运行Python程序  

　　在Windows上，Python3.4的解释程序位于`C:\Python34\python.exe`。或者，方便的py.exe程序将读取.py文件源代码顶部的`#!`行，并针对该脚本运行相应的Python版本。如果计算机上安装了多个版本的Python，py.exe程序确保运行正确版本的Python程序。  

　　为了方便运行你的Python程序，可以创建一个.BAT批处理文件，用py.exe来运行Python程序。要创建一个批处理文件，就创建一个新的文本文件，包含一行内容，类似下面这样： 
```
@py.exe C:\path\to\your\pythonScript.py %*  
```

　　用你自己的程序的绝对路径替换该路径，将这个文件以.bat 文件扩展名保存（例如，pythonScript.bat）。这个处理文件将使你不必在每次运行时，都输入Python程序完整的绝对路径。我建议将所有的批处理文件和.py 文件放在一个文件夹中，如`C:\MyPythonScripts或C:\Users\YourName\PythonScripts`。  
　　
       在Windows上，`C:\MyPythonScripts`文件夹应该添加到系统路径中，这样就可以从Run对话框中运行其中的批处理文件。要做到这一点，请修改PATH环境变量。单击“开始”按钮，并输入`“Edit environment variables for your account（编辑账户的环境变量）”`。在你开始输入时，该选项应自动完成。弹出的环境变量窗口如图B-1所示。
  
![title](https://raw.githubusercontent.com/Duter2016/GitNote-images/master/Images/2019/04/15/1555338560883-1555338560893.png)   
　　　　　　
      图B-1 Windows的环境变量窗口  

　　从系统变量中，选择Path变量，然后单击“编辑”。在“变量值”文本字段中，追加一个分号，键入`C:\MyPythonScripts`，然后单击“确定”。现在你只需按下Win-R并输入脚本的名称，就能运行`C:\MyPythonScripts`文件夹中的Python脚本。例如，运行pythonScript，将运行pythonScript.bat，这使你不必从Run对话框运行整个命令`py.exe C:\MyPythonScripts\pythonScript.py`。


