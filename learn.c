// #include <stdio.h>
typedef char bool;
#define true 1;
#define false 0;
struct Student{
    int id;
    bool sex;
    char* name;
    bool age;
};
// //这个函数将被放到'.init' section中，系统会首先执行这个节中的代码，因此实现了先于main函数执行

// //多个这样的函数，还可以设置优先级，优先级值越小越先执行,取值是从101开始，0-100是预留给gcc的
// __attribute__((constructor(102))) void my_init_before_main_1(){
//     printf("%s\n",__FUNCTION__);
// }
// __attribute__((constructor(101))) void my_init_before_main_2(){
//     printf("%s\n",__FUNCTION__);
// }


// __attribute__((destructor)) void my_destructor1(){
//     printf("%s\n",__FUNCTION__);
// }

#define RETURN(ret) \
    asm volatile(                 \
        "movl $1, %%eax\n\t"      \
        "movl %0, %%ebx\n\t"      \
        "int $0x80"               \
        :                         \
        : "i"(ret)                \
        : "%eax", "%ebx"          \
    );

static int local_int_var = 2;
int un_init_var;
void my_function(){
    //printf("AAAAAA\n");
    //RETURN(0)
}

static void local_func(){
    //printf("BBBBBB\n");
    //RETURN(0)
    my_function();
}
extern int my_add(int a,int b);
#define OFFSET_OF(TYPE,mem) ((size_t)&(((TYPE*)0)->mem))
int main(int count,char* args[]){

    un_init_var=1;
    local_int_var=3;
    struct  Student stu;

#if defined(__x86_64__) || defined(_M_X64) || defined(__aarch64__)
    //printf("64-bit build\n");
#elif defined(__i386__) || defined(_M_IX86) || defined(__arm__)
    //printf("32-bit build\n");
#else
    //printf("Unknown architecture\n");
#endif


    int (*sss)(int,char**) = &main;

    // printf("main    p = 0x%p, sss= 0x%p\n",&main,sss);
    
    // printf("stu     p = 0x%p\n",&stu);
    // printf("stu id  p = 0x%p\n",&stu.id);
    // printf("stu namep = 0x%p\n",&stu.name);
    // printf("stu sex p = 0x%p\n",&stu.sex);
    // printf("stu age p = 0x%p\n",&stu.age);


    // //%zu和%zd兼容了32位和64位，等价于64位下的%lu和%ld，32位下的%u和%d
    // printf("stu age offset = %zu,total size = %zd currernt function=%s,current line:%d\n",
    //                 OFFSET_OF(struct Student,age),
    //                 sizeof(stu),__FUNCTION__,__LINE__);

    
    my_function();


    local_func();

    //printf("my add result is %d\n",my_add(5,6));
    

    //这是模拟libc的实现返回值1，如果时裸机构建，就需要用到这个来模拟return 1.
    // asm volatile(
    //     ".intel_syntax noprefix;"
    //     "mov eax, 1;"
    //     "mov ebx, 0;"
    //     "int 0x80;"
    //     ".att_syntax prefix;"
    // );
    //或者AT&T风格
    asm volatile(
        "movl $1, %%eax\n\t"  //1对应的系统调用就是 sys_exit
        "movl $10, %%ebx\n\t"  //参数是退出状态码 0
        "int $0x80"           //Linux 内核在启动时，会设置中断向量表 (IDT)，把中断号 0x80 绑定到一个专门的系统调用入口函数
                              //vector_0x80:
                              //  call system_call

        :
        :
        : "%eax", "%ebx"
    );


    //return 0;
}