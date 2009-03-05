<<Include(JAL/Navigator)>>

'''stats/distribs''' - Working with distributions

 * Includes verbs for working with the Normal distribution

Browse history, source and examples using [[JTracAddons:stats/distribs/|Trac]].

<<TableOfContents>>

== Verbs available ==

=== Normal Distribution ===
||''`tomusigma`'' ||v||Converts from N[0,1] to N[mu,sigma]||
||''`tostd`''     ||v||Converts from N[mu,sigma] to N[0,1]||
||''`dnorm`''     ||v||Normal probability density function||
||''`pnorm`''     ||v||Normal cumulative distribution function||
||''`pnorm_f`''   ||v||Normal cumulative distribution function||
||''`pnorm_ut`''  ||v||Upper Tail version of pnorm||
||''`qnorm`''     ||v||Quantile function for Normal distribution||
||''`qnorm_ut`''  ||v||Upper Tail version of qnorm||
||''`rnorm`''     ||v||Random deviates from Normal distribution||

== Installation ==

Use [[JAL/Package Manager]] to install the `stats/distribs` addon.

== Usage ==

Load the `stats/distribs` addon with the following line
{{{
   load 'stats/distribs'
}}}

If you wish to only work with one type of distribution you can 
load the individual scripts as follows:

{{{
   load 'stats/distribs/normal'
}}}

To see the sampler of usage, open and inspect the test 
script for the distribution of interest. For example:

[[JSVNAddons:stats/distribs/test_normal.ijs|test_normal.ijs]] script.

=== pnorm01 ===

There are two algorithms here. `pnormh` is more accurate but
slower than `pnorm01_f`. 

`pnormh` uses built-in primitives and is due originally to [[http://www.vector.org.uk/archive/v184/|Ewart Shaw]] 
with some [[Essays/Normal CDF|modifications by Roger Hui]]. 
It is from from Abramovitz and Stegum 26.2.29 (solved for P) and is 
also defined in the `stats/base/distributions.ijs` script.

`pnorm01_f` is coded from a Chebychev expansion in Abramovitz and 
Stegum 26.2.17. It achieves a maximum absolute error of less than 
7.46e_8 over the argument range (_5,5) and less than 0.2 percent 
relative error.

The `pnorm01` used in the normal script uses the `pnormh` algorithm for `y` values
between `_7` and `7` and the `pnorm01_f` algorithm outside that range. This is 
because the `pnormh` algorithm appears to be unstable outside that range giving
spurious results: eg:
{{{
   0j17 ": ,.pnormh_pnormal_ 10 20 30 40
1.00000000000000020
1.00000000000000040
1.00000000000000090
0.50000000000000000
}}}
Note also:
{{{
   pnormh_pnormal_ _
|NaN error: pnormh_pnormal_
|       pnormh_pnormal_ _
   pnormh_pnormal_ __
|NaN error: pnormh_pnormal_
|       pnormh_pnormal_ __
}}}
Whereas:
{{{
   0j17 ": ,.pnorm01_pnormal_ 10 20 30 40 _ __
0.00000000000000000
0.00000000000000000
0.00000000000000000
0.00000000000000000
0.00000000000000000
1.00000000000000000
}}}

=== qnorm01 ===
The explicit `qnorm01` was based on the tacit code on EwartShaw's page
[[EwartShaw/N01CdfInv]]. An explicit form was developed to improve 
the performance and ensure the desired results for 0 and 1 i.e.
{{{
   qnorm01 0 1
__ _
}}}

Based on the suggestion of JohnRandall in [[JForum:programming/2008-September/011978|this forum thread]]
FraserJackson and RicSherlock coded the following J version of the 
[[http://home.online.no/~pjacklam/notes/invnorm/|algorithm described by P J Acklam]]. 
However the algorithm included in the Addon, while slightly slower than
`qnorm01_acklam_fast` below, uses the same space and is considerably
faster and leaner than `qnorm01_acklam_accurate`. At the same time
it is more accurate than either.

{{{
qnorm01_acklam_fast=: 3 : 0
  z=. ,y
  s=. ($z)$0s
  
  assert. (0<:z) *. z<:1  NB. y outside meaningful bounds
  
  a=. _3.969683028665376e01 2.209460984245205e02 _2.759285104469687e02
  a=. |.a, 1.383577518672690e02 _3.066479806614716e01 2.506628277459239e00
  
  b=. _5.447609879822406e01 1.615858368580409e02 _1.556989798598866e02
  b=. |.b, 6.680131188771972e01 _1.328068155288572e01 1
  
  c=. _7.784894002430293e_03 _3.223964580411365e_01 _2.400758277161838e00
  c=. |.c, _2.549732539343734e00 4.374664141464968e00 2.938163982698783e00
  
  d=. 7.784695709041462e_03 3.224671290700398e_01 2.445134137142996e00
  d=. |.d, 3.754408661907416e00 1
  NB.   Define break-points.
  p_low=. 0.02425
  p_high=. 1 - p_low
  NB.   Rational approximation for lower region.
  v=. (0 < z) *. z < p_low
  q=. %: _2*^. v#z
  s=. ((c p. q) % d p. q) (I.v)} s
  NB.   Rational approximation for central region.
  v=. (p_low <: z) *. z <: p_high
  q=. (v#z) - 0.5
  r=. *:q
  s=. (q * (a p. r) % b p. r) (I.v)} s
  NB.    Rational approximation for upper region.
  v=. (p_high < z) *. z < 1
  q=. %: _2* ^. 1- v#z
  s=. (-(c p. q) % d p. q) (I.v)} s
  NB.   equal to 0 or 1
  s=. __ (I. z=0)} s
  s=. _ (I. z=1)} s
  
  ($y)$s
)

qnorm01_acklam_accurate=: 3 : 0
  z=. ,y
  s=. qnorm01_acklam_fast z  
  
  NB. Refinement using Halley's rational method
  v=. (0 < z)*.  z < 1
  q=. v#s                         NB. x
  e=. (v#z) -~ -: erfc  -q% %:2   NB. error
  u=. e * (%:2p1) * ^ (*:q) % 2   NB. f(z)/df(z)
  NB. q=. q - u                   NB. Newton's method
  s=. (q - u% >:q*u%2) (I.v)}s    NB. Halley's method
  ($y)$s
)
}}}

=== rnorm01 ===

BrianSchott, RicSherlock and others contributed code to the
[[JForum:programming/2008-August/011684|forum discussion]] of this function. This explicit version below 
follows closely the Box-Muller form of Schott and shows the 
structure of steps in the code more clearly for those not 
experienced with the tacit form. However the tacit version 
used in the `normal.ijs` script is leaner. 
{{{
rnorm01=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. runif01 n
  b=. 2* o. runif01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)
}}}

== See Also ==
 * [[Essays/Normal CDF]]
 * [[Essays/Extended Precision Functions]]
 * [[http://www.jsoftware.com/|stats/base/distributions.ijs script]]
 * Ewart Shaw's Vector article [[http://www.vector.org.uk/archive/v184/|Hypergeometric Functions and CDFs in J]]
 * [[JForum:programming/2008-August/011684|Forum thread]] on generating standard normal variates
 * [[JForum:programming/2008-September/011978|Forum thread]] on Inverse Normal CDF
 * [[http://home.online.no/~pjacklam/notes/invnorm/|P J Acklam's algorithm]] for Inverse Normal CDF
 * [[EwartShaw/N01CdfInv]]

== Contributed by ==
  FraserJackson and RicSherlock
