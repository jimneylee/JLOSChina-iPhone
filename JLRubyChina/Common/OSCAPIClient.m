//
//  OSCAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAPIClient.h"
#import "AFXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"

NSString *const kAPIBaseURLString = @"http://www.oschina.net/action/api/";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation OSCAPIClient

+ (NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }
    else
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [settings setObject:uuidString forKey:@"guid"];
        [settings synchronize];
        return uuidString;
    }
}

#define AppVersion @"1.0.0"
+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"OSChina.NET/%@/%@/%@/%@",AppVersion,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAPIClient*)sharedClient
{
    static OSCAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
        [self unregisterHTTPOperationClass:[AFImageRequestOperation class]];
        [self registerHTTPOperationClass:[AFXMLRequestOperation class]];
        
        // idea from old version app
        NSString* userAgent = [NSString stringWithFormat:@"%@/%@",
                               [OSCAPIClient getOSVersion],
                               [OSCAPIClient getIOSGuid]];
        [self setDefaultHeader:@"User-Agent" value:userAgent];
        [self setDefaultHeader:@"Accept" value:@"application/xml"];
        
        // 502-bad-gateway error, set user agent from http://whatsmyuseragent.com/
        // http://stackoverflow.com/questions/8487581/uiwebview-ios5-changing-user-agent/8666438#8666438
//        NSString* userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B508 Safari/9537.53";
//        [self setDefaultHeader:@"User-Agent" value:userAgent];
    }
    return self;
}

#pragma mark - Sign in
// 登录
+ (NSString*)relativePathForSignIn
{
    return [NSString stringWithFormat:@"account/sign_in.json"];
}

#pragma mark - Topics
// 活跃帖子、优质帖子、无人问津、最近创建
// TODO: add topic type:
+ (NSString*)relativePathForLatestNewsListWithPageCounter:(unsigned int)pageCounter
                                             perpageCount:(unsigned int)perpageCount
{

    return [NSString stringWithFormat:@"news_list?catalog=1&pageIndex=%u&pageSize=%u",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForLatestBlogsListWithPageCounter:(unsigned int)pageCounter
                                              perpageCount:(unsigned int)perpageCount
{
    
    return [NSString stringWithFormat:@"blog_list?type=latest&pageIndex=%u&pageSize=%u",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForRecommendBlogsListWithPageCounter:(unsigned int)pageCounter
                                                 perpageCount:(unsigned int)perpageCount
{
    
    return [NSString stringWithFormat:@"blog_list?type=recommend&pageIndex=%u&pageSize=%u",
            pageCounter, perpageCount];
}

+ (NSString*)relativePathForNewsDetailWithId:(unsigned long)newsId
{
    return [NSString stringWithFormat:@"news_detail?id=%ld", newsId];
}

+ (NSString*)relativePathForBlogDetailWithId:(unsigned long)blogId
{
    return [NSString stringWithFormat:@"blog_detail?id=%ld", blogId];
}

+ (NSString*)relativePathForRepliesListWithNewsId:(unsigned long)newsId
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    // TODO:for news comment, set category: 1, and dor other I donot know now
    return [NSString stringWithFormat:@"comment_list?catalog=1&id=%ld&pageIndex=%u&pageSize=%u",
                                        newsId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForRepliesListWithBlogId:(unsigned long)blogId
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    // TODO:for news comment, set category: 1, and dor other I donot know now
    return [NSString stringWithFormat:@"blogcomment_list?id=%ld&pageIndex=%u&pageSize=%u",
                                        blogId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForForumListWithForumType:(OSCForumTopicType)type
                                       pageCounter:(unsigned int)pageCounter
                                      perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"post_list?catalog=%u&pageIndex=%u&pageSize=%u",
                                        type+1, pageCounter, perpageCount];
}

+ (NSString*)relativePathForTopicDetailWithId:(unsigned long)blogId
{
    return [NSString stringWithFormat:@"post_detail?id=%ld", blogId];
}

+ (NSString*)relativePathForReply
{
    return [NSString stringWithFormat:@"comment_reply"];
}

@end
