#dect = cv2.SIFT(nfeatures=0, nOctaveLayers=3, contrastThreshold=0.04, edgeThreshold=15, sigma=1.6)

#dect = cv2.FastFeatureDetector()
#kp = dect.detect(img1,None)
#brief = cv2.DescriptorExtractor_create("BRIEF")

dect = cv2.SURF(500, nOctaves=4, nOctaveLayers=2, extended=True, upright=False)

# Initiate BRIEF extractor


kp1, des1 = dect.detectAndCompute(img1,None)
#kp1, des1 = brief.compute(img1, kp)


kpss = []
tt=specc.shape[1]/300
ww = 0
for w in range(tt):
    good = []
    spec = numpy.copy(specc)
    spec = spec[:,ww:(ww+300)]
    img2 = spec.astype('uint8')  
    kp2, des2 = dect.detectAndCompute(img2,None)
    
    #kp2 = dect.detect(img2,None)
    #kp2, des2 = brief.compute(img2, kp2)
    img=cv2.drawKeypoints(img2,kp2)
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
    for kk in kp2:
        kpss.append(kk)
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
    del kp2
    del spec
    del img2
    del des2
    del matches
    del img
    del flann