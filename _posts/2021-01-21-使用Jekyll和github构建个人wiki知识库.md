---
layout:     post
title:     使用Jekyll和github pages构建个人wiki知识库
subtitle:   用Jekyll+github pages搭建wiki知识库
date:       2021-01-21
author:     Duter2016
header-img: img/post-bg-ios9-web.jpg
catalog: true
music-id: 
music-idfull: 
tags:
    - Blog
    - 维基wiki
---

该项目使用Jekyll + github pages搭建个人wiki知识库。该方法的有点是不要借助任何复杂工具编译，就像普通Jekyll博客一样，对md文件进行静态解析，迅速高效！

**该Jekyll wiki主题项目地址为：**[Duter2016_jekyll-rtd-theme](https://github.com/Duter2016/jekyll-rtd-theme)

**DEMO地址：**[deepin用户手册及FAQ](https://duter2016.github.io/jekyll-rtd-theme/)

## 1.项目介绍

 如果你使用过github pages，那么该jekyll-rtd-theme的使用将十分简单，首先fork，然后设置为github pages，得到访问地址，在浏览器使用就可以了！
 
 编辑wiki也十分简单，直接在网页上编辑就可以了，不需要依赖其他特殊软件就可以搞定。
 
 具体使用方法见如下整理。

## 2.文档及排版要求

### 使用说明

该文档支持多层目录，目录名可为中文。每一层目录下建立一个`README.md`文档（格式要求见下方），在目录下建立你需要的`正式文档.md`(格式要求见下方)。

### （1）README.md文档格式：

文档头部格式必须为：
```
{% raw %}

---
sort: 1
---

# 该级目录的标题

{% include list.liquid all=true %}

source: `{{ page.path }}`

这里你还可以写点你想的该目录分类的介绍。

{% endraw %}
```

参数`sort: 1`为目录或文档的排序顺序。

### （2）正式文档格式：

```
{% raw %}

---
sort: 1
---

source: `{{ page.path }}`

# 你写的文档的标题

文档正文。。。。。。。

{% endraw %}
```
参数`sort: 1`为目录或文档的排序顺序，不使用该参数，文档较多时，显示不清楚层次。

### （3）插入带 Jekyll 语法的html代码格式：

本来 Markdown 用来插入 HTML 代码是没有问题的，但是 Jekyll 语法内容直接在文中的任何地方都会被转换，所以也只能借助 Jekyll 语法来解决这一问题。比如，原本的变量：

```
{% raw %}
{{ post.date }}
{% endraw %}
```
实质上在其左侧插入了{ % raw % }，在其右侧插入了{ % endraw % }。**注意，使用时花括号与百分号之间无空格，该段中为不使其转换，添加了空格**。如果你有大段代码需要应用，只需要把它们分别加到整个块的两端即可。

## 3.本项目使用jekyll-rtd-theme

![CI](https://github.com/rundocs/jekyll-rtd-theme/workflows/CI/badge.svg?branch=develop)
![jsDelivr](https://data.jsdelivr.com/v1/package/gh/rundocs/jekyll-rtd-theme/badge)

### （1）快速部署

```yml
remote_theme: rundocs/jekyll-rtd-theme
```

You can [generate](https://github.com/rundocs/starter-slim/generate) with the same files and folders from [rundocs/starter-slim](https://github.com/rundocs/starter-slim/)

### （2）特色 

- 简码 (Toasts card(tip, note, warning, danger), mermaid(流程图，时序图，甘特图，类图等))
- 页面插件 (emoji, gist, avatar, mentions)
- 自动生成侧边栏
- [属性列表定义](https://kramdown.gettalong.org/syntax.html#attribute-list-definitions) (Primer/css utilities, Font Awesome 4)
- Service worker (caches)
- SEO (404, robots.txt, sitemap.xml)
- Canonical Link (Open Graph, Twitter Card, Schema data)

简码示例：

吐司卡Toasts card(tip, note, warning, danger)：

```note
deepin用户手册文档目录上线GitHub，该项目由Jekyll wiki主题驱动！
```
```tip
deepin用户手册文档目录上线GitHub，该项目由Jekyll wiki主题驱动！
```
```danger
deepin用户手册文档目录上线GitHub，该项目由Jekyll wiki主题驱动！
```
```warning
deepin用户手册文档目录上线GitHub，该项目由Jekyll wiki主题驱动！
```

美人鱼mermaid(流程图，时序图，甘特图，类图等)：

```
{% mermaid %}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{% endmermaid %}    
```

```
{% mermaid %}
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
{% endmermaid %}
```

```
{% mermaid %}
gantt
dateFormat  YYYY-MM-DD
title Adding GANTT diagram to mermaid
excludes weekdays 2014-01-10

section A section
Completed task            :done,    des1, 2014-01-06,2014-01-08
Active task               :active,  des2, 2014-01-09, 3d
Future task               :         des3, after des2, 5d
Future task2               :         des4, after des3, 5d
{% endmermaid %}
```

```
{% mermaid %}
classDiagram
Class01 <|-- AveryLongClass : Cool
Class03 *-- Class04
Class05 o-- Class06
Class07 .. Class08
Class09 --> C2 : Where am i?
Class09 --* C3
Class09 --|> Class07
Class07 : equals()
Class07 : Object[] elementData
Class01 : size()
Class01 : int chimp
Class01 : int gorilla
Class08 <--> C2: Cool label
{% endmermaid %}
```

## （3）可选参数

| name          | default value        | description       |
| ------------- | -------------------- | ----------------- |
| `title`       | repo name            |                   |
| `description` | repo description     |                   |
| `url`         | user domain or cname |                   |
| `baseurl`     | repo name            |                   |
| `lang`        | `en`                 |                   |
| `direction`   | `auto`               | `ltr` or `rtl`    |
| `highlighter` | `rouge`              | Cannot be changed |

```yml
# folders sort
readme_index:
  with_frontmatter: true

meta:
  key1: value1
  key2: value2
  .
  .
  .

google:
  gtag:
  adsense:

mathjax: # this will prased to json, default: {}

mermaid:
  custom:     # mermaid link
  initialize: # this will prased to json, default: {}

scss:   # also _includes/extra/styles.scss
script: # also _includes/extra/script.js

translate:
  # shortcodes
  danger:
  note:
  tip:
  warning:
  # 404
  not_found:
  # copyright
  revision:
  # search
  searching:
  search:
  search_docs:
  search_results:
  search_results_found: # the "#" in this translate will replaced with results size!
  search_results_not_found:

plugins:
  - jemoji
  - jekyll-avatar
  - jekyll-mentions
```

## 编后语

做这个Jekyll wiki的灵感来自深度社区的一个用户手册的帖子、 [sphinx-rtd-theme](https://github.com/readthedocs/sphinx_rtd_theme) 以及
[jekyll-rtd-theme](https://github.com/rundocs/jekyll-rtd-theme)。总体，使用还不错，认为完全可以满足个人知识库的wiki需求。
