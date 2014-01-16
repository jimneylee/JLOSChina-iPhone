//
//  RCForumTopicsModel.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCHomeTimelineModel : OSCBaseTableModel

@property (nonatomic, assign) OSCContentType contentType;
@property (nonatomic, assign) unsigned int catalogType;

@end
