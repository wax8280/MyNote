# 关于Android Studio AVD不能启动的解决方法

无反应，查看log得知。

```
....
libGL error: unable to load driver: nouveau_dri.so
libGL error: driver pointer missing
libGL error: failed to load driver: nouveau
libGL error: unable to load driver: swrast_dri.so
libGL error: failed to load driver: swrast
....
```

用命令行启动也不行

```
./emulator -avd EMULATOR_NAME -netspeed full -netdelay none
```

后来经过查询发现，使用系统的库即可

```
./emulator -avd EMULATOR_NAME -netspeed full -netdelay none -use-system-libs
```

更改Android Studio启动的sh（bin/studio.sh）。在开头添加。

```
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
```

