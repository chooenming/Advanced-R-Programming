# Microbenchmark----------------------------------------------------
# useful for running small sections of code to assess performance
# and comparing the speed of several functions that do the same thing
library(microbenchmark)
microbenchmark(a <- rnorm(1000),
                b <- mean(rnorm(1000)))

# Example
find_records_1 <- function(datafr, threshold){
    highest_temp <- c()
    record_temp <- c()
    for(i in 1:nrow(datafr)){
        highest_temp <- max(highest_temp, datafr$temp[i])
        record_temp[i] <- datafr$temp[i] >= threshold & datafr$temp[i] >= highest_temp
    }
    datafr <- cbind(datafr, record_temp)
    return(datafr)
}

# Function that uses tidyverse functions
library(tidyerse)
library(dplyr)
find_records_2 <- function(datafr, threshold){
  datafr <- datafr %>%
    mutate_(over_threshold = ~ temp >= threshold,
            cummax_temp = ~ temp == cummax(temp),
            record_temp = ~ over_threshold & cummax_temp) %>%
    select_(.dots = c("-over_threshold", "-cummax_temp"))
  return(as.data.frame(datafr))
}
example_data <- data.frame(date = c("2015-07-01", "2015-07-02",
                                    "2015-07-03", "2015-07-04",
                                    "2015-07-05", "2015-07-06",
                                    "2015-07-07", "2015-07-08"),
                           temp = c(26.5, 27.2, 28.0, 26.9, 
                                    27.5, 25.9, 28.0, 28.2))
(test_1 <- find_records_1(example_data, 27))
(test_2 <- find_records_2(example_data, 27))
all.equal(test_1, test_2)

# comparison of the two functions
record_temp_perf <- microbenchmark(find_records_1(example_data, 27),
                                    find_records_2(example_data, 27))
record_temp_perf

# check if the performance is similar for bigger dataset
library(dlnm)
data("chicagoNMMAPS")

record_temp_perf_2 <- microbenchmark(find_records_1(chicagoNMMAPS, 27),
                                        find_records_2(chicagoNMMAPS, 27))
record_temp_perf_2

# benchmarking result
# use autoplot.microbenchmark and boxplot.microbenchmark
library(ggplot2)
autoplot(record_temp_perf_2)

# profvis----------------------------------------------------
# once identified slower code, then figure out which parts of the code are causing bottlenecks
# input the code (in braces if it is multi-lines)
library(profvis)
datafr <- chicagoNMMAPS
threshold <- 27

profvis({
  highest_temp <- c()
  record_temp <- c()
  for(i in 1:nrow(datafr)){
    highest_temp <- max(highest_temp, datafr$temp[i])
    record_temp[i] <- datafr$temp[i] >= threshold & 
      datafr$temp[i] >= highest_temp
  }
  datafr <- cbind(datafr, record_temp)
})
# data output defaults to show the time usage of each first-level function call
# each of these calls can be expanded to show deeper and deeper functions calls within the call stack

# "Flame Graph" view gives two panles
# top panel: code called, with bars on the right to show memory use and time spent on the line
# bottom panel: visualisaes the time used by each line of code
# clicking on a block will show more information about a call, including which file it was called from,
# how much time it took, how much memory it took, depth in the call stack

# more details refer to https://rstudio.github.io/profvis/index.html
