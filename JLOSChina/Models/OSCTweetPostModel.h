//
//  RCReplyModel.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCBaseModel.h"

typedef void (^SuccessBlock)();
typedef void (^FailureBlock)(OSCErrorEntity* errorEntity);

@interface OSCTweetPostModel : OSCBaseModel

@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;

// only post content
- (void)postNewTweetWithBody:(NSString*)body
                     success:(void(^)())success
                     failure:(void(^)(OSCErrorEntity *error))failure;
// maybe post with image
- (void)postNewTweetWithBody:(NSString*)body
                       image:(UIImage*)image
                     success:(void(^)())success
                     failure:(void(^)(OSCErrorEntity* errorEntity))failure;
@end
