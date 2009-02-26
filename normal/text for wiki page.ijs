Note 'pnorm01'

There are two functions here. pnorm01S is more accurate but
considerably slower than pnorm. pnorm01S uses built in primitives
and is due to Ewart Shaw. It is from from A&S 26.2.29 (solved for P).
pnorm01 is coded from a Chebychev expansion in Abramovitz and Stegum 26.2.17

pnorm01 achieves a maximum absolute error of less than 7.46e_8 over the argument
range (_5,5) and less than 0.2 percent relative error.
)

Note 'Normal Random Deviates'

Brian Schott, Ric Sherlock and others contributed code to the
forum discussion of this function. The version in the
note follows closely the Box-Muller form of Schott
but does use more space than the tacit version
below. We include the explicit form to show the
structure of the steps in the code for those not
experienced with the tacit form.

The right argument is the shape of the result array.

rnorm01=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. runif01 n
  b=. 2* o. runif01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)
