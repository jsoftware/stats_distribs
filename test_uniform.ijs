NB.  Tests for stats/distribs/uniform

Note 'To run all tests:'
  load 'stats/distribs/uniform'
  load 'stats/distribs/test_uniform'
)

  v0=: 0.1*i.11
  v1=: 0.1*>:i.9

test_uniform=: 3 : 0
  
  assert. 1 = dunif v1
  assert. 0 0 0 1r3 1r3 1r3 1r3 0 0 = 2 5 dunif __ 0 1 2 3 4 5 6 __
  assert. 0.1 = 2 12 dunif 2+10*v1
  assert. v0 = punif v0
  assert. v1 = 2 12 punif 2 + 10*v1
  assert. 0 0 0 0 1 1 1 = 2 5 punif __ _1 0 2 5 6 _
  assert. v0 = qunif v0
  assert. (2.3+0.3*i.9) = 2 5 qunif v1
  assert. (v3>:2)*.v3<:5 [ v3=. ,v4=. 2 5 runif 10 10 10
  assert. 10 10 10 = $v4

  'functions for uniform distribution passed tests'
)

smoutput test_uniform''
