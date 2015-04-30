import numpy
from pylab import *

def gen_random_matrices(rows,cols,rand=True):
    """Generates random stripped matrix"""
    chunckLength = 20
    randomStart = 25#randint(chunckLength,min(100,cols))
    chucnkJump = 3
    chunckLessLength = chunckLength*chucnkJump
    chunks = int((float(cols-randomStart))/(float(chunckLessLength+chunckLength)))
    if rand:
        mm = numpy.random.rand(rows,cols)
    else:
        mm = numpy.zeros(shape=(rows,cols))    
    jump = 0
    dd = [.9,.95,.99]
    for i in range(randomStart,cols-chunckLength,chunckLength):
        if jump == 0:
            mm[:,i:(i+chunckLength)] = numpy.ones(shape=(rows,chunckLength))*dd[randint(0,2)]
        jump = (jump+1)%chucnkJump
    z = numpy.zeros(shape=(1116,mm.shape[1]))
    if mm.shape[0] == 1116:
        z = mm
    else:
        z[(max(0,1116-mm.shape[0]-1)):1115,:] = mm
    pattern = numpy.copy(mm[:,490:550])
    if rand:
        matrix = numpy.random.rand(1116,650*2)
    else:
        matrix = numpy.zeros(shape=(1116,650*2))
    ii=650/2
    if mm.shape[0] == 1116:
        matrix[:,ii:(ii+650)] = mm
    else:
        matrix[(max(0,1116-mm.shape[0]-1)):1115,ii:(ii+650)] = mm
    return pattern,matrix

pattern,matrix=gen_random_matrices(279,650,False)
f = figure()
f.add_subplot(2,1,1)
imshow(pattern)
f.add_subplot(2,1,2)
imshow(matrix)
show()
