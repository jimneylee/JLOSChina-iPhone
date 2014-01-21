//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCCommonEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"

@implementation OSCCommonEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        
        self.newsId = [dic[XML_ID] longLongValue];
        self.title = dic[XML_TITLE];
        
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
    
    OSCCommonEntity* entity = [[OSCCommonEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
