//
//  OSCCommonDetailModel.h
//  JLOSChina
//
//  Created by Lee jimney on 1/12/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"
#import "OSCCommonDetailEntity.h"

@interface OSCCommonDetailModel : OSCBaseTableModel

@property (nonatomic, assign) OSCContentType contentType;
@property (nonatomic, assign) unsigned long topicId;
@property (nonatomic, strong) OSCCommonDetailEntity* topicDetailEntity;

@end
