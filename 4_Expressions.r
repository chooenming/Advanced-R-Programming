# Expressions are encapsulated operations that can be executed by R
# Allows to manipulate code with code
# Create expression using quote()
two_plus_two <- quote(2 + 2)
two_plus_two
# execute the expressions using eval()
eval(two_plus_two)

# might encounter R code stored as string
# can use parse() to transform a string into expression
tpt_string <- "2 + 2"
tpt_expression <- parse(text = tpt_string)
eval(tpt_expression)

# reverse the process and transform an expression into a string using deparse()
deparse(two_plus_two)

# can access and modify the contents
sum_expr <- quote(sum(1, 5))
eval(sum_expr)
sum_expr[[1]]
sum_expr[[2]]
sum_expr[[3]]
sum_expr[[1]] <- quote(paste0)
sum_expr[[2]] <- quote(4)
sum_expr[[3]] <- quote(6)
eval(sum_expr)

# can compose expressions using call()
sum_40_50_expr <- call("sum", 40, 50)
sum_40_50_expr
eval(sum_40_50_expr)

# capture the expression an R user typed into the R console when executing a function by including match.call()
return_expression <- function(...){
    match.call()
}
return_expression(2, col="blue", FALSE)

# manipulate expression inside function
first_arg <- function(...){
    expr <- match.call()
    first_arg_expr <- expr[[2]]
    first_arg <- eval(first_arg_expr)
    if(is.numeric(first_arg)){
        paste("The first argument is ", first_arg)
    } else {
        "The first argument is not numeric."
    }
}

first_arg(2, 4, "seven", FALSE)
