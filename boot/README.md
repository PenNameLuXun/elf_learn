# 背景
学习目的的一个从bootloader开始，到最终kernel的启动代码。包含了从实模式到32模式从而进行c世界的逻辑，基于qemu-system-i386进行模拟。

# 构建
```bash
#清理
#make clean
make
```

# 调试
```bash
make qemu-gdb
# 进入后gdb环境后执行c即可(其他gdb配置已经通过本地的.gdbinit初始化了)
```

> 后续考虑基于64位