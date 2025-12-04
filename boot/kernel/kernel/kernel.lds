ENTRY(kernel_main);
PHDRS
{
/*headers PT_PHDR FILEHDR PHDRS;*/
headers PT_LOAD FILEHDR PHDRS FLAGS(4);
code PT_LOAD FLAGS(5);
}
SECTIONS
{
.text 0x100000: {
    *(.start) 
    *(.text) 
    } :code
.data : { *(.data) }
.bss : { *(.bss) }
/DISCARD/ : { *(.eh_frame) }
}