//
//  RCTopicDetailModel.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"
#import "OSCNewsDetailEntity.h"

@interface OSCRepliesTimelineModel : OSCBaseTableModel

@property (nonatomic, assign) OSCContentType homeType;
@property (nonatomic, assign) unsigned long topicId;

@end
