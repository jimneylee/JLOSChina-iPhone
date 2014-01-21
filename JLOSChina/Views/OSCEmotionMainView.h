//
//  SMEmotionC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "NimbusPagingScrollView.h"

@protocol OSCEmotionDelegate;

@interface OSCEmotionMainView : UIView
@property (nonatomic, assign) id<OSCEmotionDelegate> emotionDelegate;
@end

@protocol OSCEmotionDelegate <NSObject>

@optional
- (void)emotionSelectedWithCode:(NSString*)code;

@end

