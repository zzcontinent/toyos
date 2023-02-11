#ifndef  __DIR_H__
#define  __DIR_H__

#include <libs/defs.h>
#include <lbs/dirent.h>

typedef struct {
	int fd;
	struct dirent dirent;
} DIR;

DIR *opendir(const char *path);
struct dirent *readdir(DIR *dirp);
void closedir(DIR *dirp);
int chdir(const char *path);
int getcwd(char *buffer, size_t len);

#endif  /* __DIR_H__ */
