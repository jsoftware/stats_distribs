NB. postbuild for distribs projects
NB.
NB. copies test file to y to ~Addons/stats/distribs
NB.! not required for J7 Proj Manager.

require 'files'

f=. 3 : 0
fm=. jpath PROJECTPATH_jproject_,y
to=. jpath PROJECTPATH_jproject_,'../',y
to fcopynew fm
)

TestFile=.'test_',(#@getpath_j_ }. ]) TARGETFILE_jproject_

f TestFile
