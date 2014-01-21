//
//  RCSignModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseModel.h"
#import "OSCUserFullEntity.h"

typedef void (^ReturnBlock)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity);

@interface OSCMyInfoModel : OSCBaseModel<NSXMLParserDelegate>

@property (nonatomic, strong) OSCUserFullEntity* userEntity;
@property (nonatomic, strong) ReturnBlock returnBlock;

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block;

@end
