# Docker架构

Docker 使用客户端-服务器 (C/S) 架构模式，使用远程API来管理和创建Docker容器。

Docker 容器通过 Docker 镜像来创建。

容器与镜像的关系类似于面向对象编程中的对象与类。

![img](http://www.runoob.com/wp-content/uploads/2016/04/576507-docker1.png)

| 名称                   | 说明                                       |
| :------------------- | :--------------------------------------- |
| Docker 镜像(Images)    | Docker 镜像是用于创建 Docker 容器的模板。             |
| Docker 容器(Container) | 容器是独立运行的一个或一组应用。                         |
| Docker 客户端(Client)   | Docker 客户端通过命令行或者其他工具使用 Docker API ([https://docs.docker.com/reference/api/docker_remote_api](https://docs.docker.com/reference/api/docker_remote_api)) 与 Docker 的守护进程通信。 |
| Docker 主机(Host)      | 一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。          |
| Docker 仓库(Registry)  | Docker 仓库用来保存镜像，可以理解为代码控制中的代码仓库。Docker Hub([https://hub.docker.com](https://hub.docker.com/)) 提供了庞大的镜像集合供使用。 |
| Docker Machine       | Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。 |

# Docker安装

```
curl -sSL https://get.docker.com/ | sh 
//启动docker 后台服务
sudo service docker start
//运行
sudo docker run hello-world
```

# 使用

## 运行交互式的容器

```
runoob@runoob:~$ docker run -i -t ubuntu:15.10 /bin/bash
```

* -t:在新容器内指定一个伪终端或终端。
* i:允许你对容器内的标准输入 (STDIN) 进行交互。

## 启动容器（后台模式）

使用以下命令创建一个以进程方式运行的容器

```
runoob@runoob:~$ docker run -d ubuntu:15.10 /bin/sh -c "while true; do echo hello world; sleep 1; done"
2b1b7a428627c51ab8810d541d759f072b4fc75487eed05812646b8534a2fe63
```

查看容器

```
runoob@runoob:~$ docker ps
```

查看容器的标准输出

```
runoob@runoob:~$ docker logs 2b1b7a428627
```

停止容器

```
runoob@runoob:~$ docker stop amazing_cori
```
## 容器连接

### 绑定网络端口

```
runoob@runoob:~$ docker run -d -p 127.0.0.1:5001:5002 training/webapp python app.py
95c6ceef88ca3e71eaf303c2833fd6701d8d1b2572b5613b5a932dfdfe8a857c
runoob@runoob:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                NAMES
95c6ceef88ca        training/webapp     "python app.py"     6 seconds ago       Up 6 seconds        5000/tcp, 127.0.0.1:5001->5002/tcp   adoring_stonebraker
33e4523d30aa        training/webapp     "python app.py"     3 minutes ago       Up 3 minutes        0.0.0.0:5000->5000/tcp               berserk_bartik
fce072cc88ce        training/webapp     "python app.py"     10 minutes ago      Up 10 minutes       0.0.0.0:32768->5000/tcp              grave_hopper
```

这样我们就可以通过访问127.0.0.1:5001来访问容器的5002端口。

# 镜像

## 获取镜像

```
docker pull [选项] [Docker Registry地址]<仓库名>:<标签>
```

## 列出镜像

```
$ docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
redis                latest              5f515359c7f8        5 days ago          183 MB
nginx                latest              05a60462f8ba        5 days ago          181 MB
mongo                3.2                 fe9198c04d62        5 days ago          342 MB
<none>               <none>              00285df0df87        5 days ago          342 MB
ubuntu               16.04               f753707788c5        4 weeks ago         127 MB
ubuntu               latest              f753707788c5        4 weeks ago         127 MB
ubuntu               14.04               1e0c3dd64ccd        4 weeks ago         188 MB
```

## 镜像体积

```
$ docker system df

TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              24                  0                   1.992GB             1.992GB (100%)
Containers          1                   0                   62.82MB             62.82MB (100%)
Local Volumes       9                   0                   652.2MB             652.2MB (100%)
Build Cache                                                 0B                  0B
```

## 更新镜像

更新镜像之前，我们需要使用镜像来创建一个容器。

```
runoob@runoob:~$ docker run -t -i ubuntu:15.10 /bin/bash
root@e218edb10161:/# 
```

在运行的容器内使用 apt-get update 命令进行更新。

在完成操作之后，输入 exit命令来退出这个容器。

此时ID为e218edb10161的容器，是按我们的需求更改的容器。我们可以通过命令 docker commit来提交容器副本。

```
runoob@runoob:~$ docker commit -m="has update" -a="runoob" e218edb10161 runoob/ubuntu:v2
sha256:70bf1840fd7c0d2d8ef0a42a817eb29f854c1af8f7c59fc03ac7bdee9545aff8
```

各个参数说明：

- **-m:**提交的描述信息
- **-a:**指定镜像作者
- **e218edb10161：**容器ID
- **runoob/ubuntu:v2:**指定要创建的目标镜像名

我们可以使用 **docker images** 命令来查看我们的新镜像 **runoob/ubuntu:v2**：

```
runoob@runoob:~$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
runoob/ubuntu       v2                  70bf1840fd7c        15 seconds ago      158.5 MB
ubuntu              14.04               90d5884b1ee0        5 days ago          188 MB
php                 5.6                 f40e9e0f10c8        9 days ago          444.8 MB
nginx               latest              6f8d099c3adc        12 days ago         182.7 MB
mysql               5.6                 f2e8d6c772c0        3 weeks ago         324.6 MB
httpd               latest              02ef73cf1bc0        3 weeks ago         194.4 MB
ubuntu              15.10               4e3b13c8a266        4 weeks ago         136.3 MB
hello-world         latest              690ed74de00f        6 months ago        960 B
training/webapp     latest              6fae60ef3446        12 months ago       348.8 MB
```

使用我们的新镜像 **runoob/ubuntu** 来启动一个容器

```
runoob@runoob:~$ docker run -t -i runoob/ubuntu:v2 /bin/bash                            
root@1a9fbdeb5da3:/#
```

## 虚悬镜像

上面的镜像列表中，还可以看到一个特殊的镜像，这个镜像既没有仓库名，也没有标签，均为 `<none>`。：

```
<none>               <none>              00285df0df87        5 days ago          342 MB

```

这个镜像原本是有镜像名和标签的，原来为 `mongo:3.2`，随着官方镜像维护，发布了新版本后，重新 `docker pull mongo:3.2` 时，`mongo:3.2` 这个镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了 `<none>`。除了 `docker pull` 可能导致这种情况，`docker build` 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 `<none>` 的镜像。这类无标签镜像也被称为 **虚悬镜像(dangling image)** ，可以用下面的命令专门显示这类镜像：

```
$ docker images -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              00285df0df87        5 days ago          342 MB

```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除。

```
$ docker rmi $(docker images -q -f dangling=true)

```

在 Docker 1.13+ 版本中你可以便捷的使用以下命令来删除虚悬镜像。

```
$ docker image prune
```






# 附

## Docker的镜像和容器的区别

##### 作者：chszs，版权所有，未经同意，不得转载。博主主页：[http://blog.csdn.net/chszs](http://blog.csdn.net/chszs)

### 一、Docker镜像

要理解Docker镜像和Docker容器之间的区别，确实不容易。

假设Linux内核是第0层，那么无论怎么运行Docker，它都是运行于内核层之上的。这个Docker镜像，是一个只读的镜像，位于第1层，它不能被修改或不能保存状态。

一个Docker镜像可以构建于另一个Docker镜像之上，这种层叠关系可以是多层的。第1层的镜像层我们称之为基础镜像（Base Image），其他层的镜像（除了最顶层）我们称之为父层镜像（Parent Image）。这些镜像继承了他们的父层镜像的所有属性和设置，并在Dockerfile中添加了自己的配置。

Docker镜像通过镜像ID进行识别。镜像ID是一个64字符的十六进制的字符串。但是当我们运行镜像时，通常我们不会使用镜像ID来引用镜像，而是使用镜像名来引用。要列出本地所有有效的镜像，可以使用命令

```
# docker images
12
```

镜像可以发布为不同的版本，这种机制我们称之为标签（Tag）。 
![这里写图片描述](http://img.blog.csdn.net/20150906225017378)

如上图所示，neo4j镜像有两个版本：lastest版本和2.1.5版本。

可以使用pull命令加上指定的标签：

```
# docker pull ubuntu:14.04
# docker pull ubuntu:12.04
123
```

### 二、Docker容器

Docker容器可以使用命令创建：

```
# docker run imagename
12
```

它会在所有的镜像层之上增加一个可写层。这个可写层有运行在CPU上的进程，而且有两个不同的状态：运行态（Running）和退出态（Exited）。这就是Docker容器。当我们使用docker run启动容器，Docker容器就进入运行态，当我们停止Docker容器时，它就进入退出态。

当我们有一个正在运行的Docker容器时，从运行态到停止态，我们对它所做的一切变更都会永久地写到容器的文件系统中。要切记，对容器的变更是写入到容器的文件系统的，而不是写入到Docker镜像中的。

我们可以用同一个镜像启动多个Docker容器，这些容器启动后都是活动的，彼此还是相互隔离的。我们对其中一个容器所做的变更只会局限于那个容器本身。

如果对容器的底层镜像进行修改，那么当前正在运行的容器是不受影响的，不会发生自动更新现象。

如果想更新容器到其镜像的新版本，那么必须当心，确保我们是以正确的方式构建了数据结构，否则我们可能会导致损失容器中所有数据的后果。

64字符的十六进制的字符串来定义容器ID，它是容器的唯一标识符。容器之间的交互是依靠容器ID识别的，由于容器ID的字符太长，我们通常只需键入容器ID的前4个字符即可。当然，我们还可以使用容器名，但显然用4字符的容器ID更为简便。