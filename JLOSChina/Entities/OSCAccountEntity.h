//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface OSCAccountEntity : NSObject
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* username;

- (id)initWithUsername:(NSString*)username password:(NSString*)password;

+ (OSCAccountEntity*)loadStoredUserAccount;

// store & read user account
+ (void)storePassword:(NSString*)password forUsername:(NSString*)username;
+ (NSString*)readPassword;

// store & read user cookie
+ (void)storeUserCookie:(NSString*)cookie;
+ (NSString*)readUserCookie;

// delete logined user's data
+ (void)deleteLoginedUserDiskData;
@end
extern NSString *kDefaultForumService;

