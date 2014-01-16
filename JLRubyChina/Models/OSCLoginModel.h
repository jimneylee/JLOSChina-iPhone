//
//  RCSignModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCBaseModel.h"
#import "OSCAccountEntity.h"
#import "OSCUserFullEntity.h"
#import "OSCErrorEntity.h"
#import "OSCNoticeEntity.h"

typedef void (^LoginBlock)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity);

@interface OSCLoginModel : OSCBaseModel<NSXMLParserDelegate>

@property (nonatomic, strong) OSCAccountEntity* accountEntity;
@property (nonatomic, strong) OSCUserFullEntity* userEntity;
@property (nonatomic, strong) LoginBlock loginBlock;

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block;

@end
