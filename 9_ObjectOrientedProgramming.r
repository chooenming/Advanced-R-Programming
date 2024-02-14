# class = blueprint for an object
# describes the parts of an object, how to make an object, what the object is able to do

# S3---------------------------------------------------------------------------
# can arbitrarily assign a class to any object
# class assignments can be made using structure(), or class()
special_num <- structure(1, class = "special_number")
class(special_num)

special_num_2 <- 2
class(special_num_2)
class(special_num_2) <- "special_number"
class(special_num_2)

# create constructor to have better behaved S3 class
shape_s3 <- function(side_lengths){
    structure(list(side_lengths = side_lengths), class = "shape_S3")
}

square_4 <- shape_s3(c(4, 4, 4, 4))
class(square_4)

triangle_3 <- shape_s3(c(3, 3, 3))
class(triangle_3)

# create a method that would return TRUE if a shape_S3 object was a square, 
# FALSE if a shape_S3 object was not a square, 
# and NA if the object provided as an argument to the method was not a shape_s3 object. 
# This can be achieved using R’s generic methods system. 
# A generic method can return different values based depending on the class of its input.
# creation of generic method uses UseMethod()
# [name of method] <- function(x) UseMethod("[name of method]")
is_square <- function(x) UseMethod("is_square")
# add actual function definition
# by putting a dot (.) and then the name of the class, create method that associated with class
is_square.shape_S3 <- function(x){
    length(x$side_lengths) == 4 &&
    x$side_lengths[1] == x$side_lengths[2] &&
    x$side_lengths[2] == x$side_lengths[3] &&
    x$side_lengths[3] == x$side_lengths[4]
}

is_square(square_4)
is_square(triangle_3)

# return NA if it is not a shape_S3
# method.default as a last resort if there is not method associated with the object
is_square.default <- function(x){
    NA
}
is_square("square")
is_square(c(1, 1, 1, 1))

# look messy
print(square_4)

# print() is a generic method, can specify a print method for shape_S3
print.shape_S3 <- function(x) {
    if(length(x$side_lengths) == 3){
        paste("A triangle with side lengths of", x$side_lengths[1], x$side_lengths[2], "and", x$side_lengths[3])
    } else if (length(x$side_lengths) == 4){
        if(is_square(x)){
            paste("A square with four sides of length", x$side_lengths[1])
        } else {
            paste("A quadrilateral with side lengths of", x$side_lengths[1], x$side_lengths[2], x$side_lengths[3], "and", x$side_lengths[4])
        }
    } else {
        paste("A shape with", length(x$side_lengths), "slides.")
    }
}

print(square_4)
print(triangle_3)
print(shape_s3(c(10, 10, 20, 20, 15)))
print(shape_s3(c(2, 3, 4, 5)))

# mostly every class has an associated print method
head(methods(print), 10)

# sub-class can inherit attributes and methods from a super-class
# can specify super class for an object the same way of specifying a class for an object
class(square_4)
class(square_4) <- c("shape_S3", "square")
class(square_4)
# use inherits() to check if an object is a sub-class of a specified class
inherits(square_4, "square")
inherits(square_4, "shape_S3")


# S4---------------------------------------------------------------------------
# slightly more restrictive than S3
# use setClass()
# arguments:
# - name of class
# - slots (named list of attributes for the class with the class of those attributes specified)
# - (optional) super-class
setClass("bus_S4",
            slots = list(n_seats = "numeric",
                        top_speed = "numeric",
                        current_speed = "numeric",
                        brand = "character"))
setClass("party_bus_S4",
            slots = list(n_subwoofers = "numeric",
                        smoke_machine_on = "logical"),
            contains = "bus_S4")

# use new() to create objects
# arguments: name of the class and values for each "slot"
my_bus <- new("bus_S4", n_seats = 20, top_speed = 80, current_speed = 0, brand = "Volvo")
my_bus

my_party_bus <- new("party_bus_S4", n_seats = 10, top_speed = 100, current_speed = 0, brand = "Mercedes-Benz",
                    n_subwoofers = 2, smoke_machine_on = FALSE)
my_party_bus

# use @ to access the slots of an S4 object
my_bus@n_seats
my_party_bus@top_speed

# use setGeneric() for generic method
# setGeneric("new_generic", function(x){
#     standardGeneric("new_generic")
# })
# create generic function
setGeneric("is_bus_moving", function(x){
    standardGeneric("is_bus_moving")
})
# setMethod() to define the function
# arguments: name of the method, method signature which specifies the class of each argument for the method, function definition
setMethod("is_bus_moving",
            c(x = "bus_S4"),
            function(x){
                x@current_speed > 0
            })
is_bus_moving(my_bus)
my_bus@current_speed <- 1
is_bus_moving(my_bus)

# can also create a new class from existing generic
setGeneric("print")
setMethod("print",
            c(x = "bus_S4"),
            function(x){
                paste("This", x@brand, "bus is traveling at a speed of", x@current_speed)
            })
print(my_bus)
print(my_party_bus)

# Reference Classes---------------------------------------------------------------------------
# setRefClass() to define class' fields, methods, super-classes
# Example: reference class that represent student
# 5 fields 3 methods
Student <- setRefClass("Student",
                        fields = list(name = "character",
                                        grad_year = "numeric",
                                        credits = "numeric",
                                        id = "character",
                                        courses = "list"),
                        methods = list(hello = function(){
                                            paste("Hi! My name is", name)
                                        },
                                        add_credits = function(n){
                                            # use <<- aka complex operators if want to modify one of the fields of an object with a method
                                            credits <<- credits + n
                                        },
                                        get_email = function(){
                                            paste0(id, "@testing.edu")
                                        }
                                        )
                        )

# to create a Student object, use new()
brooke <- Student$new(name = "Brooke", grad_year = 2019, credits = 40, id = "ba123", courses = list("Ecology", "Calculus"))
roger <- Student$new(name = "Roger", grad_year = 2020, credits = 10, id = "rp456", courses = list("Computer Science", "Mathematics"))

# access the fields and methods
brooke$credits
brooke$add_credits(5)
brooke$credits # credits has been changed
roger$hello()
roger$get_email()

# reference classes can inherit from other classes by specifying the contains arguments when they are defined
# create sub-class of Student called Grad_Student which includes few extra features
Grad_Student <- setRefClass("Grad_Student",
                            contains = "Student",
                            fields = list(thesis_topic = "character"),
                            methods = list(defend = function(){
                                                paste0(thesis_topic, ". QED.")
                                            }
                                        )
                            )

jeff <- Grad_Student$new(name = "Jeff", grad_year = 2021, credits = 8, id = "j155", courses = list("Engineering", "Programming"),
                        thesis_topic = "Machine Learning in Finance")

jeff$defend()