//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTopicEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"

@implementation OSCTopicEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.repliesCount = [dic[@"answerCount"] longLongValue];
        // TODO: last replier info
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCTopicEntity* entity = [[OSCTopicEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
