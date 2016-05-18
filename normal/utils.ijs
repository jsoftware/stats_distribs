NB. =========================================================
NB. Utilities

NB.*tomusigma v Converts from N[0,1] to N[mu,sigma]
NB. returns: rescaled numeric array adjusted by mean mu &
NB.          stddev sigma
NB. y is: numeric array
NB. x is: 2-item numeric list
NB.     0{x desired mean adjustment for array
NB.     1{x desired stddev adjustment for array
tomusigma=: 4 : 0
  'mu sigma'=. x
  mu + sigma*y
)

NB.*tostd v Converts from N[mu,sigma] to N[0,1]
NB. returns: rescaled numeric array adjusted for mean mu &
NB.          stddev sigma
NB. y is: numeric array
NB. x is: 2-item numeric list
NB.    0{x mean to adjust for
NB.    1{x stddev to adjust for
tostd=: 3 : 0
  ((mean,stddev)y) tostd y
:
  'mu sigma'=. x
  (y-mu)%sigma
)

NB. runif01 v Uniform random deviates
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
  msk=. (SPLIT1 < |@qfp) y               NB. is y pretty close to 0 or 1?
  s=. (nd1 (-.msk)#y) (I.-.msk)}s          NB. no
  st=. r2fp msk#y                          NB. yes pretty close
  msk2=. st > SPLIT2                     NB. is y really close to 0 or 1?
  st=. (nd2fr (-.msk2)#st) (I. -.msk2)}st  NB. no
  st=. (nd3fr    msk2 #st)   (I. msk2)}st  NB. yes very close
  st=. (st * *@qfp) msk#y
  s=. st (I. msk)}s
)
