# if-else
x <- runif(1, 0, 10) # generate a uniform random number
if(x > 3){
    y <- 10
} else {
   y <- 0
}

# for loop
numbers <- rnorm(10)
for(i in 1:10){
    print(numbers[i])
}

# print each element of x using for loop
x <- c("a", "b", "c", "d")
for(i in 1:4){
    print(x[i])
}

# seq_along() is commonly used in conjuction with for loops to generate an integer sequence based on the length of an object
# generate sequence based on the length of x
for (i in seq_along(x)){
    print(x[i])
}

# for one line loop, curly braces {} are not strictly necessary
for(i in 1:4) print(x[i])

# nested for loops
# commonly needed for multidimensional / hierarchical data structures (matrices / lists)
# nesting beyong 2 to 3 levels often makes it difficult to read / understand the code
# may want to break up the loops by using functions
x <- matrix(1:6, 2, 3)
for(i in seq_len(nrow(x))){
    for(j in seq_len(ncol(x))){
        print(x[i, j])
    }
}

# next is used to skip an iteration of a loop
for(i in 1:100){
    if(i<=20){
        next
    }
}

# break is used to exit a loop immediately, regardless of what iteration the loop may be on
for(i in 1:100){
    print(i)

    if(i > 20){
        # stop loop after 20 iterations
        break
    }
}