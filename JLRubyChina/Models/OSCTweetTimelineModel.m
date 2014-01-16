//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCTweetCell.h"
#import "OSCTweetEntity.h"

#define XML_NOTICE @"notice"

@interface OSCTweetTimelineModel()

@end

@implementation OSCTweetTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"tweets";
        self.itemElementName = @"tweet";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path = nil;
    switch (self.tweetType) {
        case OSCTweetType_Latest:
            path = [OSCAPIClient relativePathForTweetListWithUserId:@"0"
                                                        pageCounter:self.pageCounter
                                                        perpageCount:self.perpageCount];
            break;
            
        case OSCTweetType_Hot:
            path = [OSCAPIClient relativePathForTweetListWithUserId:@"-1"
                                                        pageCounter:self.pageCounter
                                                       perpageCount:self.perpageCount];
            break;
            
        case OSCTweetType_Mine:
        {
            if ([OSCGlobalConfig loginedUserEntity].authorId > 0) {
                NSString* uid = [NSString stringWithFormat:@"%ld",
                                 [OSCGlobalConfig loginedUserEntity].authorId];
                path = [OSCAPIClient relativePathForTweetListWithUserId:uid//暂用红薯id=12测试
                                                            pageCounter:self.pageCounter
                                                           perpageCount:self.perpageCount];
            }

            break;
        }
            
        default:
            break;
    }

    return path;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCTweetEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCTweetCell class];
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
