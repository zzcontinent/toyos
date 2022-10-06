#ifndef __LIBS_ELF_H__
#define __LIBS_ELF_H__
#include <libs/defs.h>

#define ELF_MAGIC 0x464C457FU

// values for proghdr::p_type
#define ELF_PT_LOAD 1

// flag bits for proghdr::p_flags
#define ELF_PF_X 1
#define ELF_PF_W 2
#define ELF_PF_R 4

struct elfhdr {
    u32 e_magic; // must equal ELF_MAGIC
    u8 e_elf[12];
    u16 e_type;	  // 1=relocatable, 2=executable, 3=shared object, 4=core image
    u16 e_machine;	  // 3=x86, 4=68K, etc.
    u32 e_version;	  // file version = 1
    u32 e_entry;	  // entry point if executable
    u32 e_phoff;	  // program header offset
    u32 e_shoff;	  // section header offset
    u32 e_flags;	  // architecture-specific flags = 0
    u16 e_ehsize;	  // elf header size
    u16 e_phentsize; // program header entry size
    u16 e_phnum;	  // program header number
    u16 e_shentsize; // section header entry size
    u16 e_shnum;	  // section header number
    u16 e_shstrndx;  // section header name string index
};

struct proghdr {
    u32 p_type;   // loadable code or data, dynamic linking info, etc.
    u32 p_offset; // file segment offset
    u32 p_va;     // virtual address to map segment
    u32 p_pa;     // physical address, not used
    u32 p_filesz; // size of segment in file
    u32 p_memsz;  // size of segment in memory (bigger if contains bss)
    u32 p_flags;  // read/write/execut bits
    u32 p_align;  // required alignment, invariably hardware page size
};

#endif
