//
//  RCReplyEntity.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "OSCUserEntity.h"

@interface OSCReplyEntity : JLNimbusEntity

@property (nonatomic, strong) OSCUserEntity* user;
@property (nonatomic, copy) NSString* replyId;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, strong) NSDate* createdAtDate;
@property (nonatomic, assign) NSUInteger floorNumber;
@property (nonatomic, copy) NSString* floorNumberString;
@property (nonatomic, strong) NSArray* atPersonRanges;
@property (nonatomic, strong) NSArray* sharpSoftwareRanges;
@property (nonatomic, strong) NSArray* emotionRanges;
@property (nonatomic, strong) NSArray* emotionImageNames;

@end
