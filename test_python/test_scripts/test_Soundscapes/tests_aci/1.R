test.aci_nofile <- function()
{
    checkEquals("err3", work_aci('/not/a/valid/file'),msg=": No file, should give error (err3)")
}
test.aci_shortfile <- function()
{
    checkEquals('err4', work_aci('test_python/data/short.wav'),msg=": short file should give error (err5)")
} 
test.aci_value <- function()
{
    checkEquals(150.7278, work_aci('test_python/data/test.wav'),msg=": invalid value returned")
} 
test.deactivation <- function()
{
    DEACTIVATED('Deactivating this test function')
}
