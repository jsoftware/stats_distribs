NB. =========================================================
NB. General Normal distribution

NB.*dnorm v Normal probability density function
NB. returns: values (heights) of Normal PDF at y
NB. eg: 0.241971 = dnorm 1  and  0.241971 = 2 1 dnorm 3
NB. y is: numeric array of values to calculate Z(y) for.
NB. x is: optional 2-item numeric list (default is 0 1)
NB.    0{x is mean of popln from which y values were taken
NB.    1{x is stddev of popln from which y values were taken
dnorm=: 3 : 0
  dnorm01 y
  :
  (dnorm x tostd y) % {:x
)

NB.*pnorm v Normal cumulative distribution function
NB. returns: probability of value occuring below each y value
NB. eg: 0 = pnorm __   and 0.5 = pnorm 0
NB. y is: numeric array of values to calculate P(y) for.
NB. x is: optional 2-item numeric list (default is 0 1)
NB.    0{x is mean of popln from which y values were taken
NB.    1{x is stddev of popln from which y values were taken
NB. slower but more accurate than pnorm_f
pnorm=: 3 : 0
  pnorm01 y
  :
  pnorm x tostd y
)

NB.*pnorm_f v Normal cumulative distribution function
NB. see pnorm
NB. faster than pnorm but less accurate
NB. max absolute error < 7.46e_8 for range (_5,5)
NB. < 0.2 percent relative error.
pnorm_f=: 3 : 0
  pnorm01_f y
  :
  pnorm_f x tostd y
)

NB.*pnorm_ut v Upper Tail version of pnorm
NB. see pnorm but returns probability of a
NB.   value occuring *above* each y value
NB. eg: 1 = pnorm_ut __ and 0.5 = pnorm_ut 0
pnorm_ut=: [: -. pnorm

NB.*qnorm v Quantile function for Normal distribution
NB. inverse of Normal CDF (pnorm)
NB. returns: values below which the probability of a value occuring are y
NB. eg: __ = qnorm 0  and  0 = qnorm 0.5
NB. y is: numeric array of probabilities from 0 to 1
NB. x is: optional 2-item numeric list (defaults to 0 1)
NB.     0{x desired mean of popln for results
NB.     1{x desired stddev of popln for results
qnorm=: 3 : 0
  qnorm01 y
  :
  x tomusigma qnorm y
)

NB.*qnorm_ut v Upper Tail version of qnorm
NB. see qnorm but returns values *above* which the probability of a value occuring are y
qnorm_ut=: [: - qnorm

NB.*rnorm v Generates random deviates from Normal distribution
NB. returns: shape y array of random deviates from normal distribution with mean & stddev x
NB. eg: 3 = $23.5 4.2 rnorm 3
NB. y is: numeric list specifying shape of result
NB. x is: optional 2-item numeric list (defaults to 0 1)
NB.     0{x desired mean of popln for results
NB.     1{x desired stddev of popln for results
rnorm=: 3 : 0
  rnorm01 y
  :
  x tomusigma rnorm y
)
