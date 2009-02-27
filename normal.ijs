NB. =======================================================
NB. Verbs for working with Normal Distributions
NB. 
NB. Ewart Shaw (Vector 18(4) and elsewhere), Fraser Jackson, 
NB. Ric Sherlock, Brian Schott, Devon McCormick, Zsban Ambrus 
NB. and others (through the jprogramming forum) contributed functions 
NB. or concepts used in this script.
NB. built from project: ~Addons/stats/distribs/normal/normal
NB. =========================================================
NB. Utilities

coclass 'pnormal'


NB.*tomusigma v Converts from N[0,1] to N[mu,sigma]
tomusigma=: 4 : 0
  'mu sigma'=. x
  mu + sigma*y
)

NB.*tostd v Converts from N[mu,sigma] to N[0,1]
tostd=: 4 : 0
  'mu sigma'=. x
  (y-mu)%sigma
)

NB.*runif01 v Uniform random deviates
runif01=: ?@$0:

NB. ---------------------------------------------------------
NB. Utils & Coefficients for qnorm01

NB. vftxt v numeric vector from text
vftxt=. 0". ];._2

NB. ratpoly c rational polynomial approximation
ratpoly=. 2 : 'm&p. % (1,n)&p.'

SPLIT1=: 0.425 [ SPLIT2=: 5.0
CONST1=. 0.180625 [ CONST2=. 1.6

NB. Coefficients for P close to 0.5
A=. vftxt 0 : 0
3.3871328727963666080
1.3314166789178437745e2
1.9715909503065514427e3
1.3731693765509461125e4
4.5921953931549871457e4
6.7265770927008700853e4
3.3430575583588128105e4
2.5090809287301226727e3
)

B=. vftxt 0 : 0
4.2313330701600911252e1
6.8718700749205790830e2
5.3941960214247511077e3
2.1213794301586595867e4
3.9307895800092710610e4
2.8729085735721942674e4
5.2264952788528545610e3
)

ratAB=. A ratpoly B

NB. Coefficients for P not close to 0, 0.5 or 1.
C=. vftxt 0 : 0
1.42343711074968357734
4.63033784615654529590
5.76949722146069140550
3.64784832476320460504
1.27045825245236838258
2.41780725177450611770e_1
2.27238449892691845833e_2
7.74545014278341407640e_4
)

D=. vftxt 0 : 0
2.05319162663775882187
1.67638483018380384940
6.89767334985100004550e_1
1.48103976427480074590e_1
1.51986665636164571966e_2
5.47593808499534494600e_4
1.05075007164441684324e_9
)

ratCD=. C ratpoly D

NB. Coefficients for P near 0 or 1.
E=. vftxt 0 : 0
6.65790464350110377720
5.46378491116411436990
1.78482653991729133580
2.96560571828504891230e_1
2.65321895265761230930e_2
1.24266094738807843860e_3
2.71155556874348757815e_5
2.01033439929228813265e_7
)

F=. vftxt 0 : 0
5.99832206555887937690e_1
1.36929880922735805310e_1
1.48753612908506148525e_2
7.86869131145613259100e_4
1.84631831751005468180e_5
1.42151175831644588870e_7
2.04426310338993978564e_15
)

ratEF=. E ratpoly F

qfp=: -&0.5
r1fq=. CONST1 - *:
r2fp=: [: %:@:-@:^. ] <. -.

nd1=: (] * ratAB@r1fq)@qfp f.
nd2fr=: (ratCD@-&CONST2) f.
nd3fr=: (ratEF@-&SPLIT2) f.

NB. ndx v calculates qnorm01 based on numerical category of ys
ndx=: 3 : 0
  s=. ($y)$0
  msk=. (SPLIT1 < |@qfp) y  NB. is y pretty close to 0 or 1?
  s=. (nd1 (-.msk)#y) (I.-.msk)}s  NB. no
  st=. r2fp msk#y                  NB. yes pretty close
  msk2=. st > SPLIT2        NB. is y really close to 0 or 1?
  st=. (nd2fr (-.msk2)#st) (I. -.msk2)}st NB. no
  st=. (nd3fr    msk2 #st)   (I. msk2)}st NB. yes very close
  st=. (st * *@qfp) msk#y
  s=. st (I. msk)}s
)

NB. =========================================================
NB. Standard normal distribution

NB.*dnorm01 v Standard normal PDF
dnorm01=: (% %: 2p1) * ^@:(_0.5 * *:)

NB. error function
NB. ref Abramovitz and Stegum 7.1.21 (right)
erf=: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:

erfc=: >:@-@erf  NB. complementary error function

NB.*pnorm01_s v Standard normal CDF
NB. slower but more accurate than pnorm01
NB. ref Abramovitz and Stegum 26.2.29 (solved for P)
pnorm01_s=: ([: -: 1: + [: erf %&(%:2)) f.

NB.*pnorm01 v Standard normal CDF
NB. ref Abramovitz and Stegum 26.2.17
pnorm01=: 3 : 0
  t=. %>:0.2316419*|y
  c=. %%:o.2
  z=. c*^--:*:y
  p=. t*_1.821255978+t*1.330274429
  p=. t*0.319381530+t*_0.356563782+t*1.781477937+p
  ((y >0)*1-z*p) + (y <:0)*z*p
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


NB. =========================================================
NB. General Normal distribution

NB.*dnorm v Normal probability density function
dnorm=: 3 : 0
  dnorm01 y
  :
  dnorm x tostd y
)

NB.*pnorm_s v Normal cumulative distribution function
NB. slower but more accurate than pnorm
pnorm_s=: 3 : 0
  pnorm01_s y
  :
  pnorm_s x tostd y
)

NB.*pnorm v Normal cumulative distribution function
NB. faster than pnorm_s
NB. max absolute error < 7.46e_8 for range (_5,5)
NB. < 0.2 percent relative error.
pnorm=: 3 : 0
  pnorm01 y
  :
  pnorm x tostd y
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


NB. =========================================================
NB. Export to z locale

dnorm_z_=: dnorm_pnormal_
pnorm_s_z_=: pnorms_pnormal_
pnorm_z_=: pnorm_pnormal_
pnorm_ut_z_=: pnorm_ut_pnormal_
qnorm_z_=: qnorm_pnormal_
qnorm_ut_z_=: qnorm_ut_pnormal_
rnorm_z_=: rnorm_pnormal_
tomusigma_z_=: tomusigma_pnormal_
tostd_z_=: tostd_pnormal_

