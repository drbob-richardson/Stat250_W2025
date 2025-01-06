# Effect of Correlation on Confidence Intervals

### PROBLEM 1 ###
## Write a function sim_AR1 with arguments n, phi

# Assessing: transforming code into a function

# Teaching References:
# About R functions
# https://grimshawville.byu.edu/BYUStat250/Programming1.html#/r-functions
# Generating data from an AR(1)
# https://grimshawville.byu.edu/BYUStat250/Simulation2.html#/ar1-model
# Note: code they can copy is under Code tab at https://grimshawville.byu.edu/BYUStat250/Simulation2.html#/ar1-model-1

sim_AR1 <- function(n, phi){

  sigma_epsilon <- 1
  simdata_AR1 <- rep(0, n)

  for(i in 1 : n){
    if(i == 1){
      simdata_AR1[1] <- rnorm(1, mean = 0, sd = sigma_epsilon / sqrt(1 - phi^2))
    } else{
      simdata_AR1[i] <- phi * simdata_AR1[i - 1] + rnorm(1, mean = 0, sd = sigma_epsilon)
    }
}  

    simdata_AR1
}


# Test your code
ts.plot(sim_AR1(n = 100, phi = 0.6))

# plot should look similar to the phi = 0.6 tab at https://grimshawville.byu.edu/BYUStat250/Simulation2.html#/ar1-model-2


### PROBLEM 2 ###
# Write code to generate one dataset from an AR(1), compute the 95% CI for mu using t.test, and extract the lower & upper CI bounds from the t.test result

# Assessing: writing R code (steps, logic, syntax)

# Teaching References:
# Extracting results from an R function
# https://grimshawville.byu.edu/BYUStat250/Simulation3.html#/appendix
# Details on t.test
# https://grimshawville.byu.edu/BYUStat250/SimulationMiniProject.html#/using-t.test-to-compute-95-confidence-interval-for-mu

y <- sim_AR1(n = 20, phi = 0.2)
out <- t.test(y)
out$conf.int[1]
out$conf.int[2]



### PROBLEM 3 ###

# Write a function sim_MP to perform simulation

# Assessing: writing a function, returning a result from a function, for loop, saving the i th result (understanding R vector indexing), writing logical for if zero is in CI, compute proportion of "Event A" using mean

# Teaching References:
# Psuedo Code
# https://grimshawville.byu.edu/BYUStat250/SimulationMiniProject.html#/suggested-work-flow-problem-3-1
# Approximating P(A) using simulation
# https://grimshawville.byu.edu/BYUStat250/Simulation1.html#/motivating-example-6
# The code for approximating P(Type 1 Error) in S-W normality test may be helpful
# https://grimshawville.byu.edu/BYUStat250/Simulation3.html#/power-of-shapiro-wilk-test-2

sim_MP <- function(n, phi, Nsim = 10^5){
  CI_L <- rep(0, Nsim)
  CI_U <- rep(0, Nsim)

  for(i in 1 : Nsim){
    y <-  sim_AR1(n, phi)
      
    out <- t.test(y)
  
    CI_L[i] <- out$conf.int[1]
    CI_U[i] <- out$conf.int[2]
  }
  mean(CI_L < 0 & 0 < CI_U)
}

# Test your code
sim_MP(n = 100, phi = 0)




