//
//  RCTopicDetailEntity.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCNewsEntity.h"

@interface OSCNewsDetailEntity : OSCNewsEntity

@property (nonatomic, assign) unsigned long hitsCount;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, copy) NSAttributedString* attributedBody;
@property (nonatomic, strong) NSArray* atPersonRanges;
@property (nonatomic, strong) NSArray* sharpFloorRanges;
@property (nonatomic, strong) NSArray* emotionRanges;
@property (nonatomic, strong) NSArray* imageUrlsArray;

@end
