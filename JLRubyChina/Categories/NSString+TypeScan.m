//
//  NSString+typeCheck.m
//  JLOSChina
//
//  Created by Lee jimney on 1/12/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "NSString+TypeScan.h"

@implementation NSString (TypeScan)

- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
