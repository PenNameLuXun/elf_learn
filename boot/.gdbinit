set architecture i8086
target remote localhost:26000
layout asm
layout reg
b *0x7c00
define hook-stop
    # Translate the segment:offset into a physical address
    #printf "[%4x:%4x] ", $cs, $eip
    #x/i $cs*16+$eip
    #set architecture i8086
    #target remote localhost:26000
end
