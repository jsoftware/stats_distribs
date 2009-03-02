NB. =========================================================
NB. General Normal distribution

NB.*dnorm v Normal probability density function
dnorm=: 3 : 0
  dnorm01 y
  :
  dnorm x tostd y
)

NB.*pnorm v Normal cumulative distribution function
NB. slower but more accurate than pnorm_f
pnorm=: 3 : 0
  pnorm01 y
  :
  pnorm x tostd y
)

NB.*pnorm_f v Normal cumulative distribution function
NB. faster than pnorm
NB. max absolute error < 7.46e_8 for range (_5,5)
NB. < 0.2 percent relative error.
pnorm_f=: 3 : 0
  pnorm01_f y
  :
  pnorm_f x tostd y
)

NB.*pnorm_ut v Upper Tail version of pnorm
pnorm_ut=: [: -. pnorm

NB.*qnorm v Quantile function for normal distribution
NB. inverse of pnorm
qnorm=: 3 : 0
  qnorm01 y
  :
  x tomusigma qnorm y
)

NB.*qnorm_ut v Upper Tail version of qnorm
qnorm_ut=: [: - qnorm

NB.*rnorm v Random deviates from normal distribution
rnorm=: 3 : 0
  rnorm01 y
  :
  x tomusigma rnorm y
)
