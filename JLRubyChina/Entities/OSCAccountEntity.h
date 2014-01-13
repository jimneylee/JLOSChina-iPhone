//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

//<oschina>
//  <result>
//      <errorCode>1</errorCode>
//      <errorMessage><![CDATA[登录成功]]></errorMessage>
//  </result>
//  <user>
//      <uid>121801</uid>
//      <location><![CDATA[江苏 常州]]></location>
//      <name><![CDATA[jimney]]></name>
//      <followers>0</followers>
//      <fans>0</fans>
//      <score>1</score>
//      <portrait>http://static.oschina.net/uploads/user/60/121801_100.jpg?t=1355965412000</portrait>
//  </user>
//  <notice>
//      <atmeCount>0</atmeCount>
//      <msgCount>0</msgCount>
//      <reviewCount>0</reviewCount>
//      <newFansCount>0</newFansCount>
//  </notice>
//</oschina>
@interface OSCAccountEntity : NSObject
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* username;

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

