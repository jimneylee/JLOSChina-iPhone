//
//  RCGlobalConfig.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCLoginC.h"

// 可归纳为：资讯、博客、帖子、动弹（微博）类型
typedef enum {
    OSCContentType_LatestNews,//资讯
    OSCContentType_LatestBlog,//博客
    OSCContentType_RecommendBlog,//推荐阅读
    OSCContentType_ForumTopic//社区帖子
}OSCContentType;

// 社区活动类型
typedef enum {
    OSCForumTopicType_QA,//问答
    OSCForumTopicType_Share,//分享
    OSCForumTopicType_Watering, //综合灌水
    OSCForumTopicType_Career,//职业
    OSCForumTopicType_Feedback//站务
}OSCForumTopicType;

// 资讯博客类型
typedef enum {
    OSCTweetType_Latest,//最新
    OSCTweetType_Hot,//热门
    OSCTweetType_Mine,//我的
}OSCTweetType;

@interface OSCGlobalConfig : NSObject

//Global Data
+ (NSString*)myToken;
+ (void)setMyToken:(NSString*)token;
+ (NSString*)myLoginId;
+ (void)setMyLoginId:(NSString*)loginId;

// Global UI
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle Target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController;

@end
