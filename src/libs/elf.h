#ifndef __LIBS_ELF_H__
#define __LIBS_ELF_H__
#include <defs.h>

#define ELF_MAGIC 0x464C457FU

// values for proghdr::p_type
#define ELF_PT_LOAD 1

// flag bits for proghdr::p_flags
#define ELF_PF_X 1
#define ELF_PF_W 2
#define ELF_PF_R 4

struct elfhdr {
    uint32_t e_magic; // must equal ELF_MAGIC
    uint8_t e_elf[12];
    uint16_t e_type;	  // 1=relocatable, 2=executable, 3=shared object, 4=core image
    uint16_t e_machine;	  // 3=x86, 4=68K, etc.
    uint32_t e_version;	  // file version = 1
    uint32_t e_entry;	  // entry point if executable
    uint32_t e_phoff;	  // program header offset
    uint32_t e_shoff;	  // section header offset
    uint32_t e_flags;	  // architecture-specific flags = 0
    uint16_t e_ehsize;	  // elf header size
    uint16_t e_phentsize; // program header entry size
    uint16_t e_phnum;	  // program header number
    uint16_t e_shentsize; // section header entry size
    uint16_t e_shnum;	  // section header number
    uint16_t e_shstrndx;  // section header name string index
};

struct proghdr {
    uint32_t p_type;   // loadable code or data, dynamic linking info, etc.
    uint32_t p_offset; // file segment offset
    uint32_t p_va;     // virtual address to map segment
    uint32_t p_pa;     // physical address, not used
    uint32_t p_filesz; // size of segment in file
    uint32_t p_memsz;  // size of segment in memory (bigger if contains bss)
    uint32_t p_flags;  // read/write/execut bits
    uint32_t p_align;  // required alignment, invariably hardware page size
};

#endif
