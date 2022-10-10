#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

int main(int argc, char* argv[])
{
	struct stat st;
	if (argc != 3) {
		fprintf(stderr, "Usage: <input file> <output file>\n");
	}
	if (stat(argv[1], &st) != 0) {
		fprintf(stderr, "open file error: %s : %s \n", argv[1], strerror(errno));
	}
	printf("%s size: %lld bytes\n", argv[1], (long long)st.st_size);
	if (st.st_size > 510) {
		fprintf(stderr, "%lld > 510!\n", (long long)st.st_size);
		return -1;
	}
	char buf[512];
	memset(buf, 0, sizeof(buf));
	FILE* fp_in = fopen(argv[1], "rb");
	int size = fread(buf, 1, st.st_size, fp_in);
	if (size != st.st_size) {
		fprintf(stderr, "read %s error, size diff %ld vs. %d\n", argv[1], st.st_size, size);
		return -1;
	}
	fclose(fp_in);
	buf[510] = 0x55;
	buf[511] = 0xAA;
	FILE* fp_out = fopen(argv[2], "wb+");
	size = fwrite(buf, 1, 512, fp_out);
	if (size != 512) {
		fprintf(stderr, "write %s error, size diff %d vs. %d\n", argv[2], 512, size);
	}
	fclose(fp_out);
	printf("build 512 bytes for boot sector: %s success!\n", argv[2]);
	return 0;
}
