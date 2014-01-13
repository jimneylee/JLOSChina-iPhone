//
//  OSCNoticeEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCNoticeEntity.h"

@implementation OSCNoticeEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.atMeCount = [dic[@"atmeCount"] integerValue];
        self.atMeCount = [dic[@"msgCount"] integerValue];
        self.atMeCount = [dic[@"reviewCount"] integerValue];
        self.atMeCount = [dic[@"newFansCount"] integerValue];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCNoticeEntity* entity = [[OSCNoticeEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
