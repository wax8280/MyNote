# OS模块

## 进程参数

`os.environ`：返回环境变量

`os.chdir(path)`：改变当前工作目录

`os.getcwd()`：获取当前目录

`os.fsencode(filename)`：使用系统的编码来对文件名称filename进行解码。

`os.fsdecode(filename)`：于上相反
`os.getenv(key, default=None)`：获取环境变量值
`os.get_exec_path(env=None)`：返回查找执行程序的目录路径，比如PATH路径变量的值。
`os.getegid()`：返回当前进程有效的组标识号它对应于当前进程中正在执行的文件的“set id”。仅用于Unix。
`os.geteuid()`：返回当前进程有效的用户标识号。仅用于Unix。
`os.getgid()`：返回当前进程的实际组号。仅用于Unix
`os.getgrouplist(user, group)`：返回用户所属的组列表。仅用于Unix。
`os.getgroups()`：返回当前进程的组列表。仅用于Unix。
`os.getpgid(pid)`：获取pid的进程标识号。仅用于Unix。
`os.getpgrp()`：返回当前进程组的标识号。仅用于Unix。
`os.getppid()`：返回当前父进程的进程标识号。
`os.getresuid()`：返回当前进程的元组（ruid， euid，suid）。仅用于Unix。
`os.getresgid()`：返回当前进程的元组（rgid，egid，sgid）。仅用于Unix。
`os.getuid()` ：返回当前进程用户标识号。仅用于Unix。
`os.setegid(egid)`：设置当前进程有效的组标识号。仅用于Unix。
`os.seteuid(euid)`：设置当前里程有效的用户标识号。仅用于Unix。
`os.setgid(gid)`：设置当前进程的组标识号。仅用于Unix。
`os.setgroups(groups)`：设置当前进程的组。仅用于Unix。
`os.setpgid(pid, pgrp)`：调用系统调用setpgid()以将进程ID为pid的进程组ID设置为进程组id pgrp。仅用于Unix。
`os.setregid(rgid, egid)`：设置当前进程的真实和有效组ID。
`os.setreuid(ruid, euid)`：设置当前进程的真实的和有效的用户ID。
`os.setuid(uid)`：设置当前进程的用户ID。
`os.setpriority(which, who, priority)`：
设置程序调度优先级。仅用于Unix。
`os.initgroups(username, gid)`：设置用户名和组标识号。仅用于Unix。
`os.putenv(key, value)`：设置环境变量，设置键key为值value。
`os.getlogin()`：返回当前控制终端登录进去的用户名称。仅用于Unix。

## 文件操作

`os.fdopen(fd, *args, **kwargs)`：返回一个连接到文件描述符fd 的文件对象。这是open()内建函数的别名，并接受相同的参数。唯一的区别是fdopen()的第一个参数必须始终为整数。