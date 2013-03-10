//
//  AppDelegate.m
//  Big Shock
//
//  Created by Tony Mantler on 2013-02-23.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import "AppDelegate.h"

#import "HIDListener.h"
#import "EnglishKBEventTranslator.h"

@implementation AppDelegate

- (void)dealloc
{
    self.listener = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.listener = [[[HIDListener alloc] init] autorelease];
    
    self.translator = [[[EnglishKBEventTranslator alloc] initWithListener:self.listener] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonNotification:) name:@"Button Event" object:self.listener];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analogNotification:) name:@"Analog Event" object:self.listener];
}

- (void)buttonNotification:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    [self.translator handleButtonEventForButton:[userInfo valueForKey:@"Button"] down:[[userInfo valueForKey:@"Down"] boolValue]];
}

- (void)analogNotification:(NSNotification *)note
{
    
}


@end
