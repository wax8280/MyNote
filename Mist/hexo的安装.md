# 配置环境

| 步骤       | 方法                              |
| -------- | ------------------------------- |
| 安装Nodejs | https://nodejs.org/en/download/ |
| 安装Git    | https://nodejs.org/en/download  |

# 安装Hexo

在Windows下如果安装了Git就用Git Bash，我觉得比Windows自带的CMD好用多了。

新建一个文件夹作装载你的博客的文件。然后进入这个文件夹，在空白的地方右键“git bash here”。

依次输入如下命令。

```
// 使用淘宝npm源
npm install -g cnpm --registry=https://registry.npm.taobao.org

// 安装
cnpm install -g hexo

// 切换到你认为合适的路径，创建博客
hexo init

// 运行
hexo s -p 4040
```

之后我们在浏览器输入[http://127.0.0.1:4040/](http://127.0.0.1:4040/)即可在本地访问。

# 更换主题

下面我们更换一个名为[Next](https://github.com/iissnan/hexo-theme-next)的主题。







