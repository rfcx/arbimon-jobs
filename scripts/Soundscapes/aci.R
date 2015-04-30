args = commandArgs(TRUE)
suppressMessages(suppressWarnings(library(seewave)))
suppressMessages(suppressWarnings(library(tuneR)))
work_aci = function(argss)
{
    archivo = FALSE
    tryCatch(
        {
           archivo<- readWave(argss)
        }
        ,
        error = function(e)
        {
            return ('err0')
        }   
    );
    AmplPeaks = c()
    if(class(archivo) == 'Wave')
    {
        if(length(archivo@left)>archivo@samp.rate)# at least one second of audio
        {
            value = FALSE
            tryCatch(
                {
                    value = ACI(archivo)
                }
                ,
                error = function(e)
                {
                    return ('err1')
                }
            );
            
            if(!value)
            {
                return('err2')
            }
            else
            {
                return(value)
            }
            
        }else return ('err4')
    }else return ('err3')
}
if(length(args) >=1)
{
    cat(work_aci(args[1]))
}
