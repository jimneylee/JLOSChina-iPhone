//
//  RCTopicDetailC.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusTableViewController.h"

// TODO:楼层调转
@interface OSCCommonRepliesListC : JLNimbusTableViewController

- (id)initWithTopicId:(unsigned long)topicId
            topicType:(OSCContentType)topicType
         repliesCount:(unsigned long)repliedCount;

- (void)replyTopicWithFloorAtSomeone:(NSString*)floorAtsomeoneString;

@end
