

ENTRY(Reset_Handler)

INCLUDE "export-rom_v03.txt"


MEMORY
{
  TCM (rwx) : ORIGIN = 0x1FFF0000, LENGTH = 65536
  ROM_USED_RAM (rwx)  : ORIGIN = 0x10000bc8, LENGTH = 21560 /* end 0x10006000 */
  RECY_RAM (rwx)  : ORIGIN = 0x10002100, LENGTH = 16128 /* end 0x10006000 */
  BD_RAM (rwx)  : ORIGIN = 0x10006000, LENGTH = 434176
  //RECY_RAM (rwx)  : ORIGIN = 0x10002100, LENGTH = 7936	/* end 0x10004000 */
  //BD_RAM (rwx)  : ORIGIN = 0x10004000, LENGTH = 442368
  SDRAM_RAM (rwx)  : ORIGIN = 0x30000000, LENGTH = 2M
}

EXTERN(PreProcessForVendor)
EXTERN(RtlBootToSram)

SECTIONS
{
  __rom_bss_start__ = 0x10000300;
  __rom_bss_end__ = 0x10000bc8;
  
  .ram.start.table :
  {
    __ram_image1_text_start__ = .;
    __ram_start_table_start__ = .;
    KEEP(*(SORT(.start.ram.data*)))
    KEEP(*(.image1.validate.rodata*))
    __ram_start_table_end__ = .;
    
  } > ROM_USED_RAM

/*  Add . to assign the start address of the section,  
 *  to prevent the change of the start address by ld doing section alignment */  


/* these 4 sections is used by ROM global variable */
  	/* Don't move them and never add RAM code variable to these sections */
  .ram_image1.text :
  {
    __image1_validate_code__ = .;
    *(.infra.ram.data*)
    *(.infra.ram.text*)
    *(.hal.ram.text*)
	*(.hal.flash.text)
	*(.hal.sdrc.text)
    *(.text*)    
    *(.sdram.text*)
	*(.rodata*)
    *(.infra.ram.start*)
    *(.data*)
    *(.hal.ram.data*)
    *(.hal.gpio.data*)
    *(.hal.flash.data*)    
    *(.hal.sdrc.data*)    
    __ram_image1_data_end__ = .;
    __image1_bss_start__ = .;
    .ram.bss$$Base = .;
    *(.bss*)
    *(COMMON)
    __image1_bss_end__ = .;
    __ram_image1_text_end__ = .;
  } > ROM_USED_RAM

  .tcm :
  {
    __tcm_start__ = .;
    *(.tcm.heap)
    __tcm_end__ = .;
  } > TCM
/*
  OVERLAY 0x1FFF0000:
  {
  	.valid
  	{ 
	    *mem.o (.bss*)
	    *memp.o (.bss*)
	    *(.tcm.heap)
  	}
  	.dummy 
  	{ 
	  	__ram_image1_text_start__ = .;
	    __ram_start_table_start__ = .;
	    KEEP(*(SORT(.start.ram.data*)))
	    __ram_start_table_end__ = .;
		__image1_validate_code__ = .;
	    KEEP(*(.image1.validate.rodata*))
	    KEEP(*(.infra.ram.data*))
	    KEEP(*(.timer.ram.data*))
	    KEEP(*(.cutb.ram.data*))
	    KEEP(*(.cutc.ram.data*))
	    KEEP(*(.hal.ram.data*))
	    __image1_bss_start__ = .;
	    .ram_image1.bss$$Base = .;
    	__image1_bss_end__ = .;
    	.ram_image1.bss$$Limit = .;
    	__ram_image1_data_end__ = .;
	    
	    *(.hal.ram.text*)    
	    *(.infra.ram.text*)
  	}
  } > TCM
*/
  .image2.start.table :
  {
    __ram_image2_text_start__ = .;
    __image2_entry_func__ = .;
    .image2.start.table1$$Base = .;
    *(SORT(.image2.ram.data*))
    __image2_validate_code__ = .;
    *(.image2.validate.rodata*)
    *(.custom.validate.rodata*)
  } > BD_RAM

  .ram_image2.text :
  {
    *(.infra.ram.start*)
    *(.mon.ram.text*)
    *(.hal.flash.text*)   
    *(.hal.sdrc.text*)
    *(.hal.gpio.text*)
    *(.fwu.text*)
    *(.text*)    
    *(.sdram.text*)
    *(.p2p.text*)
    *(.wps.text*)
    *(.websocket.text*)
  } > BD_RAM

  .ram_image2.rodata :
  {
	*(.rodata*)
    *(.fwu.rodata*)
    *(.sdram.rodata*)
    *(.p2p.rodata*)
    *(.wps.rodata*)
    *(.websocket.rodata*)
  } > BD_RAM

  .ram.data : 
  {
    __data_start__ = .;
    *(.data*)
    *(.sdram.data*)
    *(.p2p.data*)
    *(.wps.data*)
    *(.websocket.data*)
    __data_end__ = .;
  	__ram_image2_text_end__ = .;    
  } > BD_RAM
  
  .ram.bss :
  {
    __bss_start__ = .;
    .ram.bss$$Base = .;
    *(.hal.flash.data*)    
    *(.hal.sdrc.data*)    
    *(.hal.gpio.data*)
    *(.fwu.data*)
    *(.bss*)
    *(COMMON)
    *(.bdsram.data*)
    *(.sdram.bss*)
    *(.p2p.bss*)
    *(.wps.bss*)
    *(.websocket.bss*)
    __bss_end__ = .;
    .ram.bss$$Limit = .;
  } > BD_RAM

  .bf_data : 
  {
    __buffer_data_start__ = .;
    *(.bfsram.data*)
    __buffer_data_end__ = .;
    
  } > BD_RAM
/*  
  .bf_data2 : 
  {
    __buffer_data_start2__ = .;
    __buffer_data_end2__ = .;
    
  } > RECY_RAM
*/  
  .sdr_text :
  {
    __sdram_data_start__ = .;
  } > SDRAM_RAM

  .sdr_rodata :
  {
  } > SDRAM_RAM

  .sdr_data : 
  {
    __sdram_data_end__ = .;
  } > SDRAM_RAM

  .sdr_bss :
  {
    __sdram_bss_start__ = .;
    __sdram_bss_end__ = .;
  } > SDRAM_RAM

 .heap :
 {
	__end__ = .;
	end = __end__;
	*(.heap*)
	__HeapLimit = .;
 } > BD_RAM

	/* .stack_dummy section doesn't contains any symbols. It is only
	 * used for linker to calculate size of stack sections, and assign
	 * values to stack symbols later */
	.stack_dummy :
	{
		*(.stack)
	} > BD_RAM

	/* Set stack top to end of RAM, and stack limit move down by
	 * size of stack_dummy section */
	__StackTop = ORIGIN(BD_RAM) + LENGTH(BD_RAM);
	__StackLimit = __StackTop - SIZEOF(.stack_dummy);
	PROVIDE(__stack = __StackTop);

	/* Check if data + heap + stack exceeds RAM limit */
	ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")

	.boot.head :
	{
		KEEP(*(.loader.head*))
	}
}
