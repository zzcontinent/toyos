#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>

typedef int bool;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

#define ELF_MAGIC 0x464C457FU

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

void print_elf(struct elfhdr* elf_head)
{
	if (elf_head->e_magic != ELF_MAGIC) {
		fprintf(stderr, "bad elf magic!\r\n\n");
		return;
	}
	struct proghdr *ph, *eph;
	ph = (struct proghdr*)((uint32_t)elf_head + elf_head->e_phoff);
	eph = ph + elf_head->e_phnum;
	for (; ph < eph; ph++) {
		printf("ph:%lx, ph_va:%lx, ph_memsz:%lx, ph_offset:%lx\r\n", ph, ph->p_va, ph->p_memsz, ph->p_offset);
	}
}

int main(int argc, char* argv[])
{
	struct stat st;
	if (argc != 2) {
		fprintf(stderr, "Usage: <input file>\n");
		return -1;
	}
	if (stat(argv[1], &st) != 0) {
		fprintf(stderr, "open file error: %s : %s \n", argv[1], strerror(errno));
		return -1;
	}
	printf("%s size: %lld bytes\n", argv[1], (long long)st.st_size);

	void* buf = malloc(st.st_size);
	memset(buf, 0, st.st_size);
	FILE* fp_in = fopen(argv[1], "rb");
	int size = fread(buf, 1, st.st_size, fp_in);
	if (size != st.st_size) {
		fprintf(stderr, "read %s error, size diff %d vs. %d\n", argv[1], st.st_size, size);
		return -1;
	}
	print_elf(buf);
}
