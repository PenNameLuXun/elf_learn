ENTRY(start)
SECTIONS
{
    /* 程序起始地址 */
    . = 0x7c00;

    /* 代码段 */
    .text : {
        *(.text)
    }

    /* 数据段 */
    .data : {
        *(.data)
    }

    /* BSS 段 */
    .bss : {
        *(.bss)
        *(COMMON)
    }
}