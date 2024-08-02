// hash_table.h
#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <pthread.h>

typedef struct HashTable HashTable;

#ifdef __cplusplus
extern "C" {
#endif

HashTable *initHashTable(void);

void insertHashTable(HashTable *ht, const char *uri);

pthread_mutex_t *searchHashTable(HashTable *ht, const char *uri);

void freeHashTable(HashTable *ht);

#ifdef __cplusplus
}
#endif

#endif // HASH_TABLE_H
