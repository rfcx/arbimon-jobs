#! /usr/bin/python

import cv
import os

distPath = (cv.__file__
    .replace('cv.pyc', '')
    .replace('cv.py', '')
)

fileName = os.path.join(
    os.path.dirname(os.path.realpath(__file__)),
    '..',
    '..',
    '.env',
    'lib',
    'python2.7',
    'site-packages',
    'cv.pth'
)

pth_file = open(fileName, "w")

pth_file.write(distPath)

pth_file.close()
