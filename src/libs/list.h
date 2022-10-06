#ifndef __LIBS_LIST_H__
#define __LIBS_LIST_H__

#ifndef __ASSEMBLER__
#include <libs/defs.h>

/*
 * simple doubly linked list implementation.
 * */

struct list_entry {
	struct list_entry *prev, *next;
};
typedef struct list_entry list_entry_t;

static inline void list_init(list_entry_t *elm) __attribute((always_inline));
static inline void list_add(list_entry_t *listelm, list_entry_t *elm) __attribute((always_inline));
static inline void list_add_before(list_entry_t *listelm, list_entry_t *elm) __attribute((always_inline));
static inline void list_add_after(list_entry_t *listelm, list_entry_t *elm) __attribute((always_inline));
static inline void list_del(list_entry_t *listelm) __attribute((always_inline));
static inline void list_del_init(list_entry_t *listelm) __attribute((always_inline));
static inline bool list_empty(list_entry_t *list) __attribute((always_inline));
static inline list_entry_t * list_next(list_entry_t *listelm) __attribute((always_inline));
static inline list_entry_t * list_prev(list_entry_t *listelm) __attribute((always_inline));
static inline void __list_add(list_entry_t *elm, list_entry_t * prev, list_entry_t* next) __attribute((always_inline));
static inline void __list_del(list_entry_t * prev, list_entry_t* next) __attribute((always_inline));


static inline void list_init(list_entry_t* elm)
{
	elm->prev = elm->next = elm;
}

static inline void __list_add(list_entry_t* insert_elm, list_entry_t* prev, list_entry_t* next)
{
	prev->next = insert_elm;
	next->prev = insert_elm;
	insert_elm->prev = prev;
	insert_elm->next = next;
}

static inline void list_add_before(list_entry_t* listelm, list_entry_t* insert_elm)
{
	__list_add(insert_elm, listelm->prev, listelm);
}

static inline void list_add_after(list_entry_t* listelm, list_entry_t* insert_elm)
{
	__list_add(insert_elm, listelm, listelm->next);
}

static inline void list_add(list_entry_t* listelm, list_entry_t* insert_elm)
{
	list_add_after(listelm, insert_elm);
}

static inline void __list_del(list_entry_t* prev, list_entry_t* next)
{
	prev->next=next;
	next->prev=prev;
}

static inline void list_del(list_entry_t* listelm)
{
	__list_del(listelm->prev, listelm->next);
}

static inline void list_del_init(list_entry_t* listelm)
{
	list_del(listelm);
	list_init(listelm);
}

static inline bool list_empty(list_entry_t* list)
{
	return list->next == list;
}

static inline list_entry_t* list_next(list_entry_t* listelm)
{
	return listelm->next;
}

static inline list_entry_t* list_prev(list_entry_t* listelm)
{
	return listelm->prev;
}

#endif /* !__ASSEMBLER__ */
#endif /* !__LIBS_LIST_H__ */

