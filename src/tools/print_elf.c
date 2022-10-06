#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <string.h>
#include <elf.h>

typedef int bool;
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long u64;

#define ELF_MAGIC 0x464C457FU

// flag bits for proghdr::p_flags
#define ELF_PF_X 1
#define ELF_PF_W 2
#define ELF_PF_R 4

struct elfhdr32 {
	u32 e_magic;             // must equal ELF_MAGIC
	u8 e_elf[12];
	u16 e_type;             // 1=relocatable, 2=executable, 3=shared object, 4=core image
	u16 e_machine;             // 3=x86, 4=68K, etc.
	u32 e_version;             // file version = 1
	u32 e_entry;             // entry point if executable
	u32 e_phoff;             // program header offset
	u32 e_shoff;             // section header offset
	u32 e_flags;             // architecture-specific flags = 0
	u16 e_ehsize;             // elf header size
	u16 e_phentsize;         // program header entry size
	u16 e_phnum;             // program header number
	u16 e_shentsize;         // section header entry size
	u16 e_shnum;             // section header number
	u16 e_shstrndx;          // section header name string index
};

struct proghdr32 {
	u32 p_type;      // loadable code or data, dynamic linking info, etc.
	u32 p_offset;    // file segment offset
	u32 p_va;            // virtual address to map segment
	u32 p_pa;            // physical address, not used
	u32 p_filesz;    // size of segment in file
	u32 p_memsz;     // size of segment in memory (bigger if contains bss)
	u32 p_flags;     // read/write/execut bits
	u32 p_align;     // required alignment, invariably hardware page size
};

struct elfhdr64 {
	u32 e_magic;    // must equal ELF_MAGIC
	u8 e_elf[12];
	u16 e_type;             // 1=relocatable, 2=executable, 3=shared object, 4=core image
	u16 e_machine;             // 3=x86, 4=68K, etc.
	u32 e_version;             // file version = 1
	u64 e_entry;             // entry point if executable
	u64 e_phoff;             // program header offset
	u64 e_shoff;             // section header offset
	u32 e_flags;             // architecture-specific flags = 0
	u16 e_ehsize;             // elf header size
	u16 e_phentsize;    // program header entry size
	u16 e_phnum;             // program header number
	u16 e_shentsize;    // section header entry size
	u16 e_shnum;             // section header number
	u16 e_shstrndx;     // section header name string index
};

struct proghdr64 {
	u32 p_type;      // loadable code or data, dynamic linking info, etc.
	u32 p_offset;    // file segment offset
	u64 p_va;            // virtual address to map segment
	u64 p_pa;            // physical address, not used
	u64 p_filesz;    // size of segment in file
	u64 p_memsz;     // size of segment in memory (bigger if contains bss)
	u64 p_flags;     // read/write/execut bits
	u64 p_align;     // required alignment, invariably hardware page size
};

void print_elf32(struct elfhdr32* elf_head)
{
	if (elf_head->e_magic != ELF_MAGIC) {
		fprintf(stderr, "bad elf magic!\r\n");
		return;
	}
	printf("parsing elf32 ===================================================\r\n");
	printf("[elf header]\r\n");
	printf(
			"e_magic          :   0x%x\r\n"
			"e_elf            :   0x%x%x%x%x%x%x%x%x%x%x%x%x\r\n"
			"e_type           :   0x%x\r\n"
			"e_machine        :   0x%x\r\n"
			"e_version        :   0x%x\r\n"
			"e_entry          :   0x%x\r\n"
			"e_phoff          :   0x%x\r\n"
			"e_shoff          :   0x%x\r\n"
			"e_flags          :   0x%x\r\n"
			"e_ehsize         :   0x%x\r\n"
			"e_phentsize      :   0x%x\r\n"
			"e_phnum          :   0x%x\r\n"
			"e_shentsize      :   0x%x\r\n"
			"e_shnum          :   0x%x\r\n"
			"e_shstrndx       :   0x%x\r\n",
			elf_head->e_magic         ,
			elf_head->e_elf[0]           ,
			elf_head->e_elf[1]           ,
			elf_head->e_elf[2]           ,
			elf_head->e_elf[3]           ,
			elf_head->e_elf[4]           ,
			elf_head->e_elf[5]           ,
			elf_head->e_elf[6]           ,
			elf_head->e_elf[7]           ,
			elf_head->e_elf[8]           ,
			elf_head->e_elf[9]           ,
			elf_head->e_elf[10]          ,
			elf_head->e_elf[11]          ,
			elf_head->e_type          ,
			elf_head->e_machine       ,
			elf_head->e_version       ,
			elf_head->e_entry         ,
			elf_head->e_phoff         ,
			elf_head->e_shoff         ,
			elf_head->e_flags         ,
			elf_head->e_ehsize        ,
			elf_head->e_phentsize     ,
			elf_head->e_phnum         ,
			elf_head->e_shentsize     ,
			elf_head->e_shnum         ,
			elf_head->e_shstrndx      );

	printf("[program header]\r\n");
	struct proghdr32 *ph, *eph;
	ph = (struct proghdr32*)((u64)elf_head + elf_head->e_phoff);
	eph = ph + elf_head->e_phnum;
	for (; ph < eph; ph++) {
		printf(
				"------------------------------\r\n"
				"p_type           :   0x%x\r\n"
				"p_offset         :   0x%x\r\n"
				"p_va             :   0x%x\r\n"
				"p_pa             :   0x%x\r\n"
				"p_filesz         :   0x%x\r\n"
				"p_memsz          :   0x%x\r\n"
				"p_flags          :   0x%x\r\n"
				"p_align          :   0x%x\r\n",
				ph->p_type                       ,
				ph->p_offset                    ,
				ph->p_va                        ,
				ph->p_pa                        ,
				ph->p_filesz                    ,
				ph->p_memsz                     ,
				ph->p_flags                     ,
				ph->p_align                     );
	}
}

void print_elf64(struct elfhdr64* elf_head)
{
	if (elf_head->e_magic != ELF_MAGIC) {
		fprintf(stderr, "bad elf magic!\r\n");
		return;
	}
	printf("parsing elf64 ===================================================\r\n");
	printf("[elf header]\r\n");
	printf(
			"e_magic          :   0x%x\r\n"
			"e_elf            :   0x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\r\n"
			"e_type           :   0x%x\r\n"
			"e_machine        :   0x%x\r\n"
			"e_version        :   0x%x\r\n"
			"e_entry          :   0x%lx\r\n"
			"e_phoff          :   0x%lx\r\n"
			"e_shoff          :   0x%lx\r\n"
			"e_flags          :   0x%x\r\n"
			"e_ehsize         :   0x%x\r\n"
			"e_phentsize      :   0x%x\r\n"
			"e_phnum          :   0x%x\r\n"
			"e_shentsize      :   0x%x\r\n"
			"e_shnum          :   0x%x\r\n"
			"e_shstrndx       :   0x%x\r\n",
			elf_head->e_magic         ,
			elf_head->e_elf[0]           ,
			elf_head->e_elf[1]           ,
			elf_head->e_elf[2]           ,
			elf_head->e_elf[3]           ,
			elf_head->e_elf[4]           ,
			elf_head->e_elf[5]           ,
			elf_head->e_elf[6]           ,
			elf_head->e_elf[7]           ,
			elf_head->e_elf[8]           ,
			elf_head->e_elf[9]           ,
			elf_head->e_elf[10]          ,
			elf_head->e_elf[11]          ,
			elf_head->e_type          ,
			elf_head->e_machine       ,
			elf_head->e_version       ,
			elf_head->e_entry         ,
			elf_head->e_phoff         ,
			elf_head->e_shoff         ,
			elf_head->e_flags         ,
			elf_head->e_ehsize        ,
			elf_head->e_phentsize     ,
			elf_head->e_phnum         ,
			elf_head->e_shentsize     ,
			elf_head->e_shnum         ,
			elf_head->e_shstrndx      );

	printf("[program header]\r\n");
	struct proghdr64 *ph, *eph;
	ph = (struct proghdr64*)((u64)elf_head + elf_head->e_phoff);
	eph = ph + elf_head->e_phnum;
	for (; ph < eph; ph++) {
		printf(
				"------------------------------\r\n"
				"p_type           :   0x%x\r\n"
				"p_offset         :   0x%x\r\n"
				"p_va             :   0x%lx\r\n"
				"p_pa             :   0x%lx\r\n"
				"p_filesz         :   0x%lx\r\n"
				"p_memsz          :   0x%lx\r\n"
				"p_flags          :   0x%lx\r\n"
				"p_align          :   0x%lx\r\n",
				ph->p_type                       ,
				ph->p_offset                    ,
				ph->p_va                        ,
				ph->p_pa                        ,
				ph->p_filesz                    ,
				ph->p_memsz                     ,
				ph->p_flags                     ,
				ph->p_align                     );
	}
}

void print_elf_auto(struct elfhdr32* elf_head)
{
	if (elf_head->e_magic != ELF_MAGIC) {
		fprintf(stderr, "bad elf magic!\r\n");
		return;
	}
	switch (elf_head->e_elf[0]) {
		case 0:
			fprintf(stderr, "bad arch %d!\r\n", elf_head->e_elf[0]);
			return;
		case 1:
			printf("arch32\r\n");
			print_elf32(elf_head);
			break;
		case 2:
			printf("arch64\r\n");
			print_elf64(elf_head);
			break;
		default:
			fprintf(stderr, "bad arch %d!\r\n", elf_head->e_elf[0]);
			break;
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
	u64 size = fread(buf, 1, st.st_size, fp_in);
	if (size != st.st_size) {
		fprintf(stderr, "read %s error, size diff %ld vs. %ld\n", argv[1], st.st_size, size);
		return -1;
	}
	print_elf_auto(buf);
}
