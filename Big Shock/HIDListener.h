//
//  HIDListener.h
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-07.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDLib.h>

@interface HIDListener : NSObject

@property (readwrite,retain) NSDictionary *buttonMapping;

@property (assign) BOOL r1;
@property (assign) BOOL l1;
@property (assign) BOOL r2;
@property (assign) BOOL l2;

@property (assign) BOOL r3;
@property (assign) float rx;
@property (assign) float ry;

@property (assign) BOOL l3;
@property (assign) float lx;
@property (assign) float ly;

@property (assign) BOOL up;
@property (assign) BOOL dn;
@property (assign) BOOL le;
@property (assign) BOOL ri;

@property (assign) BOOL tri;
@property (assign) BOOL squ;
@property (assign) BOOL cir;
@property (assign) BOOL xbt;

@property (assign) BOOL sel;
@property (assign) BOOL srt;
@property (assign) BOOL ps3;

@property (retain) __attribute__((NSObject)) IOHIDManagerRef hmgr;

@end
