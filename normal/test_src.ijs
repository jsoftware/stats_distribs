NB. test
NB.!not required for J7 Proj Manager
buildproject_jproject_ ''
loadtarget_jproject_ ''
TestPath=. getpath_j_ (#getpath_j_ PROJECTFILE_jproject_)}.TESTFILE_jproject_
TestFile=.'test_',(#@getpath_j_ }. ]) TARGETFILE_jproject_
loadscript_jproject_ TestPath,TestFile
