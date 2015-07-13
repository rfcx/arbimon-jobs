import unittest
import mock
from mock import mock_open
from mock import MagicMock

class Test_model(unittest.TestCase):

    def test_import(self):
        """Test Model module can be imported"""
        try:
            from a2audio.model import Model
        except ImportError:
            self.fail("Cannot load a2audio.model module")
            
    def test_init(self):
        """Test Model init arguments"""
        from a2audio.model import Model
        import numpy
        spec = numpy.zeros(shape=(10,10))
        
        """Test invalid arguments"""
        raisingargs3 =[
            [[1],spec,1],
            ["1",[1],1],
            ["1",1,1],
            [1,spec,[1]],
            [1,spec,"1"]
        ]
        
        for ar in raisingargs3:
            self.assertRaises(ValueError,Model,ar[0],ar[1],ar[2])
            
        """Test valid arguments"""
        self.assertIsInstance( Model(1,spec,1) , Model,msg="Rec.model initiation was not succesful")
        self.assertIsInstance( Model("1",spec,1) , Model,msg="Rec.model initiation was not succesful")
        
    def test_getSpec(self):
        """Test Model spec assignment"""
        from a2audio.model import Model
        import numpy
        spec = numpy.random.rand(100,100)
        mod1 = Model(1,spec,1)
        spec2 = mod1.getSpec()
        for i in range(spec.shape[0]):
            for j in range(spec.shape[1]):
                self.assertEqual(spec[i,j],spec2[i,j],msg="Model.getSpec returned invalid data")

    @unittest.skip("test is broken. #by:@gio: jul 13 2015")
    def test_addSample(self):
        """Test Model addSample function"""
        from a2audio.model import Model
        import numpy
        spec = numpy.random.rand(100,100)
        mod1 = Model(1,spec,1)
        dummyData = numpy.random.rand(100,41)
        
        for i in range(100):
            r = dummyData[i,]
            mod1.addSample(i,r,"dummy/uri/"+str(i))
   
        modData = mod1.getData()
        modClasses = mod1.getClasses()
        for i in range(100):
            r = dummyData[i,]
            mr = modData[i,]
            mcr = modClasses[i]
            self.assertEqual(i,mcr,msg="Model.addSample inserted bad data")
            for j in range(len(r)):
                self.assertEqual(r[j],mr[j],msg="Model.getSpec inserted bad data")

    def test_splitData(self):
        """Test Model splitData function"""
        from random import randint
        from a2audio.model import Model
        import numpy
        spec = numpy.random.rand(100,100)
        mod1 = Model(1,spec,1)
        dummyData0 = numpy.random.rand(100,41)
        for i in range(100):
            r = dummyData0[i,]
            mod1.addSample('0',r,"dummy/uri/"+str(i))
        dummyData1 = numpy.random.rand(100,41)
        for i in range(100):
            r = dummyData1[i,]
            mod1.addSample('1',r,"dummy/uri/"+str(i))
        
        #10 random tries
        for tries in range(10):
            utp = randint(25,75)
            utnp = randint(25,75)
            uvp = randint(15,100-utp-1)
            uvnp = randint(15,100-utnp-1)
            
            mod1.splitData(utp,utnp,uvp,uvnp)
            modData = mod1.getClasses()
            modIndices = mod1.getDataIndices()
            trainClasses = [modData[i] for i in modIndices['train']]
            validationClasses = [modData[i] for i in modIndices['validation']]
            
            zc =0
            oc =0
            for i in trainClasses:
                if i == '0':
                    zc = zc + 1
                if i == '1':
                    oc = oc + 1
            self.assertEqual(oc,utp,msg="Model.splitData failed")
            self.assertEqual(zc,utnp,msg="Model.splitData failed")
            zc =0
            oc =0
            for i in validationClasses:
                if i == '0':
                    zc = zc + 1
                if i == '1':
                    oc = oc + 1
            self.assertEqual(oc,uvp,msg="Model.splitData failed")
            self.assertEqual(zc,uvnp,msg="Model.splitData failed")

    def test_train(self):
        """Test Model train function"""
        from random import randint
        from a2audio.model import Model
        import numpy
        from sklearn.ensemble import RandomForestClassifier
        spec = numpy.random.rand(100,100)
        mod1 = Model(1,spec,1)
        dummyData0 = numpy.random.rand(100,41)
        for i in range(100):
            r = dummyData0[i,]
            mod1.addSample('0',r,"dummy/uri/"+str(i))
        dummyData1 = numpy.random.rand(100,41)+100
        for i in range(100):
            r = dummyData1[i,]
            mod1.addSample('1',r,"dummy/uri/"+str(i))

        #try creating a model 5 times
        for tries in range(5):
            utp = randint(25,75)
            utnp = randint(25,75)
            uvp = randint(15,100-utp-1)
            uvnp = randint(15,100-utnp-1)
            
            mod1.splitData(utp,utnp,uvp,uvnp)
            mod1.train()
            modResult = mod1.getModel()
            self.assertIsInstance( modResult, RandomForestClassifier,msg="Rec.model cannot train model")
            self.assertGreater(mod1.getOobScore(),.9,msg="Rec.model training dataset should have more than .9 oobScore accuracy")
        
    @unittest.skip("FIX ME: Test is broken - gio Jul 2, 2015")
    def test_validate(self):
        """Test Model.validate function"""
        from random import randint
        from a2audio.model import Model
        import numpy
        from sklearn.ensemble import RandomForestClassifier
        spec = numpy.random.rand(100,100)
        mod1 = Model(1,spec,1)
        
        #put data into model
        #class 0 has a mean of around .5
        dummyData0 = numpy.random.rand(100,41)
        for i in range(100):
            r = dummyData0[i,]
            mod1.addSample('0',r,"dummy/uri/"+str(i))
        #class 1 has a mean of around 100.5
        dummyData1 = numpy.random.rand(100,41)+100
        for i in range(100):
            r = dummyData1[i,]
            mod1.addSample('1',r,"dummy/uri/"+str(i))

        #try creating a GOOD model 5 times
        for tries in range(5):
            utp = randint(25,75)
            utnp = randint(25,75)
            uvp = randint(15,100-utp-1)
            uvnp = randint(15,100-utnp-1)
            
            mod1.splitData(utp,utnp,uvp,uvnp)
            mod1.train()
            modResult = mod1.getModel()
            self.assertIsInstance( modResult, RandomForestClassifier,msg="Rec.model cannot train model")
            self.assertGreater(mod1.getOobScore(),.9,msg="Rec.model training dataset should have more than .9 oobScore accuracy")
            mod1.validate()
            mstats = mod1.modelStats()
            for i in range(4):
                self.assertGreater(mstats[i],.9,msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(mstats[5],.9,msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(mstats[6],uvp-5,msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(5,mstats[7],msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(mstats[8],uvnp-5,msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(5,mstats[9],msg="Rec.model training  validation dataset bad stats")
            
        #clean model and put some bad data
        del mod1
        mod1 = Model(1,spec,1)
        dummyData0 = numpy.random.rand(100,41)
        for i in range(100):
            r = dummyData0[i,]
            mod1.addSample('0',r,"dummy/uri/"+str(i))
            mod1.addSample('1',r,"dummy/uri/"+str(i))

        #try creating a BAD model 5 times
        for tries in range(5):
            utp = randint(25,75)
            utnp = randint(25,75)
            uvp = randint(15,100-utp-1)
            uvnp = randint(15,100-utnp-1)
            
            mod1.splitData(utp,utnp,uvp,uvnp)
            mod1.train()
            modResult = mod1.getModel()
            self.assertIsInstance( modResult, RandomForestClassifier,msg="Rec.model cannot train model")
            self.assertGreater(.9,mod1.getOobScore(),msg="Rec.model training bad dataset should not have more than .9 oobScore accuracy")
            mod1.validate()
            mstats = mod1.modelStats()
            for i in range(4):
                self.assertGreater(.9,mstats[i],msg="Rec.model training  validation dataset bad stats")
            self.assertGreater(.9,mstats[5],msg="Rec.model training  validation dataset bad stats")
  
    @unittest.skip("Broken test (jul 1, 2015)")
    def test_save(self):
        """Test Model.save function"""
        from random import randint
        from a2audio.model import Model
        import numpy
        from sklearn.ensemble import RandomForestClassifier
        spec = numpy.random.rand(100,100)
        m = mock_open()
        mock_pickle = MagicMock()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('cPickle.dump',mock_pickle,create=False):
                mod1 = Model(1,spec,1)
                
                #put data into model
                #class 0 has a mean of around .5
                dummyData0 = numpy.random.rand(100,41)
                for i in range(100):
                    r = dummyData0[i,]
                    mod1.addSample('0',r,"dummy/uri/"+str(i))
                #class 1 has a mean of around 100.5
                dummyData1 = numpy.random.rand(100,41)+100
                for i in range(100):
                    r = dummyData1[i,]
                    mod1.addSample('1',r,"dummy/uri/"+str(i))
        
                utp = randint(25,75)
                utnp = randint(25,75)
                uvp = randint(15,100-utp-1)
                uvnp = randint(15,100-utnp-1)
                
                mod1.splitData(utp,utnp,uvp,uvnp)
                mod1.train()
                mod1.validate()
        
                saveFileName = "/tmp/test.model.pickle"
                mod1.save(saveFileName,1.1,100.1,10000.1,True,1,2)
                self.assertTrue(m.called,msg="Rec.model cannot open file")
                self.assertIsNone( m.assert_called_once_with(saveFileName , 'wb'),  msg="Rec.model cannot write file")                
                writtenData =  mock_pickle.mock_calls[0]
                spec1 = writtenData[1][0][1]
                for i in range(spec.shape[0]):
                    for j in range(spec.shape[1]):
                        self.assertEqual(spec[i,j],spec1[i,j],msg="Model.save saved wrong data")
                self.assertEqual(writtenData[1][0][2],1.1,msg="Model.save saved wrong data")
                self.assertEqual(writtenData[1][0][3],100.1,msg="Model.save saved wrong data")
                self.assertEqual(writtenData[1][0][4],10000.1,msg="Model.save saved wrong data")

    
    def test_saveValidations(self):
        """Test Model.saveValidations function"""
        from random import randint
        from a2audio.model import Model
        import numpy
        from sklearn.ensemble import RandomForestClassifier
        import os
        spec = numpy.random.rand(100,100)
        
        m = mock_open()
        mock_writerow = MagicMock()
        with mock.patch('__builtin__.open', m, create=False):
            with mock.patch('csv.writer',mock_writerow,create=False):
                mod1 = Model(1,spec,1)
                
                #put data into model
                #class 0 has a mean of around .5
                dummyData0 = numpy.random.rand(100,41)
                for i in range(100):
                    r = dummyData0[i,]
                    mod1.addSample('0',r,"dummy/uri/"+str(i))
                #class 1 has a mean of around 100.5
                dummyData1 = numpy.random.rand(100,41)+100
                for i in range(100):
                    r = dummyData1[i,]
                    mod1.addSample('1',r,"dummy/uri/"+str(i))
        
                utp = randint(25,75)
                utnp = randint(25,75)
                uvp = randint(15,100-utp-1)
                uvnp = randint(15,100-utnp-1)
                
                mod1.splitData(utp,utnp,uvp,uvnp)
                mod1.train()
                mod1.validate()
        
                saveFileName = "/tmp/test.validations.csv"
                mod1.saveValidations(saveFileName)
                self.assertTrue(m.called,msg="Rec.model validation file could not be saved")
                self.assertIsNone(m.assert_called_once_with(saveFileName , 'wb'),msg="Rec.model validation file could not be saved")
                self.assertEqual(len(mock_writerow.mock_calls)-1,utp+utnp+uvp+uvnp,msg="Rec.model validation file has incorrect number of rows")
                
if __name__ == '__main__':
    unittest.main()
