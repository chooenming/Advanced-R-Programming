# Functions are used to encapsulate a sequence of expressions that are executed together to achieve a specific goal
# Drawing the lines where functions begin and end is a key skill for writing functions

# When to use function?
# do something twice, then write a function
    ## allows to abstract a small piece of code, and forces to define an interface
# do something three times or more, write a small package
    # small package which encapsulate set f operations

library(readr)
library(dplyr)

## Download data from RStudio
if(!file.exists("data/2016-07-20.csv.gz")) {
        download.file("http://cran-logs.rstudio.com/2016/2016-07-20.csv.gz", 
                      "data/2016-07-20.csv.gz")
}
cran <- read_csv("data/2016-07-20.csv.gz", col_types = "ccicccccci")
cran %>% filter(package == "filehash") %>% nrow

# function interface ----------------------------------
## pkgname: package name (character)
## date: YYYY-MM-DD format (character)
num_download <- function(pkgname, date) {
        ## Construct web URL
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)

        ## Construct path for storing local file
        dest <- file.path("data", basename(src))

        ## Don't download if the file is already there!
        if(!file.exists(dest))
                download.file(src, dest, quiet = TRUE)

        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}

# call function
num_download("filehash", "2016-07-20")
num_download("dplyr", "2020-10-21")

# function with default value
num_download <- function(pkgname, date = "2016-07-20") {
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)
        dest <- file.path("data", basename(src))
        if(!file.exists(dest))
                download.file(src, dest, quiet = TRUE)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}
# call the function
num_download("Rcpp")

# Refactoring code ----------------------------------------------------------
# In particular, it could be argued that this function does too many things:
# 1. Construct the path to the remote and local log file
# 2. Download the log file (if it doesn't already exist locally)
# 3. Read the log file into R
# 4. Find the package and return the number of downloads
# It might make sense to abstract the first two things on this list into a separate function. 
# For example, we could create a function called check_for_logfile() to see if we need to download the log file and then 
# num_download() could call this function
check_for_logfile <- function(date) {
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)
        dest <- file.path("data", basename(src))
        if(!file.exists(dest)) {
                val <- download.file(src, dest, quiet = TRUE)
                if(!val)
                        stop("unable to download file ", src)
        }
        dest
}

# in addition to being simpler to read, num_download() does not need to know anything about downloading or URLs or files
num_download <- function(pkgname, date = "2016-07-20") {
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}    

# Dependency Checking ----------------------------------------------------------
# Sometimes it is useful to check to see that the needed packages are installed so that a useful error message 
# (or other behavior) can be provided for the user.
# require() function is similar to library()
# library() stops with an error if the package cannot be loaded
    ## good for interactive work
# require() returns TRUE FALSE depending on whether the package can be loaded or not
    ## good for programming because want to engage in different behaviours depending on which packages are not available
check_pkg_deps <- function() {
        if(!require(readr)) {
                message("installing the 'readr' package")
                install.packages("readr")
        }
        if(!require(dplyr))
                stop("the 'dplyr' package needs to be installed first")
}

num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}

# Vectorization ----------------------------------------------------------
# it is common for functions to take vector arguments and return vector / list results
# One way to vectorize this function is to allow the pkgname argument to be a character vector of package names
# This way we can get download statistics for multiple packages with a single function call 
# 1. Adjust our call to filter() to grab rows of the data frame that fall within a vector of package names
# 2. Use a group_by() %>% summarize() combination to count the downloads for each package.

## 'pkgname' can now be a character vector of names
num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package %in% pkgname) %>% 
                group_by(package) %>%
                summarize(n = n())
}   

num_download(c("filehash", "weathermetrics"))

# Argument Checking ----------------------------------------------------------
# Checking the arguments applied by the reader are proper is a good way to prevent confusing results or error messages
# from occurring later on in the function
# useful way to enforce documented requirements for a function
num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()

        ## Check arguments
        if(!is.character(pkgname))
                stop("'pkgname' should be character")
        if(!is.character(date))
                stop("'date' should be character")
        if(length(date) != 1)
                stop("'date' should be length 1")

        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", 
                         progress = FALSE)
        cran %>% filter(package %in% pkgname) %>% 
                group_by(package) %>%
                summarize(n = n())
}   