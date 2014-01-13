//
//  RCTopicDetailHeaderView.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCCommonDetailEntity.h"

@protocol OSCCommonBodyViewDelegate <NSObject>

- (void)didFinishLoadBodyContent;

@end
@interface OSCCommonBodyView : UIView

@property (nonatomic, assign) id<OSCCommonBodyViewDelegate> delegate;
- (void)updateViewWithTopicDetailEntity:(OSCCommonDetailEntity*)topicDetailEntity;
@end
