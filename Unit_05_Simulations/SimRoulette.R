
# "spin" the roulette wheel 1-36 with 0 and 00 (00 will be -1)
outcome <- sample(-1 : 36, 1)
outcome

# did we win? If so, we get 5 : 1 payoff
# note: this is a specific line bet 
#       (would the probability change if we chose a different line?)
ifelse(outcome >= 7 & outcome <= 12, 125, -25)


howlong <- function(Budget, MinBet){
  
  plays <- 0
  
  while(Budget - MinBet >= 0){
    
    # "spin" the roulette wheel 1-36 with 0 and 00 (00 will be -1)
    outcome <- sample(-1 : 36, 1)
    plays <- plays + 1
    
    # did we win?
    payoff <- ifelse(outcome >= 7 & outcome <= 12, 5 * MinBet, - MinBet)
    
    # update Stake
    Budget <- Budget + payoff
    
  }
  
  # game over
  plays
}

howlong(Budget = 100, MinBet = 25)


# define player behavior
Budget <- 100
MinBet <- 25

# simulate the number of plays
Nsim <- 10^5
set.seed(2112)
number_plays <- rep(0, Nsim)
for(i in 1 : Nsim){
  number_plays[i] <- howlong(Budget, MinBet)
}

# compute approx P(lose quickly)
mean(number_plays == 4)


