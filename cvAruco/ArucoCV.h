//
//  ArucoCV.h
//  cvAruco
//
//  Created by Dan Park on 3/26/19.
//  Copyright © 2019 Dan Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArucoCV : NSObject

+(NSMutableArray *) estimatePose:(CVPixelBufferRef)pixelBuffer withIntrinsics:(matrix_float3x3)intrinsics andMarkerSize:(Float64)markerSize;
@end

NS_ASSUME_NONNULL_END
