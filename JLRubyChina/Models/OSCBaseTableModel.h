//
//  NITimelineTableModel.h
//  NimbusTimeline
//
//  Created by Lee jimney on 7/27/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusTableModel.h"
#import "OSCAPIClient.h"
#import "OSCErrorEntity.h"
#import "OSCNoticeEntity.h"

typedef void (^ShowIndexPathsBlock)(NSArray* indexPaths, NSError *error);

@interface OSCBaseTableModel : JLNimbusTableModel<NSXMLParserDelegate>
@property (nonatomic, copy) NSString* listElementName;
@property (nonatomic, copy) NSString* itemElementName;
@property (nonatomic, copy) NSString* superElementName;
@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
@property (nonatomic, strong) NSMutableString* tmpInnerElementText;//mutable must retain->www.stackoverflow.com/questions/3686341/nsmutablestring-appendstring-generates-a-sigabrt

@property (nonatomic, strong) NSMutableArray* listDataArray;
@property (nonatomic, strong) OSCErrorEntity* errorEntity;
@property (nonatomic, strong) OSCNoticeEntity* noticeEntiy;
@property (nonatomic, strong) ShowIndexPathsBlock showIndexPathsBlock;

@end
