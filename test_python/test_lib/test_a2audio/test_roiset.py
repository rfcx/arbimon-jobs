import unittest
from random import randint
import numpy

def gen_random_matrix(rows,cols):
    chunckLength = 20
    randomStart = randint(chunckLength,min(100,cols))
    chucnkJump = 3
    chunckLessLength = chunckLength*chucnkJump
    chunks = int((float(cols-randomStart))/(float(chunckLessLength+chunckLength)))
    mm = numpy.zeros(shape=(rows,cols))
    jump = 0
    for i in range(randomStart,cols-chunckLength,chunckLength):
        if jump == 0:
            mm[:,i:(i+chunckLength)] = numpy.ones(shape=(rows,chunckLength))
        jump = (jump+1)%chucnkJump
    return mm

def gen_random_roiset(outputFile):
    from a2audio.roiset import Roiset
    import cPickle as pickle
    from random import randint
    import numpy
    lowFreqs = []
    highFreqs = []
    sample_rate = 44100
    specs = []
    rows = 256
    columns = []
    roiCount = 10 
    roisetTest = Roiset("class",sample_rate)
    for i in range(roiCount):
        lowFreqs.append(randint(1000,2000))
        highFreqs.append(randint(3000,4000))
        columns.append(randint(600,700))
        specs.append(gen_random_matrix(rows,columns[i]))
        roisetTest.addRoi(lowFreqs[i],highFreqs[i],sample_rate,specs[i],rows,columns[i])
     
    i=roiCount    
    lowFreqs.append(randint(1000,2000))
    highFreqs.append(randint(3000,4000))
    columns.append(randint(701,800))
    specs.append(gen_random_matrix(rows,columns[i]))
    roisetTest.addRoi(lowFreqs[i],highFreqs[i],sample_rate,specs[i],rows,columns[i])
    
    roisetTest.alignSamples()
    with open(outputFile, 'wb') as output:
        pickler = pickle.Pickler(output, -1)
        pickle.dump([lowFreqs,highFreqs,sample_rate,specs,rows,columns,roisetTest.getSurface()], output, -1)
        
class Test_roiset(unittest.TestCase):
    
    def test_import_roi(self):
        """Test Roiset module can be imported"""
        try:
            from a2audio.roiset import Roi
        except ImportError:
            self.fail("Cannot load a2audio.roi module")
    
    def test_roi_init(self):
        """Test Roiset.py Roi init arguments"""
        from a2audio.roiset import Roi
        import numpy
        spec = numpy.zeros(shape=(10,10))     
        """Test invalid arguments"""
        raisingargs3 =[
            [[1],1,1,spec],
            ["1",1,1,spec],
            [1,[1],1,spec],
            [1,"1",1,spec],
            [1,2,'1',spec],
            [1,2,'1','1']
        ]
        for ar in raisingargs3:
            self.assertRaises(ValueError,Roi,ar[0],ar[1],ar[2],ar[3])
            
        self.assertIsInstance( Roi(1,2,1,spec) ,Roi,msg="Roiset.py Roi class initiation was not succesful")
        
    def test_import_roiset(self):
        """Test Roiset module can be imported"""
        try:
            from a2audio.roiset import Roiset
        except ImportError:
            self.fail("Cannot load a2audio.roiset module")

    def test_init(self):
        """Test Roiset init arguments"""
        from a2audio.roiset import Roiset   
        """Test invalid arguments"""
        raisingargs3 =[
            [[1],1],
            [1,'1']
        ]
        for ar in raisingargs3:
            self.assertRaises(ValueError,Roiset,ar[0],ar[1])
            
        self.assertIsInstance( Roiset(1,2) ,Roiset,msg="Roiset class initiation was not succesful")
        self.assertIsInstance( Roiset("1",2) ,Roiset,msg="Roiset class initiation was not succesful")

    def test_addRoi(self):
        """Test Roiset.addRoi function"""
        # lowFreq,highFreq,sample_rate,spec,rows,columns
        from a2audio.roiset import Roiset
        from random import randint
        import numpy
        lowFreqs = []
        highFreqs = []
        sample_rate = 44100
        specs = []
        rows = 256
        columns = []
        roiCount = 10 
        roisetTest = Roiset("class",sample_rate)
        for i in range(roiCount):
            lowFreqs.append(randint(1000,2000))
            highFreqs.append(randint(3000,4000))
            columns.append(randint(500,600))
            specs.append(numpy.random.rand(rows,columns[i]))
            roisetTest.addRoi(lowFreqs[i],highFreqs[i],sample_rate,specs[i],rows,columns[i])
         
        i=roiCount    
        lowFreqs.append(randint(1000,2000))
        highFreqs.append(randint(3000,4000))
        columns.append(randint(601,700))
        specs.append(numpy.random.rand(rows,columns[i]))
        roisetTest.addRoi(lowFreqs[i],highFreqs[i],sample_rate,specs[i],rows,columns[i])
        
        insertedData = roisetTest.getData()
        self.assertEqual(max(columns),insertedData[6],msg="Roiset.addRoi failed to determine roi with maxumum columns")
        self.assertEqual(max(highFreqs),insertedData[5],msg="Roiset.addRoi failed to determine roi with highest frequency")
        self.assertEqual(min(lowFreqs),insertedData[4],msg="Roiset.addRoi failed to determine roi with lowest frequency")
        self.assertEqual(roiCount+1,insertedData[2],msg="Roiset.addRoi has the incorrect number of Rois")
        self.assertEqual(rows,insertedData[1],msg="Roiset.addRoi has the incorrect number of rows")
        biggestRoi = insertedData[3]
        for ii in range(specs[i].shape[0]):
           for j in range(specs[i].shape[1]):
               self.assertEqual(specs[i][ii,j],biggestRoi[ii,j],msg="Roiset.addRoi saved wrong biggest spec")
               
        allRois = insertedData[0]
        for jj in range(roiCount+1):
            roi = allRois[jj].getData()
            for ii in range(roi[3].shape[0]):
                for j in range(roi[3].shape[1]):
                    self.assertEqual(specs[jj][ii,j],roi[3][ii,j],msg="Roiset.addRoi saved wron spec")           
               
    def test_alignSamples(self):
        """Test Roiset.alignSamples function"""
        from a2audio.roiset import Roiset
        import cPickle as pickle
        from random import randint
        import numpy
        import sys
        is_64bits = sys.maxsize > 2**32
        datainput = None
        if is_64bits:
            with open("test_python/data/alignSamples.test.data", 'rb') as datain:
                datainput = pickle.load(datain)
        else:
            with open("test_python/data/alignSamples.test.data.32", 'rb') as datain:
                datainput = pickle.load(datain)
        lowFreqs = datainput[0]
        highFreqs = datainput[1]
        sample_rate = datainput[2]
        specs = datainput[3]
        rows = datainput[4]
        columns = datainput[5]
        compareSurface = datainput[6]
        roisetTest = Roiset("class",sample_rate)
        for i in range(len(specs)):
            roisetTest.addRoi(lowFreqs[i],highFreqs[i],sample_rate,specs[i],rows,columns[i])       
        roisetTest.alignSamples()
        testSurface = roisetTest.getSurface()
        for ii in range(compareSurface.shape[0]):
           for j in range(compareSurface.shape[1]):
               self.assertEqual(compareSurface[ii,j],testSurface[ii,j],msg="Roiset.alignSamples did not aligned exactly")        
            
if __name__ == '__main__':
    unittest.main()

