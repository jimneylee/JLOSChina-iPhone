//
//  OSCNoticeEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//


@interface OSCNoticeEntity : NSObject

@property (nonatomic, assign) NSUInteger atMeCount;
@property (nonatomic, assign) NSUInteger msgCount;
@property (nonatomic, assign) NSUInteger reviewCount;
@property (nonatomic, assign) NSUInteger newFansCount;

+ (id)entityWithDictionary:(NSDictionary*)dic;
- (id)initWithDictionary:(NSDictionary*)dic;

@end
