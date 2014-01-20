//
//  RCUserEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCActivityEntity.h"

@implementation OSCActivityEntity

//<active>
//<id>3071316</id>
//<portrait>http://static.oschina.net/uploads/user/60/121801_50.jpg?t=1389938746000</portrait>
//<author><![CDATA[jimney]]></author>
//<authorid>121801</authorid>
//<catalog>3</catalog>
//<objecttype>100</objecttype>
//<objectcatalog>0</objectcatalog>
//<objecttitle><![CDATA[]]></objecttitle>
//<appclient>4</appclient>                <url></url>
//<objectID>3071316</objectID>
//<message><![CDATA[新版客户端怎么配色符合大家口味呢[撇嘴]]]></message>
//<commentCount>7</commentCount>
//<pubDate>2014-01-20 15:02:35</pubDate>
//<tweetimage><![CDATA[http://static.oschina.net/uploads/space/2014/0120/150235_gxhv_121801_thumb.jpg]]></tweetimage>
//</active>
                     
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
        // TODO: add others
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCActivityEntity* entity = [[OSCActivityEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
