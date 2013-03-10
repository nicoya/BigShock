//
//  EventTranslator.h
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-08.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIDListener;

@protocol EventTranslator <NSObject>

- (id)initWithListener:(HIDListener *)listener;

- (void)handleButtonEventForButton:(NSString *)btn down:(BOOL)down;
- (void)handleAnalogAxis:(NSString *)axis value:(float)value;

@end
