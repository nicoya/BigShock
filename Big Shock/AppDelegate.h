//
//  AppDelegate.h
//  Big Shock
//
//  Created by Tony Mantler on 2013-02-23.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EventTranslator.h"

@class HIDListener;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readwrite,retain) HIDListener *listener;
@property (readwrite,retain) NSObject<EventTranslator> *translator;

@end
