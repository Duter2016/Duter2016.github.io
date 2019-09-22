---
layout:     post
title:     「Python教程01」Python语法元素
subtitle:   Python学习笔记
date:       2019-09-17
author:     Duter2016
header-img: img/post-bg-dutnm.jpg
catalog: true
tags:
    - Python
    - 教程
---

一、Python语法元素  
1、注释的两种方法：  
（1）单行注释以#开头  
（2）多行注释以’’’开头和结尾

2、val 变量

3、空格的使用  
（1）表示缩进关系的空格不能改变  
（2）命名不能用空格分割

4、字符串可理解为一个字符序列，其长度为l，其第一个字节索引为0或-l，最后一个字节索引为l-1或-1.  
如果val=28C，则val[-1]是最后一个字符“C”;前两个字符组成的子串可以用val[0:2]表示，它表示一个从[0,2)的区间。  
由于约定用户输入的最后一个字符是C或F，之前是数字，所以通过val[0:-1]来获取除最后一个字符以外的字符串。

5、input（）和print（）  
print（）通过%选择要输出的变量，“%.2f”表示包含两位的小数的浮点数。  
可以用这个函数在屏幕上打印出空行，只要调用print()就可以了，括号内没有任何东西。  

6、计数循环基本过程  
for i in range (<计数值>）:  
 <表达式组>  
例：使某一段程序连续运行10次：  
for i in range (10):  
 <表达式组>  

7、可以向len()函数传递一个字符串（或包含字符串的变量），然后该函数求值为一个整型值，即字符串中字符的个数。  
在交互式环境中输入以下内容试一试：

	>>> len('hello')
	5
	>>> len('My very energetic monster just scarfed nachos.')
	46
	>>> len('')
	0

就像这些例子，len(myName)求值为一个整数。

 

