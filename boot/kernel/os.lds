ENTRY(kernel_entry16);
PHDRS
{
/*headers PT_PHDR FILEHDR PHDRS;*/
headers PT_LOAD FILEHDR PHDRS FLAGS(4);
code PT_LOAD FLAGS(5);
}
SECTIONS
{
.text 0x600:ALIGN(0x100) { *(.text) } :code
.data : { *(.data) }
.bss : { *(.bss) }
/DISCARD/ : { *(.eh_frame) }
}