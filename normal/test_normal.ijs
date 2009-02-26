NB. =========================================================
NB. Tests for stats/normal
  load '~Addons/stats/normal/normal.ijs'
  ts=: 6!:2 , 7!:2@]
  tsterr=: 0 0.6 0.3 1.1
  tst=:  0 1 0.158655253931457 0.977249868051821 2.86651571879194e_7 0.5 0.4 0.85 0.72 0.11
  tst1=: 10000$tst
  tst2=: 100000$ 2}.tst
  qnorm01B_pnormal_ tsterr     NB. should be assertion failure
  NB. sizes of differences between answers that are not equal
  ([: (qnorm01B_pnormal_ - qnorm) ] #~ [: -. qnorm01B_pnormal_ = qnorm) tst
  ([: (qnorm01B_pnormal_ - qnorm01S_pnormal_) ] #~ [: -. qnorm01B_pnormal_ = qnorm01S_pnormal_) tst

  50 ts 'qnorm01B_pnormal_ tst1'
  50 ts 'qnorm tst1'
  50 ts 'qnorm01_pnormal_ tst1'
  50 ts 'qnorm01S_pnormal_ tst1'
  5  ts 'qnorm01B_pnormal_ tst2'
  5  ts 'qnorm tst2'
  5  ts 'qnorm01_pnormal_ tst2'
  5  ts 'qnorm01S_pnormal_ tst2'
