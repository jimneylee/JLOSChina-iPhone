//
//  RCReplyModel.h
//  JLOSChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCBaseModel.h"
#import "OSCReplyEntity.h"

typedef void (^SuccessBlock)(OSCReplyEntity* entity);
typedef void (^FailureBlock)(OSCErrorEntity* errorEntity);

@interface OSCReplyModel : OSCBaseModel

@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;
@property (nonatomic, strong) OSCReplyEntity* replyEntity;

- (void)replyTopicId:(unsigned long)topicId
         catalogType:(OSCCatalogType)catalogType
                body:(NSString*)body
             success:(void(^)(OSCReplyEntity* replyEntity))success
             failure:(void(^)(OSCErrorEntity* error))failure;
@end
