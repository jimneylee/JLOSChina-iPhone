//
//  RCUserEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCErrorEntity.h"

@implementation OSCErrorEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.errorCode = 0;
        self.errorMessage = @"未知错误";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.errorCode = [dic[@"errorCode"] integerValue];
        self.errorMessage = dic[@"errorMessage"];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCErrorEntity* entity = [[OSCErrorEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
