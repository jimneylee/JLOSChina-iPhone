//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCForumTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCNewsCell.h"
#import "OSCTopicEntity.h"

#define XML_NOTICE @"notice"

@interface OSCForumTimelineModel()

@end

@implementation OSCForumTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"posts";
        self.itemElementName = @"post";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path = nil;
    path = [OSCAPIClient relativePathForForumListWithForumType:self.topicType
                                                   pageCounter:self.pageCounter
                                                  perpageCount:self.perpageCount];
    return path;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCTopicEntity class];
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
