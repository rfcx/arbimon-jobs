args = commandArgs(TRUE)
suppressMessages(suppressWarnings(library(seewave)))
suppressMessages(suppressWarnings(library(tuneR)))
work_fpeaks = function(argss)
{
    archivo = FALSE
    tryCatch(
        {
           archivo<- readWave(argss[1])
        }
        ,
        error = function(e)
        {
            return('err0')
            quit()
        }   
    );
    AmplPeaks = c()
    if(class(archivo) == 'Wave')
    {
        if(length(archivo@left)>archivo@samp.rate)# at least one second of audio
        {
            bin_size = as.numeric(argss[3])
            picos = c()
            spec = c()
            srate = archivo@samp.rate
            n = floor((srate)/bin_size) # search for the next power of two
            n = n - 1
            n = bitwOr(n,bitwShiftR(n, 1) )
            n = bitwOr(n,bitwShiftR(n, 2)  )
            n = bitwOr(n,bitwShiftR(n, 4) )
            n = bitwOr(n,bitwShiftR(n, 8) )
            n = bitwOr(n,bitwShiftR(n, 16) )
            windowsize = n + 1
            tryCatch(
                {
                    spec <- meanspec(archivo, f=srate, plot=FALSE,wl=windowsize)
                }
                ,
                error = function(e)
                {
                    return('err1')
                    quit()
                }
            );
            epsilonValue = 0.00001
            if(as.numeric(argss[2]) > 0.00001)
            {
                epsilonValue = as.numeric(argss[2])
            }
             
            tryCatch(
                {
                    #,amp=c(0.01,0.01)
                    picos<-fpeaks(spec,freq=as.numeric(argss[4]),plot=FALSE,threshold=epsilonValue)
                }
                ,
                error = function(e)
                {
                    return('err2')
                    quit()
                }
            );
            
            if( is.na(picos) || length(picos) < 1)
            {
               return('err3')
            }
            else
            {
               picos[is.na(picos)]<-0
               p<-dim(picos)
               retStr = ''
               if (p[1]>=1)
               {
                   pico<-data.frame(picos)
                   retStr = paste(pico[1,1],sep=",")
                   ii = 2
                   while(ii <=length(pico[,1]))
                   {
                        retStr = paste(retStr,pico[ii,1],sep=",")
                        ii = ii + 1
                   }

                   return(retStr)
               }else return ('err4')
            }      
        
        }else return('err5')
    }else return('err5')
}
if(length(args) >=4)
{
    cat(work_fpeaks(args))
}
