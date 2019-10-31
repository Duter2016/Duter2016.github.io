## 1.我的说说文件
我的说说数据文件为`talks.yml`，数据格式为：

```
- mytalk: "我的说说内容。"    #说说内容
  talkmonth: "2019年10"    #年月格式‘2019年10’
  talkday: "30"    #日期‘日’
```

## 2.我的书单数据文件
效果见[「我的书单页面」](https://duter2016.github.io/books/)

### 已读书单数据
已读书单数据文件为`booksyd.yml`，数据格式为：  

```
- name: "风雪追击01"    #书名
  author: "[日] 东野圭吾"    #作者
  translator: "赵文梅"    #翻译者
  press: "现代出版社"    #出版社
  publishdate: "2017-4"    #出版日期
  price: "39.80元"    #价格
  bookimg: "https://img1.doubanio.com/view/subject/m/public/s29362779.jpg"    #封面图片链接地址
  doubanurl: "https://book.douban.com/subject/26971148/"    #豆瓣书单地址
  readdate: "2018-12-29"    #阅读日期
  booktag: "文学"    #书的分类标签
  stars: "★★★☆☆"    #评价星级
  rate: "还行"    #1到5星分别为很差、较差、还行、推荐、力荐
  review: "等待也是种信念，海的爱太深，时间太浅。"    #书评
```

评价等级与推荐等级对应关系：
+ ★☆☆☆☆ 很差
+ ★★☆☆☆ 较差
+ ★★★☆☆ 还行
+ ★★★★☆ 推荐
+ ★★★★★ 力荐

### 想读书单数据
已读书单数据文件为`booksxd.yml`，数据格式为：  

```
- name: "风雪追击03"    #书名
  author: "[日] 东野圭吾"    #作者
  translator: "赵文梅"    #翻译者
  press: "现代出版社"    #出版社
  publishdate: "2017-4"    #出版日期
  price: "39.80元"    #价格
  bookimg: "https://img1.doubanio.com/view/subject/m/public/s29362779.jpg"    #封面图片链接地址
  doubanurl: "https://book.douban.com/subject/26971148/"    #豆瓣书单地址
  readdate: "2018-12-29"    #阅读日期
  booktag: "文学"    #书的分类标签
```
### 在读书单数据
已读书单数据文件为`bookszd.yml`，数据格式为：  

```
- name: "风雪追击05"    #书名
  author: "[日] 东野圭吾"    #作者
  translator: "赵文梅"    #翻译者
  press: "现代出版社"    #出版社
  publishdate: "2017-4"    #出版日期
  price: "39.80元"    #价格
  bookimg: "https://img1.doubanio.com/view/subject/m/public/s29362779.jpg"    #封面图片链接地址
  doubanurl: "https://book.douban.com/subject/26971148/"    #豆瓣书单地址
  readdate: "2018-12-29"    #阅读日期
  booktag: "文学"    #书的分类标签
```

### 书单数目统计
已读书单数据文件为`bookstj.yml`，数据格式为：

```
zdnum: "2"    #在读书单数目
xdnum: "2"    #想读书单数目
ydnum: "12"    #已读书单数目
booknote: "本页面正在测试中。"    #书单页面的提示语
```

