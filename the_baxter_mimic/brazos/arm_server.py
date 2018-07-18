#!/usr/bin/python2

# Copyright (c) 2013-2015, Rethink Robotics
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the Rethink Robotics nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import os
import sys
import argparse

import rospy

from baxter_core_msgs.msg import JointCommand
import baxter_interface
from std_msgs.msg import String

state="stop"
def state_machine(data):
    global state
    state=data.data
    print state

def talker():
    
    print ("hola")
    global state
    state="stop"
    rospy.Subscriber('arm_move', String, state_machine)
    
    pub_left = rospy.Publisher('robot/limb/left/joint_command', JointCommand, queue_size=1) 
    pub_right = rospy.Publisher('robot/limb/right/joint_command', JointCommand, queue_size=1)    
    rospy.init_node("brazo_control")
    rate=rospy.Rate(15)
    contador=0 
    contador_afraid=0   

    while not rospy.is_shutdown():
        
        if (state=="stop"):

            pub_left.publish(mode=1,command=[-0.48, -0.505, 0.041, 1.77, 0.018, 0.266, 3.048],names=['left_s0','left_s1','left_e0','left_e1','left_w0','left_w1','left_w2'])
            pub_right.publish(mode=1,command=[0.477, -0.4, 0.2, 1.45, 2.75, -0.45, 3.05],names=['right_s0','right_s1','right_e0','right_e1','right_w0','right_w1','right_w2'])
        if (state=="up-down"):
            print contador
            if contador<30:
                pub_left.publish(mode=1,command=[0.004, 0.265,  3.045, 0.005, 1.787, -0.49, -1.03],names=['left_w0', 'left_w1', 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.34, -0.08, 3.035, -0.066, 3.035, 0.133, 1.55],names=['right_s0', 'right_s1' , 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
                contador=contador+1
            if contador>=30:
                pub_left.publish(mode=1,command=[0.004, -0.0939, 3.044, 0.0038, 1.699, -0.518, -0.151],names=['left_w0', 'left_w1' , 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.36, -0.82, 2.91, -0.934, 3.05, 0.225, 1.402],names=['right_s0', 'right_s1', 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
                contador=contador+1
            if contador==60:
                contador=0
        if (state=="two_hands"):
            if contador<100:
                pub_left.publish(mode=1,command=[0.018, -0.204, 3.046, 0.225, -0.044, -0.507, -0.60],names=['left_w0', 'left_w1', 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.5, -0.85, 2.8, 0.22, 3.05, 0.007, 0.406],names=['right_s0', 'right_s1', 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
            if contador==100:
                contador=0
                state="stop"
        if (state=="left_hand"):
            if contador<100:
                pub_left.publish(mode=1,command=[-1.45, 0.182,  3.018, 0.041, -0.039, -0.777, -0.011],names=['left_w0', 'left_w1', 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.477, -0.4, 0.2, 1.45, 2.75, -0.45, 3.05],names=['right_s0','right_s1','right_e0','right_e1','right_w0','right_w1','right_w2'])
            if contador==100:
                contador=0
                state="stop"
        if (state=="right_hand"):
            if contador<100:
                pub_left.publish(mode=1,command=[-0.48, -0.505, 0.041, 1.77, 0.018, 0.266, 3.048],names=['left_s0','left_s1','left_e0','left_e1','left_w0','left_w1','left_w2'])
                pub_right.publish(mode=1,command=[0.21, -0.194, 3.059, -0.268, 3.054, 0.923, 0.356],names=['right_s0', 'right_s1', 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
            if contador==100:
                contador=0
                state="stop"
        if (state=="afraid"):
            if contador<50:
                pub_left.publish(mode=1,command=[-0.238, -0.0329, 3.044, 0.270, -0.0498, -0.49, -1.157],names=['left_w0', 'left_w1', 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.58, -1.1635,3.0579, -0.156, 3.053, -0.0145, -0.0498],names=['right_s0', 'right_s1', 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
                contador=contador+1
            if contador>=50:
                pub_left.publish(mode=1,command=[-0.711, 0.009, 3.04, 0.287, 0.262, -0.437, -1.0787],names=['left_w0', 'left_w1', 'left_w2', 'left_e0', 'left_e1', 'left_s0', 'left_s1'])
                pub_right.publish(mode=1,command=[0.091, -1.160, 3.059,-0.333,3.053, 0.1096, 0.365],names=['right_s0', 'right_s1', 'right_w0', 'right_w1', 'right_w2', 'right_e0', 'right_e1'])
                contador=contador+1
            if contador==100:
                contador=0
                contador_afraid=contador_afraid+1
                if contador_afraid==2:
                    state="stop"
                    ontador_afraid=0
       
	
        rate.sleep()

if __name__ == '__main__':
    try:
        
        talker()
    except rospy.ROSInterruptException:
        pass

    


