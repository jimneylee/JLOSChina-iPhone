//
//  OSCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "AFHTTPClient.h"
#import "JLAFHTTPClient.h"

#define api_news_list @"http://www.oschina.net/action/api/news_list"
#define api_news_detail @"http://www.oschina.net/action/api/news_detail"
#define api_post_list @"http://www.oschina.net/action/api/post_list"
#define api_post_detail @"http://www.oschina.net/action/api/post_detail"
#define api_post_pub @"http://www.oschina.net/action/api/post_pub"
#define api_tweet_list @"http://www.oschina.net/action/api/tweet_list"
#define api_tweet_detail @"http://www.oschina.net/action/api/tweet_detail"
#define api_tweet_delete @"http://www.oschina.net/action/api/tweet_delete"
#define api_tweet_pub @"http://www.oschina.net/action/api/tweet_pub"
#define api_active_list @"http://www.oschina.net/action/api/active_list"
#define api_message_list @"http://www.oschina.net/action/api/message_list"
#define api_message_delete @"http://www.oschina.net/action/api/message_delete"
#define api_message_pub @"http://www.oschina.net/action/api/message_pub"
#define api_comment_list @"http://www.oschina.net/action/api/comment_list"
#define api_comment_pub @"http://www.oschina.net/action/api/comment_pub"
#define api_comment_reply @"http://www.oschina.net/action/api/comment_reply"
#define api_comment_delete @"http://www.oschina.net/action/api/comment_delete"
#define api_login_validate @"https://www.oschina.net/action/api/login_validate"
#define api_user_info @"http://www.oschina.net/action/api/user_info"
#define api_user_information @"http://www.oschina.net/action/api/user_information"
#define api_user_updaterelation @"http://www.oschina.net/action/api/user_updaterelation"
#define api_notice_clear @"http://www.oschina.net/action/api/notice_clear"
#define api_software_detail @"http://www.oschina.net/action/api/software_detail"
#define api_blog_detail @"http://www.oschina.net/action/api/blog_detail"
#define api_favorite_list @"http://www.oschina.net/action/api/favorite_list"
#define api_favorite_add @"http://www.oschina.net/action/api/favorite_add"
#define api_favorite_delete @"http://www.oschina.net/action/api/favorite_delete"
#define api_user_notice @"http://www.oschina.net/action/api/user_notice"
#define api_search_list @"http://www.oschina.net/action/api/search_list"
#define api_friends_list @"http://www.oschina.net/action/api/friends_list"
#define api_softwarecatalog_list @"http://www.oschina.net/action/api/softwarecatalog_list"
#define api_software_list @"http://www.oschina.net/action/api/software_list"
#define api_softwaretag_list @"http://www.oschina.net/action/api/softwaretag_list"
#define api_blogcomment_list @"http://www.oschina.net/action/api/blogcomment_list"
#define api_blogcomment_pub @"http://www.oschina.net/action/api/blogcomment_pub"
#define api_my_information @"http://www.oschina.net/action/api/my_information"
#define api_blogcomment_delete @"http://www.oschina.net/action/api/blogcomment_delete"
#define api_userblog_delete @"http://www.oschina.net/action/api/userblog_delete"
#define api_userblog_list @"http://www.oschina.net/action/api/userblog_list"
#define api_blog_list @"http://www.oschina.net/action/api/blog_list"
#define api_userinfo_update @"http://www.oschina.net/action/api/portrait_update"

@interface OSCAPIClient : JLAFHTTPClient

+ (OSCAPIClient*)sharedClient;

//================================================================================
// account sing in
//================================================================================
// 登录
+ (NSString*)relativePathForSignIn;

// 登录
//+ (NSString*)relativePathForSignIn;

//================================================================================
// topic read
//================================================================================

// 资讯、博客、推荐阅读
+ (NSString*)relativePathForLatestNewsListWithPageCounter:(unsigned int)pageCounter
                                   perpageCount:(unsigned int)perpageCount;

+ (NSString*)relativePathForLatestBlogsListWithPageCounter:(unsigned int)pageCounter
                                          perpageCount:(unsigned int)perpageCount;

+ (NSString*)relativePathForRecommendBlogsListWithPageCounter:(unsigned int)pageCounter
                                             perpageCount:(unsigned int)perpageCount;

// 内容详细接口
+ (NSString*)relativePathForNewsDetailWithId:(unsigned long)newsId;

+ (NSString*)relativePathForBlogDetailWithId:(unsigned long)blogId;

+ (NSString*)relativePathForTopicDetailWithId:(unsigned long)blogId;

// 回复列表接口
+ (NSString*)relativePathForRepliesListWithCatalogId:(unsigned int)catalogId
                                           contentId:(unsigned long)contentId
                                         pageCounter:(unsigned int)pageCounter
                                        perpageCount:(unsigned int)perpageCount;

+ (NSString*)relativePathForRepliesListWithBlogId:(unsigned long)blogId
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount;

// 社区分类列表
+ (NSString*)relativePathForForumListWithForumType:(OSCForumTopicType)type
                                     pageCounter:(unsigned int)pageCounter
                                    perpageCount:(unsigned int)perpageCount;

// 最新动弹
+ (NSString*)relativePathForTweetListWithUserId:(NSString*)uid
                                    pageCounter:(unsigned int)pageCounter
                                   perpageCount:(unsigned int)perpageCount;

//================================================================================
// topic write
//================================================================================

+ (NSString*)relativePathForReply;

@end

NSString *const kAPIBaseURLString;