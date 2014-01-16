//
//  RCGlobalConfig.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCLoginC.h"
#import "OSCUserFullEntity.h"

// 内容类型：资讯、博客、帖子、动弹（微博）类型
typedef NS_ENUM(NSInteger, OSCContentType) {
    OSCContentType_LatestNews,//资讯  catalog:1
    OSCContentType_LatestBlog,//博客  catalog:none
    OSCContentType_RecommendBlog,//推荐阅读    catalog:none
    OSCContentType_Forum,//社区帖子    catalog:2
    OSCContentType_Tweet//社区帖子  catalog:3
};

// 社区活动类型
typedef NS_ENUM(NSInteger, OSCForumTopicType) {
    OSCForumTopicType_QA,//问答
    OSCForumTopicType_Share,//分享
    OSCForumTopicType_Watering, //综合灌水
    OSCForumTopicType_Career,//职业
    OSCForumTopicType_Feedback//站务
};

// 动弹类型
typedef NS_ENUM(NSInteger, OSCTweetType) {
    OSCTweetType_Latest,//最新 uid=0
    OSCTweetType_Hot,//热门   uid=-1
    OSCTweetType_Mine,//我的  uid=
};

typedef NS_ENUM(NSInteger, OSCCatalogType) {
    OSCCatalogType_News=1,
    OSCCatalogType_Forum=2,
    OSCCatalogType_Tweet=3,
    OSCCatalogType_Blog=-1
};

@interface OSCGlobalConfig : NSObject

//Global Data
+ (OSCUserFullEntity*)loginedUserEntity;
+ (void)setLoginedUserEntity:(OSCUserFullEntity*)userEntity;

// App Info
+ (NSString *)getIOSGuid;
+ (NSString *)getOSVersion;
+ (OSCCatalogType)catalogTypeForContentType:(OSCContentType)contentType;

// Global UI
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController;

// Emotion
+ (NSArray* )emotionsArray;
+ (NSString*)imageNameForEmotionCode:(NSString*)code;
+ (NSString*)imageNameForEmotionName:(NSString*)name;

@end
