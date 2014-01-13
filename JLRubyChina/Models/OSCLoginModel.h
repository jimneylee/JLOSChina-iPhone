//
//  RCSignModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCAccountEntity.h"
#import "OSCUserFullEntity.h"
#import "OSCErrorEntity.h"
#import "OSCNoticeEntity.h"

typedef void (^ReturnBlock)(OSCUserFullEntity* userEntity, OSCErrorEntity* errorEntity);

@interface OSCLoginModel : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) OSCAccountEntity* accountEntity;
@property (nonatomic, strong) OSCUserFullEntity* userEntity;
@property (nonatomic, strong) OSCErrorEntity* errorEntity;
@property (nonatomic, strong) OSCNoticeEntity* noticeEntiy;
@property (nonatomic, strong) ReturnBlock returnBlock;

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCUserFullEntity* userEntity, OSCErrorEntity* errorEntity))block;

@end
