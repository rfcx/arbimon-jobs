test.fpeaks_nofile <- function()
{
    checkEquals("err5", work_fpeaks(c('/not/a/valid/file',0,86,0)),msg=": No file, should give error (err3)")
}
test.fpeaks_shortfile <- function()
{
    checkEquals('err5', work_fpeaks(c('test_python/data/short.wav',0,86,0)),msg=": short file should give error (err5)")
} 
test.fpeaks_value <- function()
{
    checkEquals("1.4642578125,2.3255859375,3.0146484375,3.8759765625,4.306640625,4.9095703125,5.684765625,7.8380859375,8.1826171875,8.3548828125,8.61328125,8.785546875,9.30234375,9.646875,9.99140625,11.1111328125,11.2833984375,12.3169921875,13.1783203125,13.5228515625,14.0396484375,14.5564453125,15.4177734375,15.676171875,16.1068359375,16.4513671875,17.4849609375,17.915625,18.26015625,19.2076171875", work_fpeaks(c('test_python/data/test.wav',0,86,0)),msg=": invalid value returned")
} 

