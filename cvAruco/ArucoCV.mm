//
//  ArucoCV.m
//  cvAruco
//
//  Created by Dan Park on 3/26/19.
//  Copyright © 2019 Dan Park. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc.hpp>
#include "opencv2/aruco.hpp"
#include "opencv2/aruco/dictionary.hpp"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreVideo/CoreVideo.h>
#import "SKWorldTransform.h"

#import "ArucoCV.h"

@implementation ArucoCV

static cv::Mat rotateRodriques(cv::Mat &rotMat, cv::Vec3d &tvecs) {
    cv::Mat extrinsics(4, 4, CV_64F);
    
    for( int row = 0; row < rotMat.rows; row++) {
        for (int col = 0; col < rotMat.cols; col++) {
            extrinsics.at<double>(row,col) = rotMat.at<double>(row,col); //copy rotation matrix values
        }
        extrinsics.at<double>(row,3) = tvecs[row];
    }
    extrinsics.at<double>(3,3) = 1;
    
    //The important thing to remember about the extrinsic matrix is that it describes how the world is transformed relative to the camera. This is often counter-intuitive, because we usually want to specify how the camera is transformed relative to the world.
    
    // Convert coordinate systems of opencv to openGL (SceneKit)
    extrinsics = [ArucoCV GetCVToGLMat] * extrinsics;
    return extrinsics;
}

static void detect(std::vector<std::vector<cv::Point2f> > &corners, std::vector<int> &ids, CVPixelBufferRef pixelBuffer) {
    cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);
    
    // The first plane / channel (at index 0) is the grayscale plane
    // See more infomation about the YUV format
    // http://en.wikipedia.org/wiki/YUV
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *baseaddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    CGFloat width = CVPixelBufferGetWidth(pixelBuffer);
    CGFloat height = CVPixelBufferGetHeight(pixelBuffer);
    cv::Mat mat(height, width, CV_8UC1, baseaddress, 0); //CV_8UC1
    
    cv::aruco::detectMarkers(mat,dictionary,corners,ids);
    
    NSLog(@"found: ids.size(): %lu", ids.size());
}

+(NSMutableArray *) estimatePose:(CVPixelBufferRef)pixelBuffer withIntrinsics:(matrix_float3x3)intrinsics andMarkerSize:(Float64)markerSize {
    
    std::vector<int> ids;
    std::vector<std::vector<cv::Point2f>> corners;
    detect(corners, ids, pixelBuffer);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    NSMutableArray *arrayMatrix = [NSMutableArray new];
    if(ids.size() == 0) {
        return arrayMatrix;
    }
    
    cv::Mat intrinMat(3,3,CV_64F);
    intrinMat.at<Float64>(0,0) = intrinsics.columns[0][0];
    intrinMat.at<Float64>(0,1) = intrinsics.columns[1][0];
    intrinMat.at<Float64>(0,2) = intrinsics.columns[2][0];
    intrinMat.at<Float64>(1,0) = intrinsics.columns[0][1];
    intrinMat.at<Float64>(1,1) = intrinsics.columns[1][1];
    intrinMat.at<Float64>(1,2) = intrinsics.columns[2][1];
    intrinMat.at<Float64>(2,0) = intrinsics.columns[0][2];
    intrinMat.at<Float64>(2,1) = intrinsics.columns[1][2];
    intrinMat.at<Float64>(2,2) = intrinsics.columns[2][2];
    
    std::vector<cv::Vec3d> rvecs, tvecs;
    cv::Mat distCoeffs = cv::Mat::zeros(8, 1, CV_64F);
    cv::aruco::estimatePoseSingleMarkers(corners, markerSize, intrinMat, distCoeffs, rvecs, tvecs);
    NSLog(@"found: tvecs.size(): %lu", tvecs.size());
    NSLog(@"found: rvecs.size(): %lu", rvecs.size());
    
    cv::Mat rotMat, tranMat;
    for (int i = 0; i < rvecs.size(); i++) {
        //convert results rotation matrix
        cv::Rodrigues(rvecs[i], rotMat);
        cv::Mat extrinsics = rotateRodriques(rotMat, tvecs[i]);
        SCNMatrix4 scnMatrix = [ArucoCV transformToSceneKitMatrix:extrinsics];
        SKWorldTransform *transform = [SKWorldTransform new];
        transform.arucoId = ids[i];
        transform.transform = scnMatrix;
        [arrayMatrix addObject:transform];
    }
    
    return arrayMatrix;
}

//http://answers.opencv.org/question/23089/opencv-opengl-proper-camera-pose-using-solvepnp/


// Note that in openCV z goes away the camera (in openGL goes into the camera)
// and y points down and on openGL point up
+(cv::Mat) GetCVToGLMat {
    cv::Mat cvToGL = cv::Mat::zeros(4,4,CV_64F);
    cvToGL.at<double>(0,0) = 1.0f;
    cvToGL.at<double>(1,1) = -1.0f; //invert y
    cvToGL.at<double>(2,2) = -1.0f; //invert z
    cvToGL.at<double>(3,3) = 1.0f;
    return cvToGL;
}

+(SCNMatrix4) transformToSceneKitMatrix:(cv::Mat&) openCVTransformation {
    SCNMatrix4 mat = SCNMatrix4Identity;
    
    //Transpose (think this is to switch from col order to row order matrix)
    openCVTransformation = openCVTransformation.t();
    
    //copy rotation rows
    // copy the rotationRows
    mat.m11 = (float) openCVTransformation.at<double>(0, 0);
    mat.m12 = (float) openCVTransformation.at<double>(0, 1);
    mat.m13 = (float) openCVTransformation.at<double>(0, 2);
    mat.m14 = (float) openCVTransformation.at<double>(0, 3);
    
    mat.m21 = (float)openCVTransformation.at<double>(1, 0);
    mat.m22 = (float)openCVTransformation.at<double>(1, 1);
    mat.m23 = (float)openCVTransformation.at<double>(1, 2);
    mat.m24 = (float)openCVTransformation.at<double>(1, 3);
    
    mat.m31 = (float)openCVTransformation.at<double>(2, 0);
    mat.m32 = (float)openCVTransformation.at<double>(2, 1);
    mat.m33 = (float)openCVTransformation.at<double>(2, 2);
    mat.m34 = (float)openCVTransformation.at<double>(2, 3);
    
    //copy the translation row
    mat.m41 = (float)openCVTransformation.at<double>(3, 0);
    mat.m42 = (float)openCVTransformation.at<double>(3, 1);
    mat.m43 = (float)openCVTransformation.at<double>(3, 2);
    mat.m44 = (float)openCVTransformation.at<double>(3, 3);
    
    return mat;
}

@end
