OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(kern_entry)

SECTIONS {
	. = 0xC0100000;
	.text : {
		*(.text .stub .text.* .gnu.linkonce.t.*)
	}
	PROVIDE(etext = .); /* define the 'etext' symbol to this value */

	.rodata : {
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	}

	/* include debugging infomation in kernel memory */
	.stab : {
		PROVIDE(__STAB_BEGIN__ = .);
		*(.stab);
		PROVIDE(__STAB_END__ = .);
		BYTE(0) /* force the linker to allocate space for this section */
	}

	.stabstr : {
		PROVIDE(__STABSTR_BEGIN__ = .);
		*(.stabstr);
		PROVIDE(__STABSTR_END__ = .);
		BYTE(0) /* force the linker to allocate space for this section */
	}

	/* adjust the address for the data segment to the next page */
	. = ALIGN(0x1000);

	/* the data segment */
	.data : {
		*(.data)
	}

	. = ALIGN(0x1000);
	.data.pgdir : {
		*(.data.pgdir)
	}

	PROVIDE(edata = .);
	.bss : {
		*(.bss)
	}
	PROVIDE(end = .);

	/DISCARD/ : {
		*(.eh_frame .note.GNU-stack)
	}
}
