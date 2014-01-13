//
//  RCTopicEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"
#import "RCRegularParser.h"

@implementation OSCTweetEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.tweetId = [dic[XML_ID] longLongValue];
        self.body = [NSString stringFromValue:dic[XML_BODY]];
        self.createdAtDate = [NSDate normalFormatDateFromString:dic[@"pubDate"]];
        self.repliesCount = [dic[@"commentCount"] longLongValue];
        self.user = [OSCUserEntity entityWithDictionary:@{@"author" : [NSString stringFromValue:dic[@"author"]],
                                                         @"authorid" : [NSString stringFromValue:dic[@"authorid"]],
                                                         @"portrait" : [NSString stringFromValue:dic[@"portrait"]]}];
        self.smallImageUrl = [NSString stringFromValue:dic[@"imgSmall"]];
        self.bigImageUrl = [NSString stringFromValue:dic[@"imgBig"]];
        // 与其每个微博加载都卡，不如这边一次都解析好
        [self parseAllKeywords];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCTweetEntity* entity = [[OSCTweetEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        // TODO: emotion
        // 考虑优先剔除表情，这样@和#不会勿标识
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
//        if (!self.sharpTrendRanges) {
//            self.sharpTrendRanges = [RCRegularParser keywordRangesOfSharpTrendInString:self.text];
//        }
    }
}

@end
