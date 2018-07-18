# baxter_mimic
A processing sketch and some bash scripts to get a Rethink Robotics Baxter robot to mimic arm movements.
This was developed for the Cineglobe 2018 film festival at CERN. It's very rough, and is basically just a proof of concept. 
I'd like to thank everyone who wrote the code underneath in many, many libraries which we used to build this in about 5 hours.

Here's what the processing sketch looks like when it's working:

[![Processing extracting a human skeleton](https://img.youtube.com/vi/WJ7nlJ3kOXQ/0.jpg)](https://www.youtube.com/watch?v=WJ7nlJ3kOXQ)

And here is an example of the robot copying a human:

[![The robot is alive!](https://img.youtube.com/vi/X5iLGqhf2Kw/0.jpg)](https://www.youtube.com/watch?v=X5iLGqhf2Kw)

It's a long way short of a good kinematic example, but it does work. We used the software we used because we only had a Kinect 1 to play with, you could do something much better with a Kinect 2.

# Software requirements
We got our demo running in Ubuntu 14.04 LTS on an i7 870 CPU with 8GB of ram.
You'll need Processing version 2.2.1 (an old version) and the Open/SimpleNI libraries for it to get the Kinect working.
At the robot end, we had a Baxter from Rethink Robotics, running ROS (internally) and then a ROS session on our computer to connect to it.

# Conclusion
It worked as we hoped, the Kinect would occasionally lose people. 
You probably need a bunch more ROS files to get this working, drop me a line if you are interested.
It was fun, both Daniel and myself learned a lot in a short time!
