//
//  RCForumTopicsModel.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCTweetTimelineModel : OSCBaseTableModel

@property (nonatomic, assign) OSCTweetType tweetType;
@property (nonatomic, assign) unsigned int catalogType;

@end
