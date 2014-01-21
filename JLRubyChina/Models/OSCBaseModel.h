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

@interface OSCBaseModel : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NSArray* itemElementNamesArray;
@property (nonatomic, strong) OSCAccountEntity* accountEntity;
@property (nonatomic, strong) OSCErrorEntity* errorEntity;
@property (nonatomic, strong) OSCNoticeEntity* noticeEntiy;
@property (nonatomic, strong) NSMutableDictionary* dataDictionary;

- (void)postParams:(NSDictionary*)params errorBlock:(void(^)(OSCErrorEntity* errorEntity))block;
- (void)getParams:(NSDictionary*)params errorBlock:(void(^)(OSCErrorEntity* errorEntity))errorBlock;
- (void)parseDataDictionary;

@end
