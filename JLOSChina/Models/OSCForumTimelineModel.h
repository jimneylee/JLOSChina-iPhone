//
//  RCForumTopicsModel.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCForumTimelineModel : OSCBaseTableModel

@property (nonatomic, assign) OSCForumTopicType topicType;
@property (nonatomic, assign) unsigned int catalogType;

@end
