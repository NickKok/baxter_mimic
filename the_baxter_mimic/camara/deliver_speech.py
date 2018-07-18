#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String
import sys

def talker():
    pub = rospy.Publisher('face_type', String, queue_size=10)
    rospy.init_node('face_client', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    audio="speech.wav"
        
    pub.publish(audio)
        

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
