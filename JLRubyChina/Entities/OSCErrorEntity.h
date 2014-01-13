//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#define ERROR_CODE_SUCCESS 1
@interface OSCErrorEntity : NSObject
@property (nonatomic, assign) NSUInteger errorCode;
@property (nonatomic, copy) NSString* errorMessage;

+ (id)entityWithDictionary:(NSDictionary*)dic;
- (id)initWithDictionary:(NSDictionary*)dic;

@end
