//
//  RCTopicDetailEntity.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCCommonDetailEntity.h"
#import "RCRegularParser.h"
#import "NSString+Emojize.h"
#import "NSAttributedStringMarkdownParser.h"

@implementation OSCCommonDetailEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[XML_BODY];
        self.attributedBody = [[NSAttributedString alloc] initWithString:self.body];
        [self parseAllKeywords];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCCommonDetailEntity* entity = [[OSCCommonDetailEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        NSString* trimedString = self.body;
        self.imageUrlsArray = [RCRegularParser imageUrlsInString:self.body trimedString:&trimedString];
        self.body = trimedString;
        
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
    }
}

@end
