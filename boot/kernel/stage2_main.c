// stage2_main.c
#include <stdint.h>

/* --- 1. 定义 ATA 端口 --- */
#define ATA_DATA        0x1F0
#define ATA_COUNT       0x1F2
#define ATA_LBA_LOW     0x1F3
#define ATA_LBA_MID     0x1F4
#define ATA_LBA_HIGH    0x1F5
#define ATA_DRIVE       0x1F6
#define ATA_CMD         0x1F7
#define ATA_STATUS      0x1F7

#define CMD_READ        0x20
#define STATUS_BSY      0x80
#define STATUS_DRQ      0x08

/* --- 2. 内联汇编封装端口操作 --- */
static inline void outb(uint16_t port, uint8_t val) {
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static inline void insl(uint16_t port, void *addr, uint32_t cnt) {
    asm volatile ("rep insl" : "+D"(addr), "+c"(cnt) : "d"(port) : "memory");
}

/* --- 3. ATA 读取函数 (C 实现) --- */
void read_sectors(uint32_t lba, uint8_t count, uint32_t dest_addr) {
    // 设置 LBA 模式和高 4 位地址
    // 0xE0 = 11100000b (Master drive, LBA mode)
    outb(ATA_DRIVE, 0xE0 | ((lba >> 24) & 0x0F));
    
    // 设置扇区数
    outb(ATA_COUNT, count);
    
    // 设置 LBA 地址
    outb(ATA_LBA_LOW,  (uint8_t)(lba));
    outb(ATA_LBA_MID,  (uint8_t)(lba >> 8));
    outb(ATA_LBA_HIGH, (uint8_t)(lba >> 16));
    
    // 发送读取命令
    outb(ATA_CMD, CMD_READ);

    uint32_t *ptr = (uint32_t*)dest_addr;

    for (int i = 0; i < count; i++) {
        // 等待 BSY 清除
        while (inb(ATA_STATUS) & STATUS_BSY);
        
        // 等待 DRQ (数据准备好)
        while (!(inb(ATA_STATUS) & STATUS_DRQ));

        // 读取 1 个扇区 (256 个 word = 512 字节 / 4 = 128 个 uint32)
        insl(ATA_DATA, ptr, 128);
        ptr += 128; // 指针后移 128 个 uint32 (512 字节)
    }
}

/* --- 4. 主逻辑 --- */
// 定义主内核入口函数的类型：无参数，无返回值
typedef void (*kernel_entry_t)(void);

void stage2_main() {
    /* 配置参数：
       - LBA Start: 11 (假设 Bootloader=1扇区, Stage2=10扇区)
       - Count: 100 (读取 100 个扇区，约 50KB)
       - Dest: 0x100000 (1MB 处)
    */
    uint32_t kernel_addr = 0x100000;
    
    // 1. 读取内核到内存
    read_sectors(11, 100, kernel_addr);

    // 2. 强制转换地址为函数指针
    kernel_entry_t kernel_start = (kernel_entry_t)kernel_addr;

    // 3. 跳转！(Call the kernel)
    kernel_start();

    // 理论上不会运行到这里
    while(1) {}
}