is_twin_num <- function(n) {
    num_str <- toString(n)
    num_first_half <- as.numeric(substr(num_str, 1, nchar(num_str) / 2))
    num_sec_half <- as.numeric(substr(num_str, (nchar(num_str) / 2) + 1, nchar(num_str)))
    num_first_half == num_sec_half
}

get_twin_nums <- function(range) {
    range_split <- strsplit(toString(range), "-")[[1]]
    start <- as.numeric(range_split[[1]])
    end <- as.numeric(range_split[[2]])
    twins <- list()
    for (n in c(start:end)){
        if (nchar(toString(n)) %% 2 != 0) next
        if(is_twin_num(n)) twins[length(twins) + 1] <- as.numeric(n)
    }
    twins
}

input_file <- "day2/input.txt"
input <- read.table(input_file, header = FALSE, sep = ",")

sum <- as.numeric(0)
for (i in c(1:length(input))){
    twins <- get_twin_nums(input[[i]])
    if(length(twins) == 0) next
    sum <- sum + Reduce("+", twins)
}
print(sum)