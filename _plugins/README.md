# 安装插件
## 有两种安装插件的方式：

1、在网站根下目录建立 _plugins 文件夹，插件放在这里即可。 Jekyll 运行之前，会加载此目录下所有以 *.rb 结尾的文件。

2、在 _config.yml 文件中，添加一个以 gems 作为 key 的数组，数组中存放插件的 gem 名称。例如：

```
 gems: [jekyll-test-plugin, jekyll-jsonify, jekyll-assets]
 # This will require each of these gems automatically.
```
