NB. =========================================================
NB. Standard Normal distribution

NB. dnorm01 v Standard Normal PDF
dnorm01=: (% %: 2p1) * ^@:(_0.5 * *:)

NB. erf v error function
NB. ref Abramovitz and Stegum 7.1.21 (right)
erf=: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:

NB. erfc v complementary error function
erfc=: >:@-@erf

NB. erfinv v inverse of error function
erfinv =: (0,%%:2) qnorm 0.5 + -:

NB. pnormh v Standard Normal CDF
NB. slower but more accurate than pnorm01_f
NB. ref Abramovitz and Stegum 26.2.29 (solved for P)
pnormh=: (-: @: >: @ erf @ (%&(%:2))) f.

NB. pnorm01 v Standard Normal CDF
NB. uses more accurate pnormh for y values between _7 & 7.
NB. uses pnorm01_f for values outside that range where pnormh
NB. becomes unstable.
pnorm01=: 3 : 0
  z=. ,y
  msk=. (_7&<: *. 7&>:) z     NB. between _7 & 7
  n=. pnormh msk#z
  z=. n (I. msk)}z
  n=. pnorm01_f (-.msk)#z
  z=. n (I. -.msk)}z
  ($y)$z
)

NB. pnorm01_f v Standard Normal CDF
NB. ref Abramovitz and Stegum 26.2.17
pnorm01_f=: 3 : 0
  t=. %>:0.2316419*|y
  c=. %%:o.2
  z=. c*^--:*:y
  p=. 0 0.319381530 _0.356563782 1.781477937 _1.821255978 1.330274429
  p=. p p. t
  msk=. y>0
  nr=. -. r=. z*p
  r=. msk } r,:nr  NB. in-place assignment
)

NB. qnorm01 v Inverse of Standard Normal CDF (Quantile function)
NB. Z is accurate to about 1 part in 10^16.
NB. ref ALGORITHM AS241  APPL. STATIST. (1988) VOL. 37, NO. 3
qnorm01=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  n=. ndx msk#z
  z=. n (I. msk)}z         NB. amend values to z
  ($y)$z
)

NB. BM v Box-Mueller
BM=. ((2 1 o."0 1 (2p1) * runif01) *"1 [: %: _2&*@:^.@:runif01)

NB. rnorm01 v Random deviates from Standard Normal
NB. y is: shape of desired result array
rnorm01=: ] $ ,@BM@>.@-:@(*/) f.
