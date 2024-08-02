//logic and debugging by chat gpt

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash_table.h"
#include "rwlock.h"

#define HASH_TABLE_SIZE 256

typedef struct HashNode {
    char *uri;
    pthread_mutex_t lock;
    struct HashNode *next;
} HashNode;

typedef struct HashTable {
    HashNode *buckets[HASH_TABLE_SIZE];
    rwlock_t *rwlock;
} HashTable;

// Simple hash function for demonstration
unsigned int hash(const char *uri) {
    unsigned long hash = 5381;
    int c;
    while ((c = *uri++))
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    return hash % HASH_TABLE_SIZE;
}

HashTable *initHashTable(void) {
    HashTable *ht = malloc(sizeof(HashTable));
    if (!ht) {
        // Handle allocation failure if necessary
        return NULL;
    }

    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        ht->buckets[i] = NULL;
    }
    ht->rwlock = rwlock_new(N_WAY, 1);

    return ht;
}
void freeHashTable(HashTable *ht) {
    rwlock_delete(&ht->rwlock);
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        HashNode *node = ht->buckets[i];
        while (node != NULL) {
            HashNode *temp = node;
            node = node->next;
            free(temp->uri);
            pthread_mutex_destroy(&temp->lock);
            free(temp);
        }
    }
}

void insertHashTable(HashTable *ht, const char *uri) {
    unsigned int index = hash(uri);
    writer_lock(ht->rwlock);

    // Search for an existing node for the URI
    HashNode *current = ht->buckets[index];
    while (current != NULL) {
        if (strcmp(current->uri, uri) == 0) {
            // URI already exists, no need to insert a new one
            writer_unlock(ht->rwlock);
            return;
        }
        current = current->next;
    }

    HashNode *newNode = (HashNode *) malloc(sizeof(HashNode));
    if (!newNode) {
        perror("Failed to allocate memory for new hash node");
        exit(EXIT_FAILURE);
    }
    newNode->uri = strdup(uri);
    if (!newNode->uri) {
        perror("Failed to duplicate URI string");
        free(newNode);
        exit(EXIT_FAILURE);
    }
    pthread_mutex_init(&newNode->lock, NULL); // Initialize the mutex for this URI
    newNode->next = ht->buckets[index]; // Insert at the beginning
    ht->buckets[index] = newNode;

    writer_unlock(ht->rwlock);
}

pthread_mutex_t *searchHashTable(HashTable *ht, const char *uri) {
    unsigned int index = hash(uri);
    reader_lock(ht->rwlock);

    HashNode *node = ht->buckets[index];
    while (node != NULL) {
        if (strcmp(node->uri, uri) == 0) {
            reader_unlock(ht->rwlock);
            return &node->lock;
        }
        node = node->next;
    }

    reader_unlock(ht->rwlock);
    return NULL; // URI not found
}
