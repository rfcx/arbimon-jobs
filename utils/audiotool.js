var childProcess = require('child_process');

/**
Options:
−x num
    Change the (maximum) width (X-axis) of the spectrogram from its default value of 800 pixels to a given number between 100 and 200000. See also −X and −d.
−X num
    X-axis pixels/second; the default is auto-calculated to fit the given or known audio duration to the X-axis size, or 100 otherwise. If given in conjunction with −d,
    this option affects the width of the spectrogram; otherwise, it affects the duration of the spectrogram. num can be from 1 (low time resolution) to 5000 (high time
    resolution) and need not be an integer. SoX may make a slight adjustment to the given number for processing quantisation reasons; if so, SoX will report the actual
    number used (viewable when the SoX global option −V is in effect). See also −x and −d.
−y num
    Sets the Y-axis size in pixels (per channel); this is the number of frequency ‘bins’ used in the Fourier analysis that produces the spectrogram. N.B. it can be slow
    to produce the spectrogram if this number is not one more than a power of two (e.g. 129). By default the Y-axis size is chosen automatically (depending on the number
    of channels). See −Y for alternative way of setting spectrogram height.
−Y num
    Sets the target total height of the spectrogram(s). The default value is 550 pixels. Using this option (and by default), SoX will choose a height for individual
    spectrogram channels that is one more than a power of two, so the actual total height may fall short of the given number. However, there is also a minimum height
    per channel so if there are many channels, the number may be exceeded. See −y for alternative way of setting spectrogram height.
−z num
    Z-axis (colour) range in dB, default 120. This sets the dynamic-range of the spectrogram to be −num dBFS to 0 dBFS. Num may range from 20 to 180. Decreasing
    dynamic-range effectively increases the ‘contrast’ of the spectrogram display, and vice versa.
−Z num
    Sets the upper limit of the Z-axis in dBFS. A negative num effectively increases the ‘brightness’ of the spectrogram display, and vice versa.
−q num
    Sets the Z-axis quantisation, i.e. the number of different colours (or intensities) in which to render Z-axis values. A small number (e.g. 4) will give a ‘poster’-like
    effect making it easier to discern magnitude bands of similar level. Small numbers also usually result in small PNG files. The number given specifies the number of
    colours to use inside the Z-axis range; two colours are reserved to represent out-of-range values.
−s
    Allow slack overlapping of DFT windows. This can, in some cases, increase image sharpness and give greater adherence to the −x value, but at the expense of a
    little spectral loss.
−m
    Creates a monochrome spectrogram (the default is colour).
−h
    Selects a high-colour palette - less visually pleasing than the default colour palette, but it may make it easier to differentiate different levels. If this option
    is used in conjunction with −m, the result will be a hybrid monochrome/colour palette.
−p num
    Permute the colours in a colour or hybrid palette. The num parameter, from 1 (the default) to 6, selects the permutation.
 */
var audiotools = {
    sox : function(args, options, callback){
console.log('running sox with ', args)
        if(options instanceof Function) { callback = options; }
        options = options || {};
        
        var cp = childProcess.spawn('sox', args);
        var stderr = "";
        cp.stderr.setEncoding('utf8');
        cp.stderr.on('data', function(data) {
            stderr += data;
        });
        
        cp.on('close', function(code){
            console.log('sox ended with code : ', code, stderr);
            callback(code);
            
        });
    },
    transcode : function(source_path, destination_path, options, callback){
        if(options instanceof Function) { callback = options; }
        options = options || {};
        
        var args = [];
        args.push('--guard', '--magic', '--show-progress');
        args.push(source_path);
        if (options.sample_rate) {
            args.push('-r', options.sample_rate | 0);
        }
        if (options.format) {
            args.push('-t', options.format);
        }
        if (options.compression) {
            args.push('-C', options.compression | 0);
        }
        if (options.channels) {
            args.push('-c', options.channels | 0);
        }
        args.push(destination_path);
        audiotools.sox(args, {}, callback);
    },
    spectrogram : function(source_path, destination_path, options, callback){
        if(options instanceof Function) { callback = options; }
        options = options || {};
        
        var args = [];
        args.push(source_path);
        args.push('-n', 'spectrogram'); // just the raw spectrogram image
        args.push('-r', '-y', 256, '-X', 172, '-q', 249); // just the raw spectrogram image
        
        if(options.window && options.window in ['Hann', 'Hamming', 'Bartlett', 'Rectangular', 'Kaiser']) {
            args.push('-w', options.window); // just the raw spectrogram image
            if(options.window == 'Kaiser' && options.window_shape) {
                args.push('-W', options.window_shape); // just the raw spectrogram image
            }
        }
        args.push('-m');
        args.push('-o', destination_path);
        audiotools.sox(args, {}, callback);
    }
}


module.exports = audiotools;