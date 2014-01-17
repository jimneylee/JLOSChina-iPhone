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
@property (nonatomic, assign) BOOL isReplyComment;

// reply alse for other's comment, just add @someone
- (void)replyContentId:(unsigned long)topicId
         catalogType:(OSCCatalogType)catalogType
                body:(NSString*)body
             success:(void(^)(OSCReplyEntity* replyEntity))success
             failure:(void(^)(OSCErrorEntity* error))failure;
// this is useless
- (void)replyCommentId:(unsigned long)commentId
             contentId:(unsigned long)topicId
           catalogType:(OSCCatalogType)catalogType
                  body:(NSString*)body
               success:(void(^)(OSCReplyEntity* replyEntity))success
               failure:(void(^)(OSCErrorEntity* error))failure;
@end
