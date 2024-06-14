MEMORY
{
	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
	RAM (rwx): ORIGIN = 0x20000000, LENGTH = 20K
}
ENTRY(main);
__reset_stack_pointer = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
	.text : {
		LONG(__reset_stack_pointer);
		LONG(main | 1);
		. += 332;
		*(.text)
		*(.rodata*)
		. = ALIGN(4);
	} > FLASH
	.ARM.exidx : {
		*(.ARM.exidx*)
		. = ALIGN(4);
	} > FLASH
}



