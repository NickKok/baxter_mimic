/* --------------------------------------------------------------------------
 * Baxter arm position sender for Kinect V1
 * Modified from SimpleOpenNI User Test
 * To run, send the output to the ROS listening port, e.g.
 * ./processing > /dev/udp/localhost/15444 
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * Modified by J. Devine and Daniel Gonzalez Castro
 * Original prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

//import processing.net.*;//network lib

//Client c; //comms output
String SendToServer;
SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();                                   
PVector v1 = new PVector();
PVector v2d = new PVector();
float dontcare;
float Lhandx,Lhandy,Rhandx,Rhandy;
float Lelbowx,Lelbowy,Relbowx,Relbowy;
float Lshoulderx,Lshouldery,Rshoulderx,Rshouldery;
float Langle,Rangle,L2angle,R2angle;

void setup()
{
  size(640,480);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     //println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();  
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(10);
      beginShape(LINES);
        vertex(com2d.x,com2d.y);
        vertex(com2d.x,com2d.y);

        vertex(com2d.x,com2d.y);
        vertex(com2d.x,com2d.y);
        
      endShape();
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }    
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  //context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  //context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  SendToServer="";
  context.getCoM(userId,v1);
  context.convertRealWorldToProjective(v1,v2d);
  //print("CoM ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(1);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+("CoM:"+v2d.x+','+v2d.y);
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, v1);
  context.convertRealWorldToProjective(v1,v2d);
  //print(" Left hand ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(10);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+(";Lhand:"+v2d.x+','+v2d.y);
  Lhandx=v2d.x;
  Lhandy=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, v1);
  context.convertRealWorldToProjective(v1,v2d);
  
  //print(" Lelbow ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(10);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+(";Lelbow:"+v2d.x+','+v2d.y);
  Lelbowx=v2d.x;
  Lelbowy=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, v1);
  context.convertRealWorldToProjective(v1,v2d);
  //print(" Left shoulder ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(10);
  rect(v2d.x, v2d.y, 5, 5);  
  SendToServer = SendToServer+(";Lshoulder:"+v2d.x+','+v2d.y);
  Lshoulderx=v2d.x;
  Lshouldery=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, v1);
  context.convertRealWorldToProjective(v1,v2d);
   //print(" Right hand ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(255,0,0);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+(";Rhand:"+v2d.x+','+v2d.y);
  Rhandx=v2d.x;
  Rhandy=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, v1);
  context.convertRealWorldToProjective(v1,v2d);
  //print(" right elbow ");
  //print(v2d.x);
  //print(' ');
  //print(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(10);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+(";Relbow:"+v2d.x+','+v2d.y);  
  Relbowx=v2d.x;
  Relbowy=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, v1);
  context.convertRealWorldToProjective(v1,v2d);
  //print(" right shoulder ");
  //print(v2d.x);
  //print(' ');
  //println(v2d.y);
  fill(0,0,0);
  stroke(255,255,255);
  strokeWeight(10);
  rect(v2d.x, v2d.y, 5, 5);
  SendToServer = SendToServer+(";Rshoulder:"+v2d.x+','+v2d.x+"\n");
  //println(SendToServer);
  Rshoulderx=v2d.x;
  Rshouldery=v2d.y;
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, v1);
  context.convertRealWorldToProjective(v1,v2d);
  //println(";diference:"+(Lelbowx-Lshoulderx));
  Langle=atan2((Lelbowx-Lshoulderx),(Lelbowy-Lshouldery));
  Rangle=atan2((Relbowx-Rshoulderx),(Relbowy-Rshouldery));
  L2angle=atan2((Lhandx-Lelbowx),(Lhandy-Lelbowy));
  R2angle=atan2((Rhandx-Relbowx),(Rhandy-Relbowy));
  println("parsethis:"+Langle+':'+Rangle+':'+L2angle+':'+R2angle);
  //println(Rangle);
  //c.write(SendToServer);  
  //context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  //context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  //context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  //context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  //println("onNewUser - userId: " + userId);
  //println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  //println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  

