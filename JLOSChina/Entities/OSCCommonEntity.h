//
//  RCTopicEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "OSCUserEntity.h"

@interface OSCCommonEntity : JLNimbusEntity

@property (nonatomic, strong) OSCUserEntity* user;
@property (nonatomic, assign) unsigned long newsId;
@property (nonatomic, strong) NSDate* createdAtDate;
@property (nonatomic, assign) unsigned long repliesCount;

@end
