//
//  EnglishKBEventTranslator.m
//  Big Shock
//
//  Created by Tony Mantler on 2013-03-08.
//  Copyright (c) 2013 Tony Mantler. All rights reserved.
//

#import "EnglishKBEventTranslator.h"

#import "HIDListener.h"
#import "ThreeVector.h"

@interface EnglishKBEventTranslator ()

@end

@implementation EnglishKBEventTranslator

- (id)initWithListener:(HIDListener *)listener
{
    self = [super init];
    if (self) {
        self.listener = listener;
    }
    return self;
}

- (void)handleButtonEventForButton:(NSString *)btn down:(BOOL)down
{
    // Do more here
    NSLog(@"Button %@: %@", down?@"down":@"up", [[self buttonMappingForCurrentState] valueForKey:btn]);
}

- (void)handleAnalogAxis:(NSString *)axis value:(float)value
{
    // Just update the UI here
}

- (NSDictionary *)buttonMappingForCurrentState
{
    // If the vector is too short, we're in the middle
    
    ThreeVector *lsVec = [ThreeVector threeVectorWithX:[self.listener lx] y:[self.listener ly] z:0];

    if ([lsVec magnitude] < 0.5) {
        // Stick something useful here
        return nil;
    }
    
    // We first want to find the sector that the left stick is in.
    // So make a clockwise array of vector boundaries and iterate through
    // until we find the last one that the ls vector is clockwise to
    
    static NSArray *vectors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vectors = [@[
                    [ThreeVector threeVectorWithX:cosf(M_PI * 5/8) y:sinf(M_PI * 5/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 3/8) y:sinf(M_PI * 3/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 1/8) y:sinf(M_PI * 1/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 15/8) y:sinf(M_PI * 15/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 13/8) y:sinf(M_PI * 13/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 11/8) y:sinf(M_PI * 11/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 9/8) y:sinf(M_PI * 9/8) z:0],
                    [ThreeVector threeVectorWithX:cosf(M_PI * 7/8) y:sinf(M_PI * 7/8) z:0],
                    ] retain];
    });
    
    ThreeVector *zUnit = [ThreeVector zUnitVector];
    
    __block int sector = -1;
    
    [vectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ThreeVector *vec = obj;
        if ([vec orderOfVector:lsVec onPlaneWithNormal:zUnit] == kVectorOrderCW) {
            sector = (int)idx;
        } else if (sector >= 0) {
            *stop = YES;
        }
    }];
    
    if (![self.listener l2] && ![self.listener r2]) {
        switch (sector) {
            case 0: return @{@"squ":@"a",@"tri":@"b",@"cir":@"c",@"xbt":@"d"};
            case 1: return @{@"squ":@"e",@"tri":@"f",@"cir":@"g",@"xbt":@"h"};
            case 2: return @{@"squ":@"i",@"tri":@"j",@"cir":@"k",@"xbt":@"l"};
            case 3: return @{@"squ":@"m",@"tri":@"n",@"cir":@"o",@"xbt":@"p"};
            case 4: return @{@"squ":@"q",@"tri":@"r",@"cir":@"s",@"xbt":@"t"};
            case 5: return @{@"squ":@"u",@"tri":@"v",@"cir":@"w",@"xbt":@"x"};
            case 6: return @{@"squ":@"y",@"tri":@"z",@"cir":@",",@"xbt":@"."};
            case 7: return @{@"squ":@":",@"tri":@"/",@"cir":@"@",@"xbt":@"-"};
        }
    } else if ([self.listener l2] && ![self.listener r2]) {
        switch (sector) {
            case 0: return @{@"squ":@"A",@"tri":@"B",@"cir":@"C",@"xbt":@"D"};
            case 1: return @{@"squ":@"E",@"tri":@"F",@"cir":@"G",@"xbt":@"H"};
            case 2: return @{@"squ":@"I",@"tri":@"J",@"cir":@"K",@"xbt":@"L"};
            case 3: return @{@"squ":@"M",@"tri":@"N",@"cir":@"O",@"xbt":@"P"};
            case 4: return @{@"squ":@"Q",@"tri":@"R",@"cir":@"S",@"xbt":@"T"};
            case 5: return @{@"squ":@"U",@"tri":@"V",@"cir":@"W",@"xbt":@"X"};
            case 6: return @{@"squ":@"Y",@"tri":@"Z",@"cir":@"?",@"xbt":@"!"};
            case 7: return @{@"squ":@";",@"tri":@"\\",@"cir":@"&",@"xbt":@"_"};
        }
    }
    // Add code for r2 down

    return nil;
}

@end
