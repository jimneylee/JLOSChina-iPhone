//
//  SMFriendsModel.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCFriendsModel.h"
#import "OSCAPIClient.h"
#import "OSCFriendEntity.h"
#import "OSCFriendListEntity.h"
#import "OSCFriendCell.h"

@implementation OSCFriendsModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.perpageCount = 200;
        self.hasMoreData = NO;//default just get one page and sort them
        self.listElementName = @"friends";
        self.itemElementName = @"friend";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [OSCAPIClient relativePathForFriendsListWithUserId:[OSCGlobalConfig loginedUserEntity].authorId
                                                  pageCounter:0//default just get one page and sort them
                                                 perpageCount:self.perpageCount];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [OSCFriendEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCFriendCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataToIndexPaths
{
    OSCFriendListEntity* entity = [OSCFriendListEntity entityWithDataArray:self.listDataArray];
    NITableViewModelSection* s = nil;
    NSMutableArray* modelSections = [NSMutableArray arrayWithCapacity:entity.items.count];
    for (int i = 0; i < entity.items.count; i++) {
        s = [NITableViewModelSection section];
        s.headerTitle = entity.sections[i];
        s.rows = entity.items[i];
        [modelSections addObject:s];
    }
    self.sections = modelSections;
    self.sectionIndexTitles = entity.sections;

    if (self.showIndexPathsBlock) {
        self.showIndexPathsBlock(self.sections, nil);
        // TODO: show search bar
        [self setSectionIndexType:NITableViewModelSectionIndexDynamic showsSearch:YES showsSummary:YES];
    }
}

@end
