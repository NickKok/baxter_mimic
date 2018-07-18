#!/usr/bin/python2

import os
import sys
import argparse
import threading
import rospy
import cv2
import cv_bridge
import pyaudio
import wave
import sys
import math
import matplotlib.pyplot as plt
import numpy as np
CHUNK = 1024
from std_msgs.msg import String

from sensor_msgs.msg import (
    Image,
)
audio_path="src/camara/scripts/audio.wav"
def callback(data):
    arg1="src/camara/scripts/conversacion/saludo3.png"
    arg2="src/camara/scripts/conversacion/saludo10.png"
    img1 = cv2.imread(arg1)
    img2 = cv2.imread(arg2)
    msg1 = cv_bridge.CvBridge().cv2_to_imgmsg(img1, encoding="bgr8")
    msg2 = cv_bridge.CvBridge().cv2_to_imgmsg(img2, encoding="bgr8")
    pub = rospy.Publisher('/robot/xdisplay', Image, latch=True, queue_size=1)
    pub.publish(msg1)
    global audio_path
    audio_path=data.data
    wf = wave.open(audio_path, 'rb')
    # instantiate PyAudio (1)
    p = pyaudio.PyAudio()
    # open stream (2)
    stream = p.open(format=p.get_format_from_width(wf.getsampwidth()),
                    channels=wf.getnchannels(),
                    rate=wf.getframerate(),
                    output=True)

    data = wf.readframes(CHUNK)
    # play stream (3)
    frames=[]
    while len(data) > 0:
        stream.write(data)
        data = wf.readframes(CHUNK)
        signal = np.fromstring(data, 'Int16')
        if (math.fabs(np.average(signal))<5):
             pub.publish(msg1)
        else:
             pub.publish(msg2)
    


def manage_audio():
    rospy.init_node("estado2")
    rate=rospy.Rate(10)
    contador=1
    
    rospy.Subscriber('face_type', String, callback)
    print ("callback")
    
    rospy.spin()  

if __name__ == '__main__':
    try:
        
        manage_audio()
    except rospy.ROSInterruptException:
        pass
