//
//  RCQuickReplyC.h
//  JLOSChina
//
//  Created by Lee jimney on 12/12/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "OSCEmotionMainView.h"
#import "OSCReplyEntity.h"

@protocol RCQuickReplyDelegate;
@interface OSCQuickReplyC : UIViewController<HPGrowingTextViewDelegate>

@property(nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) OSCEmotionMainView* emojiView;
@property (nonatomic, assign) id<RCQuickReplyDelegate> replyDelegate;
@property (nonatomic, assign) unsigned long topicId;
@property (nonatomic, assign) OSCCatalogType catalogType;

- (id)initWithTopicId:(unsigned long)topicId catalogType:(OSCCatalogType)catalogType;
- (void)appendString:(NSString*)string;

@end

@protocol RCQuickReplyDelegate <NSObject>
@optional
- (void)didReplySuccessWithMyReply:(OSCReplyEntity*)replyEntity;
- (void)didReplyFailure;
- (void)didReplyCancel;

@end
