//
//  RCUserEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserEntity.h"

//"user":
//{
//"id": 2596,
//"login": "fengzhilian818",
//"avatar_url": "http://ruby-china.org/avatar/e351cfb6c0fa7e761e5287952f292a16.png?s=120"
//}
@implementation OSCUserEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.authorId = [dic[@"authorid"] longLongValue];
        self.authorName = dic[@"author"];
        self.avatarUrl = dic[@"portrait"];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCUserEntity* entity = [[OSCUserEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
