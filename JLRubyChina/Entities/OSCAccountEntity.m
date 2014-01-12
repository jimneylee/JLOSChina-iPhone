//
//  OSCAccountEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAccountEntity.h"
#import "SSKeychain.h"

NSString* kRubyChinaService = @"RubyChinaService";
NSString* kLoginId = @"LoginId";

//{
//    avatar =     {
//        big =         {
//            url = "photo/big.jpg";
//        };
//        large =         {
//            url = "photo/large.jpg";
//        };
//        normal =         {
//            url = "photo/normal.jpg";
//        };
//        small =         {
//            url = "photo/small.jpg";
//        };
//        url = "photo/.jpg";
//    };
//    email = "jimneylee@gmail.com";
//    login = jimneylee;
//    "private_token" = "8a67b1e1042c8093f709:4988";
//}
@implementation OSCAccountEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.loginId = dic[@""];//TODO:
        self.privateToken = dic[@""];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCAccountEntity* entity = [[OSCAccountEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load & Delete logined user

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAccountEntity*)loadStoredUserAccount
{
    NSString* loginId = [OSCAccountEntity readLoginId];
    NSString* privateToken = [OSCAccountEntity readPrivateToken];
    if (loginId && privateToken) {
        OSCAccountEntity* user = [[OSCAccountEntity alloc] init];
        user.loginId = loginId;
        user.privateToken = privateToken;
        return user;
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginedUserDiskData
{
    [OSCAccountEntity deletePrivateToken];
    [OSCAccountEntity deleteLoginId];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Store & Read login id
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storeLoginId:(NSString*)loginId
{
    [[NSUserDefaults standardUserDefaults] setObject:loginId forKey:kLoginId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readLoginId
{
    NSString* LoginedLoginId = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginId];
    return LoginedLoginId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteLoginId
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Store & Read private token

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storePrivateToken:(NSString*)privateToken forLoginId:(NSString*)loginId
{
    NSError *error = nil;
    BOOL success = [SSKeychain setPassword:privateToken
                                forService:kRubyChinaService
                                   account:loginId error:&error];
    if (!success || error) {
        NSLog(@"can NOT store account");
    }
    else {
        [OSCAccountEntity storeLoginId:loginId];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readPrivateToken
{
    NSString* LoginedLoginId = [OSCAccountEntity readLoginId];
    NSString* password = [SSKeychain passwordForService:kRubyChinaService
                                                account:LoginedLoginId];
    return password;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deletePrivateToken
{
    NSString* LoginedLoginId = [OSCAccountEntity readLoginId];
    [SSKeychain deletePasswordForService:kRubyChinaService account:LoginedLoginId];
}

@end
