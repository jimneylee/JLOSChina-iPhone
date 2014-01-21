//
//  RCTopicEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface OSCRelativeEntity : JLNimbusEntity

@property (nonatomic, copy) NSString* url;
@property (nonatomic, assign) unsigned long contentId;

@end
