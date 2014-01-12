//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCNewsEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"

@implementation OSCNewsEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        
        self.newsId = [dic[XML_ID] longLongValue];
        self.newsTitle = dic[XML_TITLE];
        
        self.createdAtDate = [NSDate normalFormatDateFromString:dic[@"pubDate"]];
        self.repliesCount = [dic[@"commentCount"] longLongValue];
        self.user = [OSCUserEntity entityWithDictionary:@{@"author" : [NSString stringFromValue:dic[@"author"]],
                                                         @"authorid" : [NSString stringFromValue:dic[@"authorid"]],
                                                         @"portrait" : [NSString stringFromValue:dic[@"portrait"]]}];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCNewsEntity* entity = [[OSCNewsEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
