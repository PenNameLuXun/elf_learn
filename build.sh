
BUILD_FLAG=build_x64

if [[ "$1" == "x32" ]]; then

#注意安装如下x86_32工具链
#sudo apt install libc6-dev-i386 lib32gcc-12-dev lib32stdc++-12-dev
#sudo apt install gcc-multilib g++-multilib

#这个是安装aarch arm的工具链，它和如上有冲突，所以如果后面需要交叉编译arm64，需要执行如下命令安装
#sudo apt install gcc-aarch64-linux-gnu gcc-11-aarch64-linux-gnu
    #GCC_FLAGS="-m32 -masm=intel"
    GCC_FLAGS="-m32"
    BUILD_FLAG="build_x32"
    LD_FLAG="-m elf_i386"
fi
DIR_NAME=$BUILD_FLAG
mkdir -p $DIR_NAME

pushd $DIR_NAME/

#-nostdlib -fno-builtin 
gcc ${GCC_FLAGS} -g -c ../one_lib.c
gcc ${GCC_FLAGS} -g -c ../learn.c

if [[ "$2" == "ld" ]]; then
    echo "do ld" 
    ld ${LD_FLAG} -o learnC -T ../ld.lds one_lib.o learn.o
else
    ld one_lib.o learn.o -o learnC
fi

#查看编译 one_lib.c 后的信息
objdump -D ./one_lib.o > one_lib_dump.txt
readelf -S ./one_lib.o > one_lib_section_headers.txt
readelf -s ./one_lib.o > one_lib_symtab.txt

#查看编译 learn.c 后的信息
readelf -S ./learn.o > learn_o_section_headers.txt
readelf -s ./learn.o > learn_o_symtab.txt
readelf -r ./learn.o > learn_o_rel.txt
objdump -D ./learn.o > learn_o_dump.txt

#查看链接生成 learnC 后的信息
objdump -D ./learnC > learnC_dump.txt
readelf -S ./learnC > learnC_section_headers.txt
readelf -s ./learnC > learnC_symtab.txt
readelf -l ./learnC  > learnC_program_headers.txt

./learnC

popd