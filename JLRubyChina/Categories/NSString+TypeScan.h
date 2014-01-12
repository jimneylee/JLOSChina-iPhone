//
//  NSString+typeCheck.h
//  JLOSChina
//
//  Created by Lee jimney on 1/12/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TypeScan)

- (BOOL)isPureInt:(NSString*)string;

- (BOOL)isPureFloat:(NSString*)string;

@end
