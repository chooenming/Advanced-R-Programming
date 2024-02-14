# Process of getting expecctations to converge with reality

# traceback()
# prints out the function call stack before an error occurs so what level of function calls the error can be seen
# does nothing if there is no error
check_n_value <- function(n){
    if(n>0){
        stop("n shoud be <= 0")
    }
}
error_if_n_is_greater_than_zero <- function(n){
    check_n_value(n)
    n
}
error_if_n_is_greater_than_zero(5)
traceback()

# browser()
# interactive debugging environment that allows to step through code one expression at a time
# insert browser() in the vicinity of the error (ideally, before the error occurs)
check_n_value <- function(n){
    if(n>0){
        browser() # error occurs around here
        stop("n should be <= 0")
    }
}
error_if_n_is_greater_than_zero(5)

# trace()
# allows to temporarily insert pieces of code into other functions to modify the behaviour
# suitable when do not have easy access to a function's code, or perhaps a function is inside a packaage
check_n_value <- function(n){
    if(n>0){
        stop("n should be <= 0")
    }
}
trace("check_n_value")
error_if_n_is_greater_than_zero(5)

# can do more with trace(), such as inserting a call to browser() in a specific place, such as right before the call to stop()
as.list(body(check_n_value)) # obtain the expression numbers of each part of a function by calling as.list() on the body() of a function
#further break down second expression
as.list(body(check_n_value)[[2]])
# specify to trace() by passing an integer vector wrapped in a list to the at argument
trace("check_n_value", browser, at=list(c(2, 3)))

# trace() has a side effect of modifying the function and converting into a new object of class
check_n_value
# see internally modified code by calling
body(check_n_value)

# add more complex expressoins to a function by wrapping them in a call to quote() within the trace()
# invoke certain behaviours depending on the local conditions of the function
trace("check_n_value", quote({
    if(n == 5){
        message("invoking the browser")
        browser()
    }
}), at = 2)
# only invoke the browser() if n == 5
body(check_n_value)

# debugging functions within a package with trace()
trace("glm", browser, at=4, where=asNamespace("stats"))
body(stats::glm)[1:5]

# debug()
# initiates the browser within a function and can step through the code one expression at a time
# turn on "debugging state" of a function
# once a function is flagged for debugging, it will remain flagged
debug(lm)

# debugonce()
# turns on the debugging state the next time the function is call but then turns off after the browser is exited


# recover()
# not often used
# navigates the function call stack after a function has thrown an error
# do not call recover() directly, but set it as the function to invoke anytime an error occurs in the code
options(error = recover)
# Usually, when an error occurs in code, the code stops execution and you are brought back to the usual R console prompt. 
# However, whenrecover() is in use and an error occurs, you are given the function call stack and a menu
check_n_value <- function(n){
    if(n>0){
        stop("n shoud be <= 0")
    }
}
error_if_n_is_greater_than_zero <- function(n){
    check_n_value(n)
    n
}
error_if_n_is_greater_than_zero(5)
