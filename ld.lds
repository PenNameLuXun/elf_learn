ENTRY(main)
/* SECTIONS
{
    . = 0x1000;
    .text : {*(.text)}
    .data : {*(.data)}
    .bss : {*(.bss)}
} */
SECTIONS
{
    /* 程序起始地址 */
    . = 0x10000;

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
