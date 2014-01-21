//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCRelativeEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"
#import "NSString+TypeScan.h"

@implementation OSCRelativeEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.title = dic[@"rtitle"];
        self.url = dic[@"rurl"];
        self.contentId = 0;

        // www.oschina.net/news/46462/centos-6-5-final
        // get 46462 from url
        NSArray* array = [self.url componentsSeparatedByString:@"/"];
        for (NSString* string in array) {
            if ([string isPureInt:string]) {
                self.contentId = [string longLongValue];
                break;
            }
        }
     }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCRelativeEntity* entity = [[OSCRelativeEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
