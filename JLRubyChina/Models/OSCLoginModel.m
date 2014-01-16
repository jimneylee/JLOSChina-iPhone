//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCLoginModel.h"
#import "OSCAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDataAdditions.h"

@interface OSCLoginModel()

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementNamesArray = @[XML_USER];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [OSCAPIClient relativePathForSignIn];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataDictionary
{
    NSMutableDictionary* dic = self.dataDictionary[XML_USER];
    // TODO: dirty code: set uid -> authorid, name -> author
    if (dic[@"uid"]) {
        [dic setObject:dic[@"uid"] forKey:@"authorid"];
    }
    if (dic[@"name"]) {
        [dic setObject:dic[@"name"] forKey:@"author"];
    }
    self.userEntity = [OSCUserFullEntity entityWithDictionary:dic];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    [OSCAccountEntity storePassword:self.accountEntity.password
                        forUsername:self.accountEntity.username];
    if (ERROR_CODE_SUCCESS == self.errorEntity.errorCode) {
        self.loginBlock(self.userEntity, self.errorEntity);
    }
    else {
        self.loginBlock(nil, self.errorEntity);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    self.loginBlock(nil, self.errorEntity);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block
{
    self.accountEntity = [[OSCAccountEntity alloc] initWithUsername:username password:password];
    self.loginBlock = block;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:@"1" forKey:@"keep_login"];
    
    [self postParams:params errorBlock:^(OSCErrorEntity *errorEntity) {
        if (ERROR_CODE_SUCCESS == errorEntity.errorCode) {
            block(self.userEntity, errorEntity);
        }
        else {
            block(nil, errorEntity);
        }
    }];
}

@end
