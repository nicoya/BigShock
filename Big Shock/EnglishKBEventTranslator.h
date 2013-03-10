//
//  EnglishKBEventTranslator.h
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-08.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTranslator.h"

@class HIDListener;

@interface EnglishKBEventTranslator : NSObject<EventTranslator>

@property (readwrite,retain) HIDListener *listener;

@end
