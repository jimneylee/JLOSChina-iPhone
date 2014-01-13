//
//  RCReplyEntity.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCReplyEntity.h"
#import "NSDate+OSChina.h"
#import "RCRegularParser.h"
#import "NSString+Emojize.h"
#import "NSString+stringFromValue.h"

@implementation OSCReplyEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[XML_CONTENT];
        self.createdAtDate = [NSDate normalFormatDateFromString:dic[@"pubDate"]];
        self.user = [OSCUserEntity entityWithDictionary:@{@"author" : [NSString stringFromValue:dic[@"author"]],
                                                         @"authorid" : [NSString stringFromValue:dic[@"authorid"]],
                                                         @"portrait" : [NSString stringFromValue:dic[@"portrait"]]}];
        
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
    
    OSCReplyEntity* entity = [[OSCReplyEntity alloc] initWithDictionary:dic];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)floorNumberString
{
    //TODO: not show floor, add later on
    return @"";
    
    if (!_floorNumberString.length) {
        NSString* louString = nil;
        switch (_floorNumber) {
            case 1:
                louString = @"沙发";
                break;
            case 2:
                louString = @"板凳";
                break;
            case 3:
                louString = @"地板";
                break;
            default:
                louString = [NSString stringWithFormat:@"%u楼", _floorNumber];
        }
        _floorNumberString = [louString copy];
    }
    return _floorNumberString;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// inline sort by reply id, remove it when api return sorted array
- (NSComparisonResult)compare:(OSCReplyEntity*)other
{
    return [self.replyId compare:other.replyId];
}

@end
