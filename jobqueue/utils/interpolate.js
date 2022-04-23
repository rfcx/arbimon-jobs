module.exports = function interpolate(string, hash){
    return string.replace(/{{([^}]+)}}/, function(_0, _1){
        var comps = _1.split('.'), o = hash;
        while(o && comps.length){
            var c = comps.shift();
            o = o[c];
        }
        return ''+o;
    });
};
