# aruco-arkit-opencv
Detects aruco markers in a live view.  Uses OpenCV, ARKit, Aruco libraries

## Video Demo
- Shows how the app handles a camera shake or shaking of a printed aruco marker. 
- Video is captured in the brightly lit MagicLeap 1st floor kitchen.
- Link: https://drive.google.com/file/d/1Zi-Qulc-XPzMS8fRPiBhlgZrAuzvW1IF/view?usp=sharing


## Getting Started

1. Download my OpenCV and Aruco library from here.
- https://drive.google.com/open?id=1_G_kzhMLsKyzFKKxz1FSSCNzdobjI7b-

- This iOS library of OpenCV with OpenCV Contri Aruco module is built from scratch from source.
- Building it from scratch is not an easy task.  I will write a blog entry on how.

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

Under low light condition, the pose estimation seems to be off. 
- Find a well lit area like 1st Floor Kitchen Area.. 
- Not the Demo room where they have 50Hz light.  
- For some reasons, this causes flickering issue on this app.

Under low texture condition, the ARKit may pick up no count or low count of features.

Under 50Hz light source, it has the flickering cube issue.


## Comming Soon

Native Unity Plugin demo coming soon.


