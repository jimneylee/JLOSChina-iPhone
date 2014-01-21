//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCMyActiveTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCActivityEntity.h"
#import "OSCActivityCell.h"

#define XML_NOTICE @"notice"

@interface OSCMyActiveTimelineModel()
@end

@implementation OSCMyActiveTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"activies";
        self.itemElementName = @"active";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path =
    [OSCAPIClient relativePathForActiveListWithLoginedUserId:[OSCGlobalConfig loginedUserEntity].authorId
                                           activeCatalogType:self.activeCatalogType
                                                 pageCounter:self.pageCounter
                                                perpageCount:self.perpageCount];
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCActivityEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCActivityCell class];
}

@end
