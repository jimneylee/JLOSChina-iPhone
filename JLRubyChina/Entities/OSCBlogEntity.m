//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBlogEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"

@implementation OSCBlogEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        // 由于接口未统一，不得不怎么做，dirty!
        self.user = [OSCUserEntity entityWithDictionary:@{@"author" : [NSString stringFromValue:dic[@"authorname"]],
                                                         @"authorid" : [NSString stringFromValue:dic[@"authoruid"]],
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
    
    OSCBlogEntity* entity = [[OSCBlogEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
