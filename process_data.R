# R script for homework
# writing process data function

process_data <- function(df){
  mask <- df$Score >= 50
  newdf <- df[mask,]
  return(newdf)
}