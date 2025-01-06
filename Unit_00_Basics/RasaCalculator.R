
# R as a calculator

# focus on Console panel

12 + 121

exp(1.2)

log(3.5) # base e ... often in math classes written as ln

factorial(8)

choose(8, 3)
factorial(8) / (factorial(3) * factorial(8 - 3))

# any other calculator functions?

# using "memory"
z <- 3
z + 12
z <- z + 12  # looks goofy as a math eqn, but think "assign result"
z  # short hand for print(z)

a <- 4 : 9
a

a / 4

factorial(a)  # what would you think this would do?

a ^ 2  

sum(a)  # why did this do something different?

sum(a ^ 2) 




# R script (type things & then run ... allow thinking, problem solving)

# demonstrate graphic a function

# natural log (remember it must be bigger than 0)
x <- seq(0, 3, length = 100)
plot(x, log(x), type = "l")
abline(h = 0, v = 0, col = "gray")

# exponential function
x <- seq(-2, 2, length = 100)
plot(x, exp(x), type = "l")
abline(h = 0, v = 0, col = "gray")


# any other function to graph?


# draw a graphic of the normal

# Steps:
#  possible value of the random variable
#  evaluate the pdf at the possible values
#  plot the pairs (possible value, pdf)

x <- seq(-4, 4, length = 10)
fx <- (1 / sqrt(2 * pi)) * exp(-0.5 * x ^ 2)

fx

x <- seq(-4, 4, length = 100)
fx <- (1 / sqrt(2 * pi)) * exp(-0.5 * x ^ 2)
plot(x, fx, type = 'l')


x <- seq(-4, 4, length = 100)
fx <- dnorm(x, mean = 0, sd = 1)
plot(x, fx, type = 'l')

# how is the N(1, 1) different?
fx1 <- dnorm(x, mean = 1, sd = 1)
lines(x, fx1, col = "royalblue")

# how is the N(0, 2) different?
fx2 <- dnorm(x, mean = 0, sd = 2)
lines(x, fx2, col = "hotpink")




