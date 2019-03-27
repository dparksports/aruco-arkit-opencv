# aruco-arkit-opencv
Detects aruco markers (6x6) in a live view.  Uses OpenCV, ARKit, Aruco libraries


## Getting Started

1. Launch app and scan the area until the app shows the feature points in a live view.

2. Point your camera at a printed marker.

3. Once sucessfully a marker pose is estimated, you should see a solid-colored cube placed over the marker. 

3. Now you can add additional marker in the scene.

4. Once another marker is recognized, you should see both of the markers with their own cubes on top.


## Known Issues & Improvements

This demo has so far worked on a iphone 6.  -- I have not tested on any other devices. 

Under low light condition, the pose estimation seems to be off. 

Under low texture condition, the ARKit may not pick up low count of features.


## Comming Soon

Unity demo coming soon.


## Aknowledgements

I found the following sources particularly helpful in getting this demo working.

http://ksimek.github.io/2012/08/14/decompose/

https://docs.opencv.org/3.1.0/d5/dae/tutorial_aruco_detection.html

http://answers.opencv.org/question/23089/opencv-opengl-proper-camera-pose-using-solvepnp/

https://stackoverflow.com/questions/44257592/scenekit-3d-marker-augmented-reality-ios

