# stop() generate error
stop("Something erroneous has occurred")

# If an error occurs inside of a function, then the name of that function will appear in the error message
# use only if it is impossible to continue
name_of_function <- function(){
    stop("Something bad happened.")
}

name_of_function()

# stopifnot() takes a series of logical expressions as arguments
# if any of them are false, an error is generated specifying which expression is false
# use when common failure conditions like providing invalid arguments to a function should be checked at the beginning
error_if_n_is_greater_than_zero <- function(n){
    stopifnot(n <= 0)
    n
}

error_if_n_is_greater_than_zero(5)

# warning() creates a warning, but does not stop the execution of the program
warning("Consider yourself warned!")

make_NA <- function(x){
    warning("Generating an NA.")
    NA
}

make_NA("Sodium")

# Handling Errors-------------------------------------------------------------------
# tryCatch() is the workhorse of handling errors and warnings in R
# 1st argument: any R expressions
# middle argument: conditions which specify how to handle an error or warnings
# last argument: specifies a function or expression that will be executed after the expression no matter what
beera <- function(expr) {
    tryCatch(expr,
            error = function(e){
                message("An error occurred:\n", e)
            },
            warning = function(w){
                message("A warning occurred:\n", w)
            },
            finally = {
                message("Finally done!")
            })
}

beera({2+2})
beera({"two" + 2})
beera({as.numeric(c(1, "two", 3))})

# limit the number of errors generating as mych as possible
# error handling process slows down the program by orders of magnitude
is_even_error <- function(n){
  tryCatch(n %% 2 == 0,
           error = function(e){
             FALSE
           })
}
# time consuming when being applied to more data
# short circuiting
is_even_check <- function(n){
    is.numeric(n) && n%%2==0
}

# check the speed
library(microbenchmark)
microbenchmark(sapply(letters, is_even_check))
microbenchmark(sapply(letters, is_even_error))