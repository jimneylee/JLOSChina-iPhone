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
#import "RCKeywordEntity.h"
#import "OSCEmotionEntity.h"

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
// 识别出 表情 at某人 share软件(TODO:) 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
        if (!self.sharpSoftwareRanges) {
            self.sharpSoftwareRanges = [RCRegularParser keywordRangesOfSharpSoftwareInString:self.body];
        }
        if (!self.emotionRanges) {
            NSString* trimedString = self.body;
            self.emotionRanges = [RCRegularParser keywordRangesOfEmotionInString:self.body trimedString:&trimedString];
            self.body = trimedString;
            NSMutableArray* emotionImageNames = [NSMutableArray arrayWithCapacity:self.emotionRanges.count];
            for (RCKeywordEntity* keyworkEntity in self.emotionRanges) {
                NSString* keyword = keyworkEntity.keyword;
                for (OSCEmotionEntity* emotionEntity in [OSCGlobalConfig emotionsArray]) {
                    if ([keyword isEqualToString:emotionEntity.name]) {
                        [emotionImageNames addObject:emotionEntity.imageName];
                        break;
                    }
                }
            }
            self.emotionImageNames = emotionImageNames;
        }
        
        // if body's keywords are all emotion and get empty string, just set a space
        // for nil return in NIAttributedLabel: - (CGSize)sizeThatFits:(CGSize)size
        if (!self.body.length) {
            self.body = @" ";
        }
    }
}

@end
