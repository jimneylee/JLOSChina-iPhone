//
//  RCTopicEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "OSCUserEntity.h"

@interface OSCTweetEntity : JLNimbusEntity

@property (nonatomic, strong) OSCUserEntity* user;
@property (nonatomic, assign) unsigned long tweetId;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, strong) NSDate* createdAtDate;
@property (nonatomic, assign) unsigned long repliesCount;
@property (nonatomic, copy) NSString* smallImageUrl;
@property (nonatomic, copy) NSString* bigImageUrl;

@property (nonatomic, strong) NSArray* atPersonRanges;
@property (nonatomic, strong) NSArray* sharpSoftwareRanges;
@property (nonatomic, strong) NSArray* emotionRanges;
@property (nonatomic, strong) NSArray* emotionImageNames;

@end
