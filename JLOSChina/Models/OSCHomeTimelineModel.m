//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCHomeTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCNewsCell.h"
#import "OSCCommonEntity.h"
#import "OSCBlogEntity.h"

#define XML_NOTICE @"notice"

@interface OSCHomeTimelineModel()

@end

@implementation OSCHomeTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {

	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path = nil;
    
    // 由于接口未统一，不得不怎么做，dirty!
    switch (self.contentType) {
        case OSCContentType_LatestNews:
            path = [OSCAPIClient relativePathForLatestNewsListWithPageCounter:self.pageCounter
                                                        perpageCount:self.perpageCount];
            self.listElementName = @"newslist";
            self.itemElementName = @"news";
            break;
        case OSCContentType_LatestBlog:
            path = [OSCAPIClient relativePathForLatestBlogsListWithPageCounter:self.pageCounter
                                                             perpageCount:self.perpageCount];
            self.listElementName = @"blogs";
            self.itemElementName = @"blog";
            break;
            
        case OSCContentType_RecommendBlog:
            path = [OSCAPIClient relativePathForRecommendBlogsListWithPageCounter:self.pageCounter
                                                                perpageCount:self.perpageCount];
            self.listElementName = @"blogs";
            self.itemElementName = @"blog";
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    // 由于接口未统一，不得不怎么做，dirty!
    switch (self.contentType) {
        case OSCContentType_LatestNews:
            return [OSCCommonEntity class];
            break;
            
        case OSCContentType_LatestBlog:
        case OSCContentType_RecommendBlog:
            return [OSCBlogEntity class];
            break;
            
        default:
            return [OSCBlogEntity class];
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCNewsCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"catalog"]) {
        self.catalogType = [self.tmpInnerElementText integerValue];
    }
    // super will set nil to self.tmpInnerElementText
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
}

@end
