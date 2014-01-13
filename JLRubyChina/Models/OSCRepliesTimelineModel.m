//
//  RCTopicDetailModel.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCRepliesTimelineModel.h"
#import "OSCReplyCell.h"
#import "OSCReplyEntity.h"

@implementation OSCRepliesTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"comments";
        self.itemElementName = @"comment";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
// http://www.oschina.net/action/api/blogcomment_list?id=187132
- (NSString*)relativePath
{
    NSString* path = nil;
    
    // 由于接口未统一，不得不怎么做，dirty!
    switch (self.homeType) {
        case OSCContentType_LatestNews:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogId:CATALOG_NEWS
                                                               contentId:self.topicId
                                                             pageCounter:self.pageCounter
                                                            perpageCount:self.perpageCount];
            break;
            
        case OSCContentType_LatestBlog:
        case OSCContentType_RecommendBlog:
            path = [OSCAPIClient relativePathForRepliesListWithBlogId:self.topicId
                                                         pageCounter:self.pageCounter
                                                        perpageCount:self.perpageCount];
            break;
            
        case OSCContentType_Forum:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogId:CATALOG_FORUM
                                                               contentId:self.topicId
                                                             pageCounter:self.pageCounter
                                                            perpageCount:self.perpageCount];
            break;
            
        case OSCContentType_Tweet:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogId:CATALOG_TWEET
                                                               contentId:self.topicId
                                                             pageCounter:self.pageCounter
                                                            perpageCount:self.perpageCount];
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [OSCReplyEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCReplyCell class];
}

@end
