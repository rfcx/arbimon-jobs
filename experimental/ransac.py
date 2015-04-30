 # 2033  sudo apt-get install python-opencv
 # 2037  sudo add-apt-repository --yes ppa:xqms/opencv-nonfree
 # 2038  sudo apt-get update 
 # 2039  sudo apt-get install libopencv-nonfree-dev

import scipy.io.wavfile
from pylab import *
import numpy
import warnings
import cv2
from cv import *
import numpy as np
import cv2
from matplotlib import pyplot as plt

def plots(s):
    fig, ax = subplots(figsize=(25, 15))
    ax.imshow(s,aspect='auto')
    show()

def drawMatches(img1, kp1, img2, kp2, matches):
    """
    My own implementation of cv2.drawMatches as OpenCV 2.4.9
    does not have this function available but it's supported in
    OpenCV 3.0.0

    This function takes in two images with their associated 
    keypoints, as well as a list of DMatch data structure (matches) 
    that contains which keypoints matched in which images.

    An image will be produced where a montage is shown with
    the first image followed by the second image beside it.

    Keypoints are delineated with circles, while lines are connected
    between matching keypoints.

    img1,img2 - Grayscale images
    kp1,kp2 - Detected list of keypoints through any of the OpenCV keypoint 
              detection algorithms
    matches - A list of matches of corresponding keypoints through any
              OpenCV keypoint matching algorithm
    """

    # Create a new output image that concatenates the two images together
    # (a.k.a) a montage
    rows1 = img1.shape[0]
    cols1 = img1.shape[1]
    rows2 = img2.shape[0]
    cols2 = img2.shape[1]
    emptySpace = 50
    out = np.zeros((max([rows1,rows2]),cols1+cols2+emptySpace,3), dtype='uint8')

    # Place the first image to the left
    out[:rows1,:cols1,:] = np.dstack([img1, img1, img1])

    # Place the next image to the right of it
    out[:rows2,cols1+emptySpace:cols1+cols2+emptySpace,:] = np.dstack([img2, img2, img2])

    # For each pair of points we have between both images
    # draw circles, then connect a line between them
    for mat in matches:

        # Get the matching keypoints for each of the images
        img1_idx = mat.queryIdx
        img2_idx = mat.trainIdx

        # x - columns
        # y - rows
        (x1,y1) = kp1[img1_idx].pt
        (x2,y2) = kp2[img2_idx].pt

        # Draw a small circle at both co-ordinates
        # radius 4
        # colour blue
        # thickness = 1
        cv2.circle(out, (int(x1),int(y1)), 4, (255, 0, 0), 1)   
        cv2.circle(out, (int(x2)+cols1+emptySpace,int(y2)), 4, (255, 0, 0), 1)

        # Draw a line in between the two points
        # thickness = 1
        # colour blue
        cv2.line(out, (int(x1),int(y1)), (int(x2)+cols1,int(y2)), (255, 0, 0), 1)


    # Show the image
    plots(out)
    #cv2.imshow('Matched Features', out)
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()

inputAudio = '/home/rafa/Desktop/sp35/rec-2010-12-14_00-00.wav'
fs=None
au=None
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fs,au = scipy.io.wavfile.read(inputAudio)

sp,fqs,b = mlab.specgram(au,NFFT=512,Fs=fs,noverlap=256)

inputAudio2 = '/home/rafa/Desktop/sp36/rec-2010-12-14_00-01.wav'
fs2=None
au2=None
with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fs2,au2 = scipy.io.wavfile.read(inputAudio2)

sp2,fqs2,b2 = mlab.specgram(au2,NFFT=512,Fs=fs2,noverlap=256)

pattern = numpy.flipud(10*numpy.log10(sp[1:,]))[150:220,350:520]
pattern = ((pattern-numpy.min(numpy.min(pattern)))/(numpy.max(numpy.max(pattern))-numpy.min(numpy.min(pattern))))*255
pattern = pattern.astype('uint8')

#plots(pattern)

# sift = cv2.SIFT(nfeatures=0, nOctaveLayers=3, contrastThreshold=0.04, edgeThreshold=15, sigma=1.6)
# kp,points = sift.detectAndCompute(spec,None)
# img=cv2.drawKeypoints(spec,kp)
# #plots(img)
# 
# kpPattern,pointsPattern = sift.detectAndCompute(pattern,None)
# imgPattern=cv2.drawKeypoints(pattern,kpPattern)
# #plots(imgPattern)
# print pointsPattern,points
# 
# corrps = cv2.findHomography(pointsPattern,points,CV_RANSAC)

MIN_MATCH_COUNT = 10

img1 = pattern          # queryImage
#img2 = spec # fullImage
specc = numpy.flipud(10*numpy.log10(sp2[1:,]))[150:220,]
specc = ((specc-numpy.min(numpy.min(specc)))/(numpy.max(numpy.max(specc))-numpy.min(numpy.min(specc))))*255
speccc=specc.astype('uint8')

# currColumns = speccc.shape[1]
# fgbg = cv2.BackgroundSubtractorMOG()
# fgbg2 = cv2.BackgroundSubtractorMOG()
# i = 0
# fullMask = numpy.zeros(speccc.shape)
# for j in range(0,currColumns - pattern.shape[1],pattern.shape[1]):
#     
#     if i % 2 == 0:
#         del fgbg
#         fgbg = cv2.BackgroundSubtractorMOG()
#         
#     i = i + 1
#     frame = speccc[:,j:(j+pattern.shape[1])]
#     fgmask = fgbg.apply(frame)
#     
#     if i % 2 == 0:
#         fullMask[:,j:(j+pattern.shape[1])] = fgmask
# 
# plots(speccc)
# plots(fullMask)
# quit()
# Initiate SIFT detector

orb = False
if orb:
    orb = cv2.ORB(1000, 1.2)
    # find the keypoints and descriptors with SIFT
    img2 = specc.astype('uint8')
    kp1, des1 = orb.detectAndCompute(img1,None)
    kp2, des2 = orb.detectAndCompute(img2,None)
    
    # Create matcher
    bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
    
    # Do matching
    matches = bf.match(des1,des2)
    
    # Sort the matches based on distance.  Least distance
    # is better
    matches = sorted(matches, key=lambda val: val.distance)
    
    # Show only the top 10 matches
    drawMatches(img1, kp1, img2, kp2, matches[:10])
else:
    dect = cv2.SIFT(nfeatures=0, nOctaveLayers=3, contrastThreshold=0.04, edgeThreshold=15, sigma=1.6)
    
    #dect = cv2.FastFeatureDetector()
    #kp = dect.detect(img1,None)
    #brief = cv2.DescriptorExtractor_create("BRIEF")
    
    #dect = cv2.SURF(500, nOctaves=4, nOctaveLayers=2, extended=True, upright=False)
    
  # Initiate BRIEF extractor
    
    
    kp1, des1 = dect.detectAndCompute(img1,None)
    #kp1, des1 = brief.compute(img1, kp)
    
    
    kpss = []
    tt=specc.shape[1]/300
    ww = 0
    for w in range(0,specc.shape[1],int(float(img1.shape[1])/2.0)):
        good = []
        spec = numpy.copy(specc)
        spec = spec[:,w:(w+300)]
        img2t = spec.astype('uint8')
        
        img2 = numpy.zeros(shape=specc.shape)
        img2[:,w:(w+300)] = img2t
        img2 = img2.astype('uint8')
        #plots(img2)
        kp2, des2 = dect.detectAndCompute(img2,None)
        
        #kp2 = dect.detect(img2,None)
        #kp2, des2 = brief.compute(img2, kp2)
        img=cv2.drawKeypoints(img2,kp2)
        #plots(img)
        #plots(img)
        FLANN_INDEX_KDTREE = 0
        index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 20)
        search_params = dict(checks = 200)
        flann = cv2.FlannBasedMatcher(index_params, search_params)
        matches = flann.knnMatch(des1,des2,k=2)
        #print des2
        ww = ww + 300
        for m,n in matches:
            if m.distance < 0.9*n.distance:
                good.append(m)
        print len(good)
        if len(good)>4:
            src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
            dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
            try:
                M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC,5.0)
                h,w = img1.shape
                pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
                dst = cv2.perspectiveTransform(pts,M)
                img3 = drawMatches(img1,kp1,img2,kp2,good)
            except:
                """ """
        else:
            plots(img)
        del kp2
        del spec
        del img2
        del des2
        del matches
        del img
        del flann
        
    
    # src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
    # dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
    # 
    # M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC,5.0)
    # 
    # h,w = img1.shape
    # pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
    # dst = cv2.perspectiveTransform(pts,M)
    # spec = numpy.flipud(10*numpy.log10(sp[1:,]))
    # spec = ((spec-numpy.min(numpy.min(spec)))/(numpy.max(numpy.max(spec))-numpy.min(numpy.min(spec))))*255
    # img2 = spec.astype('uint8') 
    # img3 = drawMatches(img1,kp1,img2,kpss,good)

#plt.imshow(img3, 'gray'),plt.show()

