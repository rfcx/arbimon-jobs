test.h_nofile <- function()
{
    checkEquals("err3", work_h('/not/a/valid/file'),msg=": No file, should give error (err3)")
}
test.h_shortfile <- function()
{
    checkEquals('err4', work_h('test_python/data/short.wav'),msg=": short file should give error (err5)")
} 
test.h_value <- function()
{
    checkEquals(0.3458347, work_h('test_python/data/test.wav'),msg=": invalid value returned")
} 
