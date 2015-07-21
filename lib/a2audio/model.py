
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
from sklearn.preprocessing import normalize
from sklearn import cross_validation
import numpy
import cPickle as pickle
from itertools import izip as zip, count
import random
import csv

class Model:

    def __init__(self,classid,speciesSpec,jobid):
        if type(classid) is not str and type(classid) is not int:
            raise ValueError("classid must be a string or int. Input was a "+str(type(classid)))
        if type(speciesSpec) is not numpy.ndarray:
            raise ValueError("speciesSpec must be a numpy.ndarray. Input was a "+str(type(speciesSpec)))
        if type(jobid) is not int:
            raise ValueError("jobid must be a int. Input was a "+str(type(jobid)))
        
        self.classid = classid
        self.speciesSpec = speciesSpec
        self.data  = numpy.zeros(shape=(0,41),dtype=numpy.dtype('float64'))
        self.classes = []
        self.uris = []
        self.minv = 9999999
        self.maxv = -9999999
        self.jobId = jobid
        
    def addSample(self,present,row,uri):
        self.classes.append(str(present))
        self.uris.append(uri)
        if self.minv >  row[3]:
            self.minv =  row[3]
        if self.maxv < row[2]:
            self.maxv = row[2]
        self.data = numpy.vstack((self.data,row))
    
    def getDataIndices(self):
        return {"train":self.trainDataIndices ,"validation": self.validationDataIndices}
    
    def splitData(self,useTrainingPresent,useTrainingNotPresent,useValidationPresent,useValidationNotPresent):
        self.splitParams = [useTrainingPresent,useTrainingNotPresent,useValidationPresent,useValidationNotPresent]
        presentIndeces = [i for i, j in zip(count(), self.classes) if j == '1' or j == 1]
        notPresentIndices = [i for i, j in zip(count(), self.classes) if j == '0' or j == 0]
        if(len(presentIndeces) < 1):
            return False
        if(len(notPresentIndices) < 1):
            return False
          
        random.shuffle(presentIndeces)
        random.shuffle(notPresentIndices)
        self.trainDataIndices = presentIndeces[:useTrainingPresent] + notPresentIndices[:useTrainingNotPresent]
        self.validationDataIndices = presentIndeces[useTrainingPresent:(useTrainingPresent+useValidationPresent)] + notPresentIndices[useTrainingNotPresent:(useTrainingNotPresent+useValidationNotPresent)]
        return True
    
    def getModel(self):
        return self.clf
    
    def getOobScore(self):
        return self.obbScore
    
    def train(self):     
        self.clf = RandomForestClassifier(n_estimators=1000,n_jobs=-1,oob_score=True)
        classSubset = [self.classes[i] for i in self.trainDataIndices]
        data = self.data[self.trainDataIndices]
        data[numpy.isnan(data)] = 0
        data[numpy.isinf(data)] = 0
        self.clf.fit(data, classSubset)
        self.obbScore = self.clf.oob_score_
    
    def k_fold_validation(self,folds=10):
        print 'stating validation'
        totalData = len(self.classes)
        kf = cross_validation.KFold(n=totalData, n_folds=folds)
        testCl = []
        predicCl = []
        for train_index, test_index in kf:
            trainData = self.data[train_index]
            testData = self.data[test_index]
            trainClasses = [self.classes[i] for i in train_index]
            testClasses = [self.classes[i] for i in test_index]
            clf = RandomForestClassifier(n_estimators=1000,n_jobs=-1)
            clf.fit(trainData, trainClasses)
            predictions = clf.predict(testData)
            for i in testClasses:
                testCl.append(i)
            for i in predictions:
                predicCl.append(i)
            del clf
            del trainData
            del trainClasses
            del testData
            del testClasses
            
        tp = 0.0
        fp = 0.0
        tn = 0.0
        fn = 0.0
        accuracy_score = 0.0
        precision_score = 0.0
        sensitivity_score = 0.0
        specificity_score  = 0.0
        totalPos = 0
        totalNeg = 0
        for i in range(len(testCl)):
            if str(testCl[i])=='1':
                totalPos = totalPos + 1
                if testCl[i] == predicCl[i]:
                    tp = tp + 1.0
                else:
                    fn = fn + 1.0
            else:
                totalNeg = totalNeg + 1
                if testCl[i] == predicCl[i]:
                    tn = tn + 1.0
                else:
                    fp = fp + 1.0
        
        if (tp+fp+tn+fn) >0:
            accuracy_score = (tp +  tn)/(tp+fp+tn+fn)
        if (tp+fp) > 0:
            precision_score = tp/(tp+fp)
        if (tp+fn) > 0:
            sensitivity_score = tp/(tp+fn)
        if (tn+fp) > 0:
            specificity_score  = tn/(tn+fp)
        print '-----------------------------------------------------------------------------------------'
        print 'accuracy_score ' ,accuracy_score 
        print 'precision_score ', precision_score 
        print 'sensitivity_score ',sensitivity_score 
        print 'specificity_score ',specificity_score
        print '-----------------------------------------------------------------------------------------'
        print 'end validation'
        return totalData,totalPos ,totalNeg ,accuracy_score,precision_score,sensitivity_score,specificity_score
    
    def validate(self):
        classSubset = [self.classes[i] for i in self.validationDataIndices]
        classSubsetTraining = [self.classes[i] for i in self.trainDataIndices]
        self.outClasses = classSubset
        self.outClassesTraining = classSubsetTraining
        self.outuris = [self.uris[i] for i in self.validationDataIndices]
        self.outurisTraining = [self.uris[i] for i in self.trainDataIndices]
        data = self.data[self.validationDataIndices]
        data[numpy.isnan(data)] = 0
        data[numpy.isinf(data)] = 0
        predictions = self.clf.predict(data)
        self.validationpredictions = predictions;
        presentIndeces = [i for i, j in zip(count(), classSubset) if j == '1' or j == 1] 
        notPresentIndices = [i for i, j in zip(count(), classSubset) if j == '0' or j == 0]
        minamxdata = self.data[self.validationDataIndices]
        minamxdata [numpy.isnan(minamxdata )] = 0
        minamxdata [numpy.isinf(minamxdata )] = 0
        minv = 99999999
        maxv = -99999999
        for row in minamxdata:
            if max(row) > maxv:
                maxv = max(row)
            if min(row) < minv:
               minv = min(row)
        self.minv = minv
        self.maxv = maxv
        self.tp = 0.0
        self.fp = 0.0
        self.tn = 0.0
        self.fn = 0.0
        self.accuracy_score = 0.0
        self.precision_score = 0.0
        self.sensitivity_score = 0.0
        self.specificity_score  = 0.0
        
        truePositives =  [classSubset[i] for i in presentIndeces]
        truePosPredicted =  [predictions[i] for i in presentIndeces]
        for i in range(len(truePositives)):
            if truePositives[i] == truePosPredicted[i]:
                self.tp = self.tp + 1.0
            else:
                self.fn = self.fn + 1.0
               
        trueNegatives = [classSubset[i] for i in notPresentIndices]
        trueNegPrediceted = [predictions[i] for i in notPresentIndices]
        for i in range(len(trueNegatives )):
            if trueNegatives[i] == trueNegPrediceted[i]:
                self.tn = self.tn + 1.0
            else:
                self.fp = self.fp + 1.0
        
        if (self.tp+self.fp+self.tn+self.fn) >0:
            self.accuracy_score = (self.tp +  self.tn)/(self.tp+self.fp+self.tn+self.fn)
        if (self.tp+self.fp) > 0:
            self.precision_score = self.tp/(self.tp+self.fp)
        if (self.tp+self.fn) > 0:
            self.sensitivity_score = self.tp/(self.tp+self.fn)
        if (self.tn+self.fp) > 0:
            self.specificity_score  = self.tn/(self.tn+self.fp)
        
    def modelStats(self):
        return [self.accuracy_score,self.precision_score,self.sensitivity_score,self.obbScore,self.speciesSpec,self.specificity_score ,self.tp,self.fp,self.tn,self.fn,self.minv,self.maxv]
    
    def save(self,filename,l,h,c,usesSsim,usesRansac,bIndex):
        with open(filename, 'wb') as output:
            pickler = pickle.Pickler(output, -1)
            pickle.dump([self.clf,self.speciesSpec,l,h,c,usesSsim,usesRansac,bIndex], output, -1)
            
    def getSpec(self):
        return self.speciesSpec
   
    def getClasses(self):
        return self.classes
    
    def getData(self):
        return self.data
    
    def saveValidations(self,filename):
        with open(filename, 'wb') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',')
            for i in range(0,len(self.outClasses)):
                spamwriter.writerow([self.outuris[i],self.outClasses[i],self.validationpredictions[i],'validation'])
            for i in range(0,len(self.outClassesTraining)):
                spamwriter.writerow([self.outurisTraining[i],self.outClassesTraining[i],'NA','training'])
                