//
//  RCUserEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserFullEntity.h"
#import "NSString+stringFromValue.h"

@implementation OSCUserFullEntity
//  <user>
//      <uid>121801</uid>
//      <location><![CDATA[江苏 常州]]></location>
//      <name><![CDATA[jimney]]></name>
//      <followers>0</followers>
//      <fans>0</fans>
//      <score>1</score>
//      <portrait>http://static.oschina.net/uploads/user/60/121801_100.jpg?t=1355965412000</portrait>
//  </user>
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.location = [NSString stringFromValue:dic[@"location"]];
        // followers  fans  score
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCUserFullEntity* entity = [[OSCUserFullEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
