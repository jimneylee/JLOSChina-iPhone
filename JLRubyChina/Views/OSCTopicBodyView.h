//
//  RCTopicDetailHeaderView.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCNewsDetailEntity.h"

@protocol OSCTopicBodyViewDelegate <NSObject>

- (void)didFinishLoadBodyContent;

@end
@interface OSCTopicBodyView : UIView

@property (nonatomic, assign) id<OSCTopicBodyViewDelegate> delegate;
- (void)updateViewWithTopicDetailEntity:(OSCNewsDetailEntity*)topicDetailEntity;
@end
