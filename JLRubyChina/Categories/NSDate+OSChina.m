//
//  NSDate+OSChina.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "NSDate+OSChina.h"

@implementation NSDate (OSChina)


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)normalFormatDateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
