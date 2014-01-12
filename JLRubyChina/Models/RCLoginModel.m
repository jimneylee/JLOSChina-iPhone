//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCLoginModel.h"
#import "OSCAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDataAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCAccountEntity* user, NSError *error))block
{
    NSString* path = [OSCAPIClient relativePathForSignIn];
    
    // 由于登录的接口与其他接口base_url不太一样，后台没有放到api路径下，故单独处理
    // ruby-china.org/account/sign_in.json
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ruby-china.org/"]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient postPath:path parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         OSCAccountEntity* account = [OSCAccountEntity entityWithDictionary:responseObject];
                                         [OSCGlobalConfig setMyLoginId:account.loginId];
                                         [OSCGlobalConfig setMyToken:account.privateToken];
                                         [OSCAccountEntity storePrivateToken:account.privateToken forLoginId:account.loginId];
                                         if (block) {
                                             block(account, nil);
                                         }
                                     }
                                     else {
                                         if (block) {
                                             NSError* error = [[NSError alloc] init];
                                             block(nil, error);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     //NSDictionary* info = [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                                     //NSLog(@"error: %@", [info objectForKey:@"error"]);
                                     //NSLog(@"error: %@", error);
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
}

@end
