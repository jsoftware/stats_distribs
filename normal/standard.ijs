NB. =========================================================
NB. Standard normal distribution

NB.*dnorm01 v Standard normal PDF
dnorm01=: (% %: 2p1) * ^@:(_0.5 * *:)

NB. error function
NB. ref Abramovitz and Stegum 7.1.21 (right)
erf=: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:

erfc=: >:@-@erf  NB. complementary error function

NB.*pnorm01 v Standard normal CDF
NB. slower but more accurate than pnorm01_f
NB. ref Abramovitz and Stegum 26.2.29 (solved for P)
pnormh=: (-: @: >: @ erf @ (%&(%:2))) f.
pnorm01=: 3 : 0
  z=. ,y
  msk=. -. z e. __ _
  z=. 0 (I. z=__)} z
  z=. 1 (I. z= _)} z
  n=. pnormh msk#z
  z=. n (I. msk)}z
  ($y)$z
)

NB.*pnorm01_f v Standard normal CDF
NB. ref Abramovitz and Stegum 26.2.17
pnorm01_f=: 3 : 0
  t=. %>:0.2316419*|y
  c=. %%:o.2
  z=. c*^--:*:y
  d=. 0 0.319381530 _0.356563782 1.781477937 _1.821255978 1.330274429
  p=. d p. t
  (-. r * -.msk) + (r=. z*p) * msk=. y<:0
)

NB.*qnorm01 v Inverse of standard normal CDF (Quantile function)
NB. Z is accurate to about 1 part in 10^16.
NB. ref ALGORITHM AS241  APPL. STATIST. (1988) VOL. 37, NO. 3
qnorm01=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  n=. ndx msk#z
  z=. n (I. msk)}z   NB. amend values to z
  ($y)$z
)

NB. BM v Box-Mueller
BM=. ((2 1 o."0 1 (2p1) * runif01) *"1 [: %: _2&*@:^.@:runif01)

NB.*rnorm01 v Random deviates from standard normal
NB. y is: shape of desired result array
rnorm01=: ] $ ,@BM@>.@-:@(*/) f.
