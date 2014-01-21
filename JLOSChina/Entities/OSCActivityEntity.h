//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface OSCActivityEntity : JLNimbusEntity
@property (nonatomic, assign) unsigned long authorId;
@property (nonatomic, copy) NSString* authorName;
@property (nonatomic, copy) NSString* avatarUrl;
@end
