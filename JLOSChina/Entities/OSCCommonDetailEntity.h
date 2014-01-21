//
//  RCTopicDetailEntity.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCCommonEntity.h"

@interface OSCCommonDetailEntity : OSCCommonEntity

@property (nonatomic, assign) unsigned long hitsCount;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, copy) NSAttributedString* attributedBody;
@property (nonatomic, strong) NSArray* atPersonRanges;
@property (nonatomic, strong) NSArray* imageUrlsArray;

@end
