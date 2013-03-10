//
//  HIDListener.m
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-07.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import "HIDListener.h"

@implementation HIDListener

- (id)init
{
    self = [super init];
    if (self) {
        // Set up the button mapping
        self.buttonMapping = @{
                               @1:@"sel",
                               @2:@"l3",
                               @3:@"r3",
                               @4:@"srt",
                               @5:@"up",
                               @6:@"ri",
                               @7:@"dn",
                               @8:@"le",
                               @9:@"l2",
                               @10:@"r2",
                               @11:@"l1",
                               @12:@"r1",
                               @13:@"tri",
                               @14:@"cir",
                               @15:@"xbt",
                               @16:@"squ",
                               @17:@"ps3",
                                 };
        
        // Set up the hid manager
        IOHIDManagerRef hmgr = IOHIDManagerCreate(NULL, kIOHIDManagerOptionNone);
        self.hmgr = hmgr;
        CFRelease(hmgr);
        
        IOHIDManagerSetDeviceMatching(self.hmgr, (CFDictionaryRef)@{
                                      @kIOHIDDeviceUsagePageKey:@(kHIDPage_GenericDesktop),
                                      @kIOHIDDeviceUsageKey:@(kHIDUsage_GD_Joystick),
                                      });
        // Later on this will be instanced per device, but for now just open the firehose
        // and hope we only have one gamepad connected
        IOHIDManagerRegisterInputValueCallback(self.hmgr, managerValueCallback, self);
        
        IOHIDManagerOpen(self.hmgr, kIOHIDManagerOptionNone);
        IOHIDManagerScheduleWithRunLoop(self.hmgr, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    return self;
}

- (void)dealloc
{
    IOHIDManagerClose(self.hmgr, kIOHIDManagerOptionNone);
    IOHIDManagerUnscheduleFromRunLoop(self.hmgr, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    self.hmgr = NULL;
    
    self.buttonMapping = nil;
    
    [super dealloc];
}

static float scaledValueForValue(IOHIDValueRef value)
{
    // Because IOHidValueGetScaledValue apparently doesn't work
    
    IOHIDElementRef element = IOHIDValueGetElement(value);
    float min = IOHIDElementGetPhysicalMin(element);
    float max = IOHIDElementGetPhysicalMax(element);
    float raw = IOHIDValueGetIntegerValue(value);
    
    return -1 + 2 * (raw - min)/(max - min);
}

static void managerValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value)
{
    HIDListener *listener = context;
    [listener managerValueCallbackWithResult:result value:value];
}

- (void)managerValueCallbackWithResult:(IOReturn)result value:(IOHIDValueRef)value
{
    if (result)
        return;
    
    IOHIDElementRef element = IOHIDValueGetElement(value);
    
    if (IOHIDElementGetUsagePage(element) == kHIDPage_Button) {
        //NSLog(@"Button Usage: %d", IOHIDElementGetUsage(element));
        
        CFIndex state = IOHIDValueGetIntegerValue(value);
        uint32_t button = IOHIDElementGetUsage(element);

        NSString *key = [self.buttonMapping objectForKey:@(button)];
        
        if ([key length]) {
            [self setValue:@(IOHIDValueGetIntegerValue(value)) forKey:key];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Button Event" object:self userInfo:@{@"Button":key,@"Down":@(state != 0)}];
        }
        
    } else if (IOHIDElementGetUsagePage(element) == kHIDPage_GenericDesktop) {
        switch (IOHIDElementGetUsage(element)) {
                // Y is positive down for some stupid reason
            case kHIDUsage_GD_X: self.lx = scaledValueForValue(value); break;
            case kHIDUsage_GD_Y: self.ly = -scaledValueForValue(value); break;
            case kHIDUsage_GD_Z: self.rx = scaledValueForValue(value); break;
            case kHIDUsage_GD_Rz: self.ry = -scaledValueForValue(value); break;
                
            case 1:
            {
                /*
                CFIndex length = IOHIDValueGetLength(value);
                
                if (length == 1)
                    break;
                
                const uint8_t *bytes = IOHIDValueGetBytePtr(value);
                
                NSData *packetData = [NSData dataWithBytes:bytes length:length];
                
                // Analog Data
                //NSLog(@"%@", [packetData subdataWithRange:NSMakeRange(4, 4)]); // UP RI DN LE
                //NSLog(@"%@", [packetData subdataWithRange:NSMakeRange(8, 4)]); // L2 R2 L1 R1
                //NSLog(@"%@", [packetData subdataWithRange:NSMakeRange(12, 4)]); // TRI CIRC X SQUA
                //NSLog(@"%@", [packetData subdataWithRange:NSMakeRange(31, 8)]); // MEMS Axes and Gyro
                 */
            }
                break;
                
            default:
                NSLog(@"Unknown page: %x usage: %x", IOHIDElementGetUsagePage(element), IOHIDElementGetUsage(element));
                break;
        }
    }
}

@end
