//
//  ThreeVector.h
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-08.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ThreeVectorOrder {
    kVectorOrderSame,
    kVectorOrderCCW,
    kVectorOrderCW
};

@interface ThreeVector : NSObject

@property (assign,readonly) float x;
@property (assign,readonly) float y;
@property (assign,readonly) float z;

+ (ThreeVector *)threeVectorWithX:(float)x y:(float)y z:(float)z;
- (id)initWithX:(float)x y:(float)y z:(float)z;

+ (ThreeVector *)zUnitVector;

- (float)dotProduct:(ThreeVector *)vec;
- (ThreeVector *)crossProduct:(ThreeVector *)vec;
- (float)magnitude;
- (ThreeVector *)unitVector;
- (ThreeVector *)negatedVector;

- (enum ThreeVectorOrder)orderOfVector:(ThreeVector *)vec onPlaneWithNormal:(ThreeVector *)normal;
- (float)distanceFromPlaneWithNormal:(ThreeVector *)normal;

@end
