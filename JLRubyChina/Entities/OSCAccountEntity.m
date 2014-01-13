//
//  OSCAccountEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAccountEntity.h"
#import "SSKeychain.h"

NSString* kDefaultForumService = @"DefaultForumService";
NSString* kUserCookie = @"UserCookie";
NSString* kLoginedUserName = @"LoginedUserName";

@implementation OSCAccountEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUsername:(NSString*)username password:(NSString*)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAccountEntity*)loadStoredUserAccount
{
    NSString* username = [OSCAccountEntity readUsername];
    NSString* password = [OSCAccountEntity readPassword];
    if (username && password) {
        OSCAccountEntity* user = [[OSCAccountEntity alloc] init];
        user.username = username;
        user.password = password;
        return user;
    }
    return nil;
}

#pragma mark - Store & read username
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storeUsername:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kLoginedUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readUsername
{
    NSString* loginedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedUserName];
    return loginedUsername;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginedUsername
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginedUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Store & read password
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storePassword:(NSString*)password forUsername:(NSString*)username
{
    NSError *error = nil;
    BOOL success = [SSKeychain setPassword:password
                                forService:kDefaultForumService
                                   account:username error:&error];
    if (!success || error) {
        NSLog(@"can NOT store account");
    }
    else {
        [OSCAccountEntity storeUsername:username];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readPassword
{
    NSString* loginedUserName = [OSCAccountEntity readUsername];
    NSString* password = [SSKeychain passwordForService:kDefaultForumService
                                                account:loginedUserName];
    return password;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deletePassword
{
    NSString* loginedUserName = [OSCAccountEntity readUsername];
    [SSKeychain deletePasswordForService:kDefaultForumService account:loginedUserName];
}

#pragma mark - Store & read cookie
///////////////////////////////////////////////////////////////////////////////////////////////////
//Cookie = "84YS_ee7b_saltkey=5WjBYAU6; 84YS_ee7b_lastvisit=1374814062; 84YS_ee7b_sid=aCa5xa; 84YS_ee7b_lastact=1374817662%09gs_android_user.php%09logging; 84YS_ee7b_auth=06aeN1Eo%2Bth%2Bx4G9NPRW0GDB2CxwXj9Pr4XN%2BoaXfjgR7iJeu5EverSfrjATEzhrOApotjiehFn1jNobqU90; 84YS_ee7b_loginuser=deleted; 84YS_ee7b_activationauth=deleted; 84YS_ee7b_pmnum=deleted";
+ (void)storeUserCookie:(NSString*)cookie
{
    NSError *error = nil;
    BOOL success = [SSKeychain setPassword:cookie
                                forService:kDefaultForumService
                                   account:kUserCookie error:&error];
    if (!success || error) {
        NSLog(@"can NOT store account");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readUserCookie
{
    NSString* cookie = [SSKeychain passwordForService:kDefaultForumService account:kUserCookie];
    return cookie;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteUserCookie
{
    [SSKeychain deletePasswordForService:kDefaultForumService account:kUserCookie];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delete Logined User's Data

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginedUserDiskData
{
    [OSCAccountEntity deleteUserCookie];
    [OSCAccountEntity deletePassword];
    //!Notice:maybe delte name last
    [OSCAccountEntity deleteLoginedUsername];
}

@end
