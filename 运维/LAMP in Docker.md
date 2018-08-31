# LAMP in Docker

###下载镜像

```
docker pull linode/lamp
```

### 启动此镜像

```
sudo docker run -p 80:80 -p 3306:3306 -v /docker_image/lamp/var/www:/var/www -t -i linode/lamp /bin/bash

#解释：
docker run：运行一个container，如果后面要绑定宿主主机的0-1024端口需要使用sudo
-p port1:port2: 将宿主机的端口port1映射到容器中的port2
-v file1:file2: 将宿主机的文件\路径挂载到容器中的文件\路径
-t -i linode/lamp /bin/bash：使用linode/lamp生成容器，并打开shell
```

