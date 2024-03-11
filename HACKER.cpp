//C code for hacking binary file and changing bytes directly

#include <stdio.h>

int main(int argc, char *argv[])
{
        if (argc != 2) 
        {
                printf("Where is my file...Where is my file...\nEEEE\n");
                return 1;
        }
        char * filename = argv[1];
        int jump = 0xEB;
        int addr = 0x1A;
        int nop  = 0x90;
        FILE *fp = fopen(filename, "r+b");
        if (!fp) 
        {
                printf("Error in opening file\n");
                return 1;
        }
        fseek(fp, 7, SEEK_SET);
        fputc(jump, fp);
        fputc(addr, fp);
        fputc(nop,  fp);
        return 0;
}