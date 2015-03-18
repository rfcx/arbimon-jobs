#! /usr/bin/Rscript --vanilla 

library('RUnit')

#h.R test
source('scripts/Soundscapes/h.R')
source('scripts/Soundscapes/aci.R')
source('scripts/Soundscapes/fpeaks.R')

test.suite <- defineTestSuite("h",
                              dirs = c(file.path("test_python/test_scripts/test_Soundscapes/tests_h"),
                                        file.path("test_python/test_scripts/test_Soundscapes/tests_aci"),
                                        file.path("test_python/test_scripts/test_Soundscapes/tests_fpeaks")),
                              testFileRegexp = '^\\d+\\.R')
 
test.result <- runTestSuite(test.suite)
 
printTextProtocol(test.result)


