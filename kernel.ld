ENTRY(boot)

SECTIONS {
    . = 0x80200000;            /* sets the starting address (2gb + 2mb) */

    .text :{                    /*executable code*/
        KEEP(*(.text.boot));
        *(.text .text.*);
    }

    .rodata : ALIGN(4) {        /* read-only data */
        *(.rodata .rodata.*);
    }

    .data : ALIGN(4) {          /*initialized variables*/
        *(.data .data.*);
    }

    .bss : ALIGN(4) {           /*uninitialized variables, block started by symbol*/
        __bss = .;
        *(.bss .bss.* .sbss .sbss.*);
        __bss_end = .;
    }

    . = ALIGN(4);               /*stack allocation*/
    . += 128 * 1024; /* 128KB */
    __stack_top = .;
}

/* entry(boot) declares that the bot functino is the entry point of the program, and then the placement of each section is defined within the sections block
 * the .text directive places the .text section an any sections starting with .text from all files * at that location 
 * 
 * The . symbol represents the current address. It automatically increments as data is placed, such as with *(.text). The statement . += 128 * 1024 means "advance the current address by 128KB". 
 * The ALIGN(4) directive ensures that the current address is adjusted to a 4-byte boundary.
 *
 *
 *
 *
 *
 *
 *
 *
 */