//
//  SKWorldTransform.h
//  cvAruco
//
//  Created by Dan Park on 3/24/19.
//  Copyright © 2019 Dan Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKWorldTransform : NSObject
@property(nonatomic) int arucoId;
@property(nonatomic) SCNMatrix4 transform;

@end

NS_ASSUME_NONNULL_END
