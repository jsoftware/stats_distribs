NB. Tests for stats/distribs/normal

Note 'To run all tests:'
  load 'stats/distribs/normal'
  load 'stats/distribs/test_normal'
)

NB. make nouns for testing
  tsterr=: 0 0.6 0.3 1.1
  tst=:  0 1 0.158655253931457 0.977249868051821 2.86651571879194e_7 0.5 0.4 0.85 0.72 0.11
  tst1=: 10000$tst
  tst2=: 100000$ 2}.tst
  NB. from Handbook of Mathematical Functions by Abramowitz and Stegun, Table 26.1 and Table 7.1. 
  t26d1=: 0.5 0.841344746068543 0.977249868051821 0.97500210485178 0.99505998424223
  t7d1=: 0 0.8427007929 0.9953222650 0.9944262755

  tst3=: 0 1 0.5 0.0001 0.9999999 0.5111111 0.4999999

NB. test verb here
test=: 3 : 0
  
  assert. *./  t26d1 = pnorm01_pnormal_ 0 1 2 1.96 2.58
  assert. *./ 1e_10 > | t7d1 - erf_pnormal_ 0 1 2 1.96
  assert. *./ 1e_10>|(pnorm01_pnormal_@qnorm01_pnormal_ - ]) tst3

NB. check that shape of y is retained in result
NB. check that atomic y work.

  'stats/distribs/test_normal passed'
)

smoutput test''
