# Environments are data structures that have special properties with regard to their role in R code is executed
# and how memory in R is organised

# create new environment using new.env()
# use assign() to assign variables in the environment
# use get() to retrieve the value of the variable
my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x

assign("y", 9, envir=my_new_env)
get("y", envir=my_new_env)
my_new_env$y

# use ls() to get all variable names that have been assigned
# use rm() to remove association between a variable name and value
# use exists() to check if a variable name has been assigned in the environment
ls(my_new_env)
rm(y, envir=my_new_env)
exists("y", envir=my_new_env)
exists("x", envir=my_new_env)
my_new_env$x
my_new_env$y

# Environments are organized in parent/child relationships such that every environment keeps track of its parent, 
# but parents are unaware of which environments are their children
# use search() to see the parents of the global environment
search()
library(ggplot2)
search()

# Execution Environments------------------------------------------
# more often create a new environment whenever executing functions
# execution environment exists temporarily within the scope of a function that is being executed
x <- 10 # global environment

my_func <- function(){
    x <- 5 # execution environment
    return(x)
}

my_func()

# complex assignment operator <<- 
# to re-assign or even create name-value bindings in the global environment from within an execution environment
# can also use to assign names to values that have not been yet defined in the global environment
x <- 10
x
assign1 <- function(){
    x <<- "Wow!"
}
assign1()
x

a_variable_name
exists("a_variable_name")

assign2 <- function(){
    a_variable_name <<- "Magic!"
}

assign2()
exists("a_variable_name")
a_variable_name