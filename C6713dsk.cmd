/*C6713dsk.cmd  Linker command file*/
/* make sure to force far in Build option when compile, i.e., choose Complier--> Advanced à Memory Model à Far(mem_model=far). */

-heap	0x400
-stack	0x400 /* very large stack for DSP programs, added by Rosa Zheng*/
-lrts6700.lib

MEMORY
{
  IVECS:    org=0h,  		len=0x220
  IRAM:		org=0x00000220,	len=0x0002FDE0 /*internal memory*/
  SDRAM:	org=0x80000000, len=0x00100000 /*external memory*/
  FLASH:	org=0x90000000, len=0x00020000 /*flash memory*/                    
}

SECTIONS
{
  .EXT_RAM :> SDRAM
  .vectors :> IVECS	/*in vector file*/
  .vecs    :> IVECS	/* added by Rosa Zheng*/
  .text    :> IRAM	/*Created by C Compiler*/
  .bss     :> IRAM
  .cinit   :> IRAM
  .stack   :> IRAM
  .sysmem  :> IRAM
  .const   :> IRAM
  .switch  :> IRAM
  .far     :> IRAM
  .cio     :> IRAM
  .csldata :> IRAM
}