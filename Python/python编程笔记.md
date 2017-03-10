# 脚本运行上下文

- 当前工作路径（CWD）：运行脚本的路径，也就是你在shell中执行脚本的路径。脚本可以使用`os.getcwd`获取当前CWD路径；使用`os.chdir`改变CWD
- 可在执行的时候指定CWD：`python /home/vincent/test.py *.py /home`或在vincent目录下`python test.py *.py /home`
- ​