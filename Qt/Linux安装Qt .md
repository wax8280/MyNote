下载地址：[https://www.qt.io/download-open-source/](https://www.qt.io/download-open-source/) 
![这里写图片描述](http://img.blog.csdn.net/20170622233925191?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

在线安装 
![这里写图片描述](http://img.blog.csdn.net/20170622234706628?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

离线安装包 
![这里写图片描述](http://img.blog.csdn.net/20170622234741195?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

下载好后进入存放离线安装包的文件夹下，用命令ls -al查看文件 
![这里写图片描述](http://img.blog.csdn.net/20170622235059296?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

其中x的位置代表着该文件可被执行，若大家没有看到x,或者有些用户没有执行权限的话可以输入命令sudo chmod a+x qt-opensource-linux-x86-5.6.2.run, 将该文件的执行权限赋给所有用户

输入命令./qt-opensource-linux-x86-5.6.2.run进行安装（如果你将文件放在根目录下那么需要加上sudo），然后便会出现图形化界面，选取安装组件时全选即可 
![这里写图片描述](http://img.blog.csdn.net/20170622235655163?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

安装完成后需要**配置变量**

进入/etc/目录下，使用gedit打开profile文件，将下列三条语句添加值文件尾部 

```
export QTDIR=/home/hjh/Qt5.6.2/5.6（这里填写你的安装目录） 
export PATH=$QTDIR/gcc_64/bin:$PATH 
export LD_LIBRARY_PATH=$QTDIR/gcc_64/lib:LD_LIBRARY_PATH
```

保存后退出，然后输入source profile让环境变量生效

最后网上的同志们便会很高兴的告诉你，你们可以验证安装是否成功啦，执行命令qmake -version看看能不能显示正常的版本信息。然后你就觉得喜大普奔了吗，naive。你输入命令之后将会是这样

![这里写图片描述](http://img.blog.csdn.net/20170623000509922?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

难道是之前什么姿势不对了吗。其实是在你的/usr目录下有个qt的默认路径选择，他并没有指向你刚刚安装的qmake的位置

**解决办法** 
-输入命令 cd /usr/lib/x86_64-linux-gnu/qt-default/qtchooser 进入到qtchooser目录下，打开default.conf文件 
\- 将第一行中的qmake执行文件的位置设为你的qmake执行文件位置即可，我的安装目录是/home/hjh/Qt5.6.2/5.6，所以正确的路径应该是/home/hjh/Qt5.6.2/5.6/bin/qmake。

然后执行命令查看是否配置成功

![这里写图片描述](http://img.blog.csdn.net/20170623001311666?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTmV3X1doZW4=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

这样Qt5的环境就搭好了。