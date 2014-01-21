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

//view-source:http://www.oschina.net/action/api/my_information?uid=121801
//<user>
//    <name><![CDATA[jimney]]></name>
//    <portrait><![CDATA[http://static.oschina.net/uploads/user/60/121801_100.jpg?t=1389938746000]]></portrait>
//    <jointime>2011-02-22 17:27:05</jointime>
//    <gender>1</gender>
//    <from><![CDATA[江苏 常州]]></from>
//    <devplatform><![CDATA[Android,iOS/Objective-C,C/C++,Linux/Unix]]></devplatform>
//    <expertise><![CDATA[手机软件开发]]></expertise>
//    <favoritecount>0</favoritecount>
//    <fanscount>8</fanscount>
//    <followerscount>0</followerscount>
//</user>

// TODO: 建议开源中国的接口统一字段名称，后期易维护

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.location = [NSString stringFromValue:dic[@"location"]];//from
        self.joinTime = [NSString stringFromValue:dic[@"jointime"]];
        self.developPlatform = [NSString stringFromValue:dic[@"devplatform"]];
        self.expertise = [NSString stringFromValue:dic[@"expertise"]];

        // followers  fans  score
        self.followersCount = [dic[@"followerscount"] longLongValue];//followers
        self.fansCount = [dic[@"fanscount"] longLongValue];//fans
        self.favoriteCount = [dic[@"favoritecount"] longLongValue];
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
