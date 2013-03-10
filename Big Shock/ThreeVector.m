//
//  ThreeVector.m
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-08.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import "ThreeVector.h"

@interface ThreeVector ()

@property (assign,readwrite) float x;
@property (assign,readwrite) float y;
@property (assign,readwrite) float z;

@end

@implementation ThreeVector

+ (ThreeVector *)threeVectorWithX:(float)x y:(float)y z:(float)z
{
    return [[[ThreeVector alloc] initWithX:x y:y z:z] autorelease];
}

- (id)initWithX:(float)x y:(float)y z:(float)z
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Three Vector %f %f %f", self.x, self.y, self.z];
}

+ (ThreeVector *)zUnitVector
{
    static ThreeVector *zVec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zVec = [[ThreeVector threeVectorWithX:0 y:0 z:1] retain];
    });
    return zVec;
}

- (float)dotProduct:(ThreeVector *)vec
{
    return self.x * vec.x + self.y * vec.y + self.z * vec.z;
}

- (ThreeVector *)crossProduct:(ThreeVector *)vec
{
    return [ThreeVector threeVectorWithX:self.y * vec.z - self.z * vec.y
                                       y:self.z * vec.x - self.x * vec.z
                                       z:self.x * vec.y - self.y * vec.x];
}

- (float)magnitude
{
    return sqrtf([self dotProduct:self]);
}

- (ThreeVector *)unitVector
{
    float magnitude = self.magnitude;
    if (self.magnitude > 0) {
        return [ThreeVector threeVectorWithX:self.x/magnitude
                                           y:self.y/magnitude
                                           z:self.z/magnitude];
    } else {
        return [ThreeVector threeVectorWithX:0
                                           y:0
                                           z:0];
    }
}

- (ThreeVector *)negatedVector
{
    return [ThreeVector threeVectorWithX:-self.x y:-self.y z:-self.z];
}

- (enum ThreeVectorOrder)orderOfVector:(ThreeVector *)vec onPlaneWithNormal:(ThreeVector *)normal
{
    if (!vec || !normal)
        return kVectorOrderSame;
    
    // Take the cross product to give a vector perpendicular to self and vec, directed out of the clock face when in ccw order
    ThreeVector *cross = [self crossProduct:vec];
    
    // Take the dot product of the cross and normal to give us whether the two are pointed in the same direction
    float dot = [cross dotProduct:normal];
    
    if (dot > 0) {
        return kVectorOrderCCW;
    } else if (dot < 0) {
        return kVectorOrderCW;
    }
    
    return kVectorOrderSame;
}

- (float)distanceFromPlaneWithNormal:(ThreeVector *)normal
{
    return [self dotProduct:[normal unitVector]];
}

@end
