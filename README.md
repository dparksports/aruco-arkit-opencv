# aruco-arkit-opencv
This iOS app detects Aruco markers in a live view.  

This app uses OpenCV and Aruco libraries.  Namely,

- Uses OpenCV library
- Uses OpenCV Contri library
- Aruco library
- ARKit 
- SceneKit 

## Video Demo
- Shows how the app handles a camera shake or shaking of a printed aruco marker. 
- Video is captured in the brightly lit MagicLeap 1st floor kitchen.
- Link: https://drive.google.com/file/d/1Zi-Qulc-XPzMS8fRPiBhlgZrAuzvW1IF/view?usp=sharing


## Getting Started

1. Download the iOS OpenCV and Aruco library from here.
- https://drive.google.com/open?id=1_G_kzhMLsKyzFKKxz1FSSCNzdobjI7b-

- This iOS library is different from the iOS version of the OpenCV library provided by OpenCV.org.
- The standard OpenCV library only has its core library, and it does not contain OpenCV Contrib libraries.
- The OpenCV Contrib libraries include Aruco library required for this iOS app.
- The downloadable OpenCV library is built from the OpenCV and OpenCV Contrib code base.
- Using this prebuilt library will save you time and effort, as building OpenCV Contrib and OpenCV from source is not an easy task.
- Code base is base on the version: OpenCV v3.4.x for OpenCV and OpenCV Contrib libraries.
- I will write a blog entry on how to build the OpenCV and OpenCV Contrib libraries from source on a Mac.


2. Place "opencv2.framework" under "opencv" directory under the Xcode project.
- eg) ../aruco-master/cvAruco/opencv

3. Build app under Xcode.

4. Launch app and scan the area until the app shows the feature points in a live view.

5. Generate an aruco marker.
- Use this website to generate a new marker.  
- http://chev.me/arucogen/
- Select 5x5 Dictionary with Marker size 250.
- Enter any Marker ID.  
- eg) 77

6. Point your camera at a printed marker.

7. Once sucessfully a marker pose is estimated, you should see a solid-colored cube placed over the marker. 

8. Add additional markers in the scene.  
- Each marker should be placed with a uniquely colored cube.


## Known Issues & Improvements

This demo has so far worked on a iphone 6.  

Under low light environment, the pose estimation seems to be off. 
- Find a well lit area like 1st floor kitchen area.. 
- Not the Demo room where they have 50Hz light.  
- For some reasons, this causes flickering issue on this app.

Under low texture environment, the ARKit may not pick up any features, or pick up a low count of features.

Under 50Hz light source, it has the flickering cube issue.


## Comming Soon

Native Unity Plugin demo may be in order, if find enough time..
