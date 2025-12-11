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

int findlongestline(char **lines, int linenum){
    int longest = 0;
    for(int i = 0; i < linenum; i++){
        if(strlen(lines[i]) >= strlen(lines[longest])){
            longest = i;
        }
    }
    return longest;
}

long applyop(char op, int **nums, int column, int total_lines){
    long total = nums[0][column];

    for(int i = 1; i < total_lines; i++){
        if(op == '+'){
            total += (long) nums[i][column];
        } else if(op == '*'){
            total *= (long) nums[i][column];
        }
    }
    return total;
}

long applyvertop(char op, int *nums){
    long total = nums[0];

    for(int i = 1; i <= (sizeof(nums) / sizeof(int)); i++){
        if(op == '+'){
            total += (long) nums[i];
        } else if(op == '*'){
            total *= (long) nums[i];
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
    char* untrimmedline = (char *) malloc(sizeof(char) * strlen(lines[total_lines - 1]));
    strcpy(untrimmedline, lines[total_lines - 1]);
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
    printf("%lld \n", total);

    int **vertnums = (int **) malloc(sizeof(int *));
    int currop = 0;
    int opsindexes[strlen(operators)];
    for(int i = 0; i < strlen(untrimmedline); i++){
        if(untrimmedline[i] == ' ') continue;
        opsindexes[currop] = i;
        currop++;
    }
    for(int i = 0; i < strlen(operators); i++){
        int opi = opsindexes[i];
        int numlen;
        int *colnums = (int *) malloc(sizeof(int));
        int longestline = findlongestline(lines, total_lines);
        int colnumsi = 0;
        if(i == strlen(operators) - 1){
            numlen = strlen(lines[longestline]) - opi;
        } else{
            numlen = (opsindexes[i+1] - 1) - opi;
        }
        for(int ii = numlen - 1; ii >= 0; ii--){
            char *newnum = (char *) malloc(sizeof(char));
            for(int iii = 0; iii < total_lines - 1; iii++){
                if(strlen(lines[iii]) - 1 < opi + ii){
                    newnum[iii] = ' ';
                    continue;
                }
                newnum[iii] = lines[iii][opi+ii];
            }
            rmspaces(newnum);
            colnums[colnumsi] = atoi(newnum);
            colnumsi++;
            colnums = reallocarray(colnums, colnumsi + 1, sizeof(int));
        }
        vertnums[i] = colnums;
        vertnums = reallocarray(vertnums, i + 2, sizeof(int *));
    }

    long long total2 = 0; // TODO: figure out why the answer is wrong
    for(int i = 0; i < columns; i++){
        total2 += applyvertop(operators[i], vertnums[i]);
    }
    printf("%lld \n", total2);
}