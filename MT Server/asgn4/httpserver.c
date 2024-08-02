#define REGexec                                                                                    \
    "^([a-zA-Z]{1,8}) +(/[a-zA-Z0-9._]{2,64}) (HTTP/[0-9].[0-9])\r\n(([a-zA-Z0-9.-]+: "            \
    "[^\r\n]{0,128})\r\n)*\r\n"

#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "queue.h"
#include "rwlock.h"
#include "debug.h"
#include "asgn2_helper_funcs.h"
#include <regex.h>
#include "hash_table.h"
#define DEFAULT_THREAD_COUNT 4
#define MAX_PORT             65535
#define MIN_PORT             1
#define buffersize           2048
#define MAX_BUFFER_SIZE      2048
HashTable *ht; // Global HashTable pointer
//added assignment 2 in previous push
queue_t *q;

void reply(int response_fd, int status_code) {
    const char *status_phrase;
    const char *message_body;

    switch (status_code) {
    case 200: status_phrase = "OK"; message_body = "OK\n";
    case 201:
        status_phrase = "Created";
        message_body = "Created\n";
        break;
    case 500:
        status_phrase = "Internal Server Error";
        message_body = "Internal Server Error\n";
        break;
    case 501:
        status_phrase = "Not Implemented";
        message_body = "Not Implemented\n";
        break;
    case 505:
        status_phrase = "Version Not Supported";
        message_body = "Version Not Supported\n";
        break;
    }

    char header[256];
    int header_len
        = snprintf(header, sizeof(header), "HTTP/1.1 %d %s\r\nContent-Length: %zu\r\n\r\n",
            status_code, status_phrase, strlen(message_body));
    write_n_bytes(response_fd, header, header_len);
    write_n_bytes(response_fd, (char *) message_body, strlen(message_body));
}

ssize_t pass_b_bytes(int src_fd, int dst_fd, size_t n_bytes) {
    ssize_t total_bytes_transferred = 0;
    char buffer[4096];

    while (n_bytes > 0) {
        ssize_t bytes_read
            = read(src_fd, buffer, (n_bytes > sizeof(buffer)) ? sizeof(buffer) : n_bytes);
        if (bytes_read <= 0) {
            if (bytes_read == 0) {
                break; // End of data
            } else {
                return -1; // Error reading from source
            }
        }

        ssize_t bytes_written = write(dst_fd, buffer, bytes_read);
        if (bytes_written != bytes_read) {
            return -1; // Error writing to destination
        }

        n_bytes -= bytes_read;
        total_bytes_transferred += bytes_read;
    }

    return total_bytes_transferred;
}

void extract_content_length(const char *request, int *content_length) {

    const char *head = strstr(request, "Content-Length:");
    if (!head) {
        *content_length = -1;
        return;
    }

    const char *var = strchr(head, ':');
    if (!var) {
        *content_length = -1;
        return;
    }
    var += 1;

    while (*var == ' ') {
        var++;
    }

    *content_length = atoi(var);
}
int extract_request_id(const char *header_field, int *request_id) {
    const char *requestIdStr = "Request-Id: ";
    char *found = strstr(header_field, requestIdStr);
    if (found) {
        sscanf(found + strlen(requestIdStr), "%d", request_id);
        return 0; // Found and parsed
    }
    return -1; // Not found
}

int parse(const char *command, char **method, char **uri, char **http_version, char **header_field,
    char **message_body, int *request_id, int *content_length) {
    regex_t preg;
    regmatch_t pmatch[7];
    if (regcomp(&preg, REGexec, REG_EXTENDED) != 0) {
        fdebug(stderr, "Failed to compile regular expression");
        return -1;
    }

    int regx = regexec(&preg, command, 7, pmatch, 0);
    if (regx != 0) {
        fdebug(stderr, "Failed to match regular expression");
        regfree(&preg);
        return -1;
    }

    // Method
    int method_len = pmatch[1].rm_eo - pmatch[1].rm_so;
    *method = (char *) malloc(method_len + 1);
    if (method_len + 1 > MAX_BUFFER_SIZE) {

        return -1;
    }
    snprintf(*method, method_len + 1, "%.*s", method_len, command + pmatch[1].rm_so);

    // URI
    int uri_len = pmatch[2].rm_eo - pmatch[2].rm_so;
    *uri = (char *) malloc(uri_len + 1);
    if (*uri == NULL) {
        fdebug(stderr, "Memory allocation failed for URI");
        free(*method);
        regfree(&preg);
        return -1;
    }
    snprintf(*uri, uri_len + 1, "%.*s", uri_len, command + pmatch[2].rm_so);

    // HTTP version
    int vers_len = pmatch[3].rm_eo - pmatch[3].rm_so;
    *http_version = (char *) malloc(vers_len + 1);
    if (*http_version == NULL) {
        fdebug(stderr, "Memory allocation failed for HTTP version");
        free(*method);
        free(*uri);
        regfree(&preg);
        return -1;
    }
    snprintf(*http_version, vers_len + 1, "%.*s", vers_len, command + pmatch[3].rm_so);
    char *header_end = strstr(command, "\r\n\r\n");
    if (header_end == NULL) {
        // Invalid request format
        fdebug(stderr, "Failed to find header end");
        regfree(&preg);
        free(*method);
        free(*uri);
        free(*http_version);
        return -1;
    }
    int headers_len = header_end - command;
    *header_field = (char *) malloc(headers_len + 1);
    if (*header_field == NULL) {
        fdebug(stderr, "Memory allocation failed for header field");
        free(*method);
        free(*uri);
        free(*http_version);
        regfree(&preg);
        return -1;
    }
    strncpy(*header_field, command, headers_len);
    (*header_field)[headers_len] = '\0';

    // Extract Request-Id
    int request_id_value = -1;
    if (extract_request_id(*header_field, &request_id_value) == 0) {
        // Request-Id header found and parsed successfully
        *request_id = request_id_value;
    } else {
        // Request-Id header not found
        *request_id = -1;
    }

    // Extract Content-Length
    extract_content_length(*header_field, content_length);

    // Message Body
    char *message_body_start = header_end + 4; // Skip the "\r\n\r\n"
    int message_body_len = strlen(message_body_start);
    *message_body = (char *) malloc(message_body_len + 1);
    if (*message_body == NULL) {
        fdebug(stderr, "Memory allocation failed for message body");
        free(*method);
        free(*uri);
        free(*http_version);
        free(*header_field);
        regfree(&preg);
        return -1;
    }
    strcpy(*message_body, message_body_start);

    regfree(&preg);
    return 0;
}
int checker(int socket, const char *method, const char *http_version) {
    if (strcmp(http_version, "HTTP/1.1") != 0) {
        reply(socket, 505); // Version Not Supported
        return 505;
    }

    if (strcmp(method, "GET") != 0 && strcmp(method, "PUT") != 0) {
        reply(socket, 501); // no other methods
        return 501;
    }

    return 0;
}
void audit_log(const char *requestt, const char *uri, int status_code, int request_id) {
    printf("Logging Request-Id: %d\n", request_id);
    if (request_id == -1) {
        fprintf(stderr, "%s,%s,%d,\n", requestt, uri, status_code);
    } else {
        fprintf(stderr, "%s,%s,%d,%d\n", requestt, uri, status_code, request_id);
    }
    return;
}
void GET_OR_PUT(int socket) {
    char buffer[buffersize];
    memset(buffer, 0, sizeof(buffer));
    ssize_t received = read_until(socket, buffer, sizeof(buffer), "\r\n\r\n");
    if (received <= 0) {
        reply(socket, 400); // Bad Request
        return;
    }
    int request_id = 0;
    char *method, *uri, *http_version, *header_field, *message_body;
    int content_length = 0;
    if (parse(buffer, &method, &uri, &http_version, &header_field, &message_body, &request_id,
            &content_length)
        != 0) {
        char header[256];
        snprintf(header, sizeof(header), "HTTP/1.1 400 Bad Request\r\nContent-Length: 12\r\n\r\n");
        write_n_bytes(socket, header, strlen(header));
        write_n_bytes(socket, "Bad Request\n", 12);
        free(method);
        free(uri);
        free(http_version);
        free(header_field);
    }
    int check_result = checker(socket, method, http_version);
    if (check_result != 0) {

        return;
    }

    if (strcmp(method, "GET") == 0) {

        pthread_mutex_t *uri_lock = searchHashTable(ht, uri);
        if (uri_lock) {
            pthread_mutex_lock(uri_lock); // Lock for thread-safe access
        }

        // Construct the file path and attempt to open the file
        char filepath[1024];
        snprintf(filepath, sizeof(filepath), ".%s", uri);
        int file_fd = open(filepath, O_RDONLY);
        if (file_fd < 0) {
            char header[256];
            snprintf(header, sizeof(header),
                "HTTP/1.1 404 Not Found\r\nContent-Length: 10\r\n\r\nNot Found\n");
            write_n_bytes(socket, header, strlen(header));
            write_n_bytes(socket, "Not Found\n", 9);

            audit_log("GET", uri, 404, request_id);
        } else {
            //  file found and opened
            struct stat file_stat;
            if (fstat(file_fd, &file_stat) >= 0) {
                char header[256];
                snprintf(header, sizeof(header), "HTTP/1.1 200 OK\r\nContent-Length: %ld\r\n\r\n",
                    file_stat.st_size);
                write_n_bytes(socket, header, strlen(header));
                pass_n_bytes(file_fd, socket, file_stat.st_size);
                audit_log("GET", uri, 200, request_id);
            } else {
                // Error obtaining file stats
                reply(socket, 500);
                audit_log("GET", uri, 500, request_id);
            }
            pass_n_bytes(file_fd, socket, file_stat.st_size);
            close(file_fd);
        }

        if (uri_lock) {
            pthread_mutex_unlock(uri_lock); // Unlock after done with the resource
        }

    } else if (strcmp(method, "PUT") == 0) {
        if (content_length <= 0) {
            char header[256];
            snprintf(
                header, sizeof(header), "HTTP/1.1 400 Bad Request\r\nContent-Length: 12\r\n\r\n");
            write_n_bytes(socket, header, strlen(header));
            write_n_bytes(socket, "Bad Request\n", 12);
            audit_log("PUT", uri, 400, request_id);
            return;
        }

        char uri_file[1024];
        snprintf(uri_file, sizeof(uri_file), ".%s", uri);

        // Check if the file exists before attempting to open/create it
        struct stat file_stat;
        int file_exists = stat(uri_file, &file_stat) == 0;
        off_t original_file_size = file_exists ? file_stat.st_size : 0;

        int file_fd = open(uri_file, O_WRONLY | O_CREAT | O_TRUNC, 0666);
        if (file_fd < 0) {
            audit_log("PUT", uri, 404, request_id);
            return;
        }

        char *body_start = strstr(buffer, "\r\n\r\n") + 4;
        size_t initial_body_size = received - (body_start - buffer);
        if (initial_body_size > 0 && initial_body_size <= (size_t) content_length) {
            if (write_n_bytes(file_fd, body_start, initial_body_size) < 0) {
                reply(socket, 500); // Internal Server Error
                close(file_fd);
                return;
            }
        }

        size_t remaining_content_length = content_length - initial_body_size;
        if (remaining_content_length > 0) {
            if (pass_b_bytes(socket, file_fd, remaining_content_length) < 0) {
                reply(socket, 500); // Internal Server Error
                close(file_fd);
                return;
            }
        }

        // Send the correct response based on whether the file was newly created or its content was modified
        off_t new_file_size = 0;
        if (fstat(file_fd, &file_stat) >= 0) {
            new_file_size = file_stat.st_size;
        }

        if (!file_exists && new_file_size > 0) {
            char header[256];
            snprintf(header, sizeof(header),
                "HTTP/1.1 201 Created\r\nContent-Length: 8\r\n\r\nCreated\n");
            write_n_bytes(socket, header, strlen(header));
            audit_log("PUT", uri, 201, request_id);
        } else if (file_exists && new_file_size != original_file_size) {
            char header[256];
            snprintf(header, sizeof(header), "HTTP/1.1 200 OK\r\nContent-Length: 3\r\n\r\nOK\n");
            write_n_bytes(socket, header, strlen(header));
            audit_log("PUT", uri, 200, request_id);
        } else {
            // No changes made to the file
            char header[256];
            snprintf(header, sizeof(header), "HTTP/1.1 200 OK\r\nContent-Length: 3\r\n\r\nOK\n");
            write_n_bytes(socket, header, strlen(header));
            audit_log("PUT", uri, 200, request_id);
        }

        // Read and discard any remaining data from the client
        char discard_buffer[4096];
        ssize_t bytes_read;
        do {
            bytes_read = recv(socket, discard_buffer, sizeof(discard_buffer), 0);
            // Discard the data by doing nothing with it
        } while (bytes_read > 0);

        close(file_fd);
    }
}

void *worker(void *arg) {
    (void) arg;
    while (1) {
        int *socket;
        if (queue_pop(q, (void **) &socket) && socket != NULL) {
            GET_OR_PUT(*socket);
            close(*socket);
            free(socket);
        }
    }
    return NULL;
}

int main(int argc, char *argv[]) {

    int port = 0, threads = DEFAULT_THREAD_COUNT, opt;
    while ((opt = getopt(argc, argv, "t:")) != -1) {
        switch (opt) {
        case 't':
            threads = atoi(optarg);
            if (threads <= 0) {
                fprintf(stderr, "need threads\n");
                return EXIT_FAILURE;
            }
            break;
        default: fprintf(stderr, "Usage: %s [-t threads] port\n", argv[0]); return EXIT_FAILURE;
        }
    }

    if (optind < argc) {
        port = atoi(argv[optind]);
        if (port < MIN_PORT || port > MAX_PORT) {
            fprintf(stderr, "Invalid Port\n");
            return 1;
        }
    } else {
        fprintf(stderr, "Port number not specified.\n");
        return EXIT_FAILURE;
    }

    signal(SIGPIPE, SIG_IGN);
    q = queue_new(threads * 2);
    ht = initHashTable();

    Listener_Socket listener_socket;
    if (listener_init(&listener_socket, port) != 0) {
        perror("error w listener");
        return EXIT_FAILURE;
    }

    pthread_t *thread_pool = malloc(threads * sizeof(pthread_t));
    for (int i = 0; i < threads; ++i) {
        if (pthread_create(&thread_pool[i], NULL, worker, NULL) != 0) {
            perror("error w threadpool");
            exit(EXIT_FAILURE);
        }
    }

    while (1) {
        int *socket = malloc(sizeof(int));
        *socket = listener_accept(&listener_socket);
        /* if (*socket < 0 || !run_server) {
            free(socket);
            continue;
        }*/
        if (!queue_push(q, socket)) {
            close(*socket);
            free(socket);
        }
    }

    // Cleanup logic
    for (int i = 0; i < threads; ++i) {
        pthread_join(thread_pool[i], NULL);
    }
    free(thread_pool);
    queue_delete(&q);
    freeHashTable(ht);
    close(listener_socket.fd);
    return EXIT_SUCCESS;
}
