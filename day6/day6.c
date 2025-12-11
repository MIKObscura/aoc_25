#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

void rmspaces(char *str) {
    int count = 0;
    for (int i = 0; str[i]; i++) {
        if (str[i] != ' ') {
            str[count++] = str[i];
        }
    }
    str[count] = '\0';
}

long applyop(char op, int **nums, int column, int total_lines){
    long long total = nums[0][column];

    for(int i = 1; i < total_lines; i++){
        if(op == '+'){
            total += (long long) nums[i][column];
        } else if(op == '*'){
            total *= (long long) nums[i][column];
        }
    }
    return total;
}

int main(int argc, char* argv[]){
    char * buffer = 0;
    long length;
    FILE * f = fopen ("input.txt", "r");

    if (f){
        fseek (f, 0, SEEK_END);
        length = ftell (f);
        fseek (f, 0, SEEK_SET);
        buffer = malloc (length + 1);
        if (buffer){
            fread (buffer, 1, length, f);
        }
        fclose (f);
    }
    buffer[length] = '\0';
    char *line;
    char *save_ptr = buffer;
    int total_lines = 0;
    char **lines = (char **) malloc(sizeof(char *));
    while((line = strtok_r(save_ptr, "\n", &save_ptr))){
        lines[total_lines] = line;
        total_lines++;
        lines = reallocarray(lines, total_lines + 1, sizeof(char *));
    }
    rmspaces(lines[total_lines - 1]);
    int columns = strlen(lines[total_lines - 1]);

    int **nums = (int **) malloc(sizeof(int *));
    char *operators = lines[total_lines - 1];

    regex_t regex;
    regoff_t offset, size;
    const char* pattern = "[[:digit:]]+";
    regcomp(&regex, pattern, REG_EXTENDED);
    for(int i = 0; i < total_lines - 1; i++){
        regmatch_t pmatch[columns];
        int ret;
        char *s = lines[i];
        nums[i] = (int *) malloc(sizeof(int) * columns);
        for(int ii = 0; ii < columns; ii++){
            ret = regexec(&regex, s, 1, pmatch, 0);
            int matchln = pmatch[0].rm_eo - pmatch[0].rm_so;
            char matchstr[matchln + 1];
            strncpy(matchstr, s + pmatch[0].rm_so, matchln);
            matchstr[matchln] = '\0';
            nums[i][ii] = atoi(matchstr);
            s += pmatch[0].rm_eo;
        }
        nums = reallocarray(nums, i + 1, (sizeof(int) * columns) * (i + 1));
    }

    long long total = 0;
    for(int i = 0; i < columns; i++){
        total += applyop(operators[i], nums, i, total_lines - 1);
    }
    printf("%lld", total);
}