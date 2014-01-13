//
//  RCGlobalConfig.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCLoginC.h"

// 内容类型：资讯、博客、帖子、动弹（微博）类型
typedef enum {
    OSCContentType_LatestNews,//资讯  catalog:1
    OSCContentType_LatestBlog,//博客  catalog:none
    OSCContentType_RecommendBlog,//推荐阅读    catalog:none
    OSCContentType_Forum,//社区帖子    catalog:2
    OSCContentType_Tweet//社区帖子  catalog:3
}OSCContentType;

// 社区活动类型
typedef enum {
    OSCForumTopicType_QA,//问答
    OSCForumTopicType_Share,//分享
    OSCForumTopicType_Watering, //综合灌水
    OSCForumTopicType_Career,//职业
    OSCForumTopicType_Feedback//站务
}OSCForumTopicType;

// 动弹类型
typedef enum {
    OSCTweetType_Latest,//最新 uid=0
    OSCTweetType_Hot,//热门   uid=-1
    OSCTweetType_Mine,//我的  uid=
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
