# Functional programming focuses on four constructs:
    ## 1. Data (numbers, strings, etc)
    ## 2. Variables (function arguments)
    ## 3. Functions
    ## 4. Function Applications (evaluating functions given arguments and/or data)

# With functional programming can consider the possibility that can provide a function as an argument to another function,
# and a function can return another function as its result
adder_maker <- function(n){
    function(x){
        n + x
    }
}

# function adder_maker() returns a function with no name
# the function returned adds n to its only argument x
add2 <- adder_maker(2)
add3 <- adder_maker(3)

add2(5)
add3(5)

# Core functional programming functions ----------------------------------
# Functional programming is concerned mostly with lists and vectors

# Map ----------------------------------
# The map family of functions applies a function to the elements of a data structure, usually a list or a vector. 
# The function is evaluated once for each element of the vector with the vector element as the first argument to the function. 
# The return value is the same kind if data structure (a list or vector) 
# but with every element replaced by the result of the function being evaluated with the corresponding element 
# as the argument to the function. 
# In the purrr package the map() function returns a list, 
# while the map_lgl(), map_chr(), and map_dbl() functions return vectors of logical values, strings, or numbers respectively.
library(purrr)
map_chr(c(5, 4, 3, 2, 1), function(x){
    c("one", "two", "three", "four", "five")[x]
})

map_lgl(c(1, 2, 3, 4, 5), function(x){
    x > 3
})

# map_if() function takes it as its arguments a list or vector containing data, a predictate function, and then a function to be applied
# a predictate function is a function that returns TRUE or FALSE for each element in the provided list or vector
# if TRUE, then the function is applied to the corresponding vector element
# map_if() always returns a list
map_if(1:5, function(x){
    x %% 2 == 0
}, function(y){
    y ^ 2
}) %>% unlist()

# map_at() function only applies the provided function to elements of a vector specified by their indexes
# map_at() always return a list
# function is only applied to the first, third, fifth element of the vector provided
map_at(seq(100, 500, 100), c(1, 3, 5), function(x){
    x - 10
}) %>% unlist()

# map2() map a function over two data structures
# first two arguments should be two vectors of the same length, followed by a function which will be evaluated
map2_chr(letters, 1:26, paste)

# pmap() similar to map2(), can map across any number of lists
pmap_chr(list(
    list(1, 2, 3),
    list("one", "two", "three"),
    list("uno", "dos", "tres")
), paste)

# Reduce ----------------------------------
# List or vector reduction iteratively combines the first element of a vector with the second element of a vector, 
# then that combined result is combined with the third element of the vector, and so on until the end of the vector is reached. 
# The function to be applied should take at least two arguments. 
# Where mapping returns a vector or a list, reducing should return a single value. 
reduce(c(1, 3, 5, 7), function(x, y){
    message("x is ", x)
    message("y is ", y)
    message("")
    x + y
})

reduce(letters[1:4], function(x, y){
    message("x is ", x)
    message("y is ", y)
    message("")
    paste0(x, y)
})

# reduce() starts with the first element of a vector and second element and so on
# reduce_right() starts with the last element
reduce_right(letters[1:4], function(x, y){
    message("x is ", x)
    message("y is ", y)
    message("")
    paste0(x, y)
})

# Search ----------------------------------
# contains() returns TRUE if a specified element is present in the vector
contains(letters, "a")
contains(letters, "A")

# detect() takes a vector and a predicate function as arguments and returns the first element of the vector
# for which the predicate function returns TRUE
detect(20:40, function(x){
    x > 22 && x %% 2 == 0
})

# detect_index() function takes the same arguments, however it returns the index of the provided vector 
# which contains the first element that satisfies the predicate function
detect_index(20:40, function(x){
    x > 22 && x %% 2 == 0
})

# Filter ----------------------------------
# keep() only the elements of the vector that satisfy the predicate function are returned
keep(1:20, function(x){
    x %% 2 == 0
})

# discard() only returns elements that don't satisfy the predicate function
discard(1:20, function(x){
    x %% 2 == 0
})

# every() returns TRUE only if every element in the vector satisfies the predicate function
every(1:20, function(x){
    x %% 2 == 0
})

# some() returns TRUE if at least one element in the vector satisfies the predicate function
some(1:20, function(x){
    x %% 2 == 0
})

# Compose ----------------------------------
# compose() combines any number of functions into one function
n_unique <- compose(length, unique)
# same as 
n_unique <- function(x){
    length(unique(x))
}

rep(1:5, 1:5)
n_unique(rep(1:5, 1:5))

# Partial Application ----------------------------------
# allow functions to behave a little like data structures
# can bind some data to the arguments of a function before using that function elsewhere
# partial() will return a function that only takes the unspecified arguments
mult_three_n <- function(x, y, z){
    x * y * z
}
mult_by_15 <- partial(mult_three_n, x=3, y=5)

mult_by_15(z=4)

# Side Effects ----------------------------------
# Side effects of functions occur whenever a function interacts with the “outside world” – reading or writing data, 
# printing to the console, and displaying a graph are all side effects.
# The results of side effects are one of the main motivations for writing code in the first place!
# If want to evaluate a function across a data structure, should use the walk() function
walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,", 
       "not to praise him."), message)

# Recursion ----------------------------------
# Problems can be broken down into simpler parts,
# and then combining those simple answers results in the answers to complex problem
vector_sum_loop <- function(v){
  result <- 0
  for(i in v){
    result <- result + i
  }
  result
}

vector_sum_loop(c(5, 40, 91))
# make it into recursive
vector_sum_rec <- function(v){
    if(length(v) == 1){
        v
    } else {
        v[1] + vector_sum_rec(v[-1])
    }
}

vector_sum_rec(c(5, 40, 91))

# Fibonacci number
fib <- function(n){
    stopifnot(n>0)
    if(n==1){
        0
    } else if (n==2){
        1
    } else {
        fib(n-1) + fib(n-2)
    }
}
# Memoization to speed computation up
# Memoization stores the value of each calculated Fibonacci number in table so that once a number is calculated
# can look up instead of needing to recalculate it
fib_tbl <- c(0, 1, rep(NA, 23))

fib_mem <- function(n){
    stopifnot(n>0)

    if(!is.na(fib_tbl[n])){
        fib_tbl[n]
    } else {
        fib_tbl[n-1] <<- fib_mem(n-1)
        fib_tbl[n-2] <<- fib_mem(n-2)
        fib_tbl[n-1] + fib_mem(n-2)
    }
}

map_dbl(1:12, fib_mem)

# assess whether which function is faster
library(purrr)
library(microbenchmark)
library(tidyr)
library(magrittr)
library(dplyr)

fib_data <- map(1:10, function(x){microbenchmark(fib(x), times = 100)$time})
names(fib_data) <- paste0(letters[1:10], 1:10)
fib_data <- as.data.frame(fib_data)

fib_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))

memo_data <- map(1:10, function(x){microbenchmark(fib_mem(x))$time})
names(memo_data) <- paste0(letters[1:10], 1:10)
memo_data <- as.data.frame(memo_data)

memo_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))

plot(1:10, fib_data$med_time, xlab = "Fibonacci Number", ylab = "Median Time (Nanoseconds)",
     pch = 18, bty = "n", xaxt = "n", yaxt = "n")
axis(1, at = 1:10)
axis(2, at = seq(0, 350000, by = 50000))
points(1:10 + .1, memo_data$med_time, col = "blue", pch = 18)
legend(1, 300000, c("Not Memorized", "Memoized"), pch = 18, 
       col = c("black", "blue"), bty = "n", cex = 1, y.intersp = 1.5)