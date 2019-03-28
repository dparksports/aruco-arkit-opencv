//
//  ViewController.swift
//  cvAruco
//
//  Created by Dan Park on 3/25/19.
//  Copyright © 2019 Dan Park. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, ARSessionObserver {

    @IBOutlet var sceneView: ARSCNView!
    var mutexlock = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.autoenablesDefaultLighting = true;
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func updateContentNodeCache(targTransforms: Array<SKWorldTransform>, cameraTransform:SCNMatrix4) {
        
        for transform in targTransforms {
            
            let targTransform = SCNMatrix4Mult(transform.transform, cameraTransform);
            
            if let box = findCube(arucoId: Int(transform.arucoId)) {
                box.setWorldTransform(targTransform);
                
            } else {
                
                let arucoCube = ArucoNode(arucoId: Int(transform.arucoId))
                sceneView.scene.rootNode.addChildNode(arucoCube);
                arucoCube.setWorldTransform(targTransform);
            }
        }
    }
    
    func findCube(arucoId:Int) -> ArucoNode? {
        for node in sceneView.scene.rootNode.childNodes {
            if node is ArucoNode {
                let box = node as! ArucoNode
                if (arucoId == box.id) {
                    return box
                }
            }
        }
        return nil
    }
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        if self.mutexlock {
            return;
        }

        self.mutexlock = true;
        let pixelBuffer = frame.capturedImage
        
        // 1) cv::aruco::detectMarkers
        // 2) cv::aruco::estimatePoseSingleMarkers
        // 3) transform offset and rotation of marker's corners in OpenGL coords
        // 4) return them as an array of matrixes

        let transMatrixArray:Array<SKWorldTransform> = ArucoCV.estimatePose(pixelBuffer, withIntrinsics: frame.camera.intrinsics, andMarkerSize: Float64(ArucoProperty.ArucoMarkerSize)) as! Array<SKWorldTransform>;

        
        if(transMatrixArray.count == 0) {
            self.mutexlock = false;
            return;
        }

        let cameraMatrix = SCNMatrix4.init(frame.camera.transform);
        
        DispatchQueue.main.async(execute: {
            self.updateContentNodeCache(targTransforms: transMatrixArray, cameraTransform:cameraMatrix)
            
            self.mutexlock = false;
        })
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        NSLog("%s", __FUNC__)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    }
    
    // MARK: - ARSessionObserver

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
