#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *file;

    unsigned char buffer[16];

    long offset = 0;

    size_t bytesRead;

    int i;

    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    file = fopen(argv[1], "rb");

    if (file == NULL) {
        printf("Error: could not open file.\n");
        return 1;
    }

    while ((bytesRead = fread(buffer, 1, 16, file)) > 0) {
        // Print byte offset
        printf("%08x ", offset);
        // Print hex bytes, padding incomplete rows with spaces
        for (i = 0; i < (int)bytesRead; i++) {
            printf("%02x ", buffer[i]);
        }

        for (i = bytesRead; i < 16; i++) {
            printf("   ");
        }
        // Print ascii column
        printf("|");

        for (i = 0; i < (int)bytesRead; i++) {

            if (isprint(buffer[i])) {
                printf("%c", buffer[i]);
            }
            else {
                printf(".");
            }
        }

        printf("|\n");

        offset += bytesRead;
    }

    fclose(file);

    return 0;
}
