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
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Init

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
    
    // must to do this，dirty!
    OSCCatalogType catalogType = [OSCGlobalConfig catalogTypeForContentType:self.contentType];
    switch (self.contentType) {
        case OSCContentType_LatestNews:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogType:catalogType
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
            path = [OSCAPIClient relativePathForRepliesListWithCatalogType:catalogType
                                                                 contentId:self.topicId
                                                               pageCounter:self.pageCounter
                                                              perpageCount:self.perpageCount];
            break;
            
        case OSCContentType_Tweet:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogType:catalogType
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    
}

@end
