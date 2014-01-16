//
//  OSCCommonDetailModel.m
//  JLOSChina
//
//  Created by Lee jimney on 1/12/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "OSCCommonDetailModel.h"
#import "OSCAPIClient.h"
#import "OSCCommonDetailEntity.h"
#import "OSCRelativeEntity.h"
#import "OSCRelativeCell.h"

@interface OSCCommonDetailModel()
@property (nonatomic, copy) NSString* detailItemElementName;
@property (nonatomic, strong) NSMutableDictionary* detailDictionary;
@end
@implementation OSCCommonDetailModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        // TODO: change JLNimbusModel hasMoreData default NO
        self.hasMoreData = NO;
        
        self.listElementName = @"relativies";
        self.itemElementName = @"relative";
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
    
    switch (self.contentType) {
        case OSCContentType_LatestNews:
            path = [OSCAPIClient relativePathForNewsDetailWithId:self.topicId];
            self.detailItemElementName = @"news";
            break;
            
        case OSCContentType_LatestBlog:
        case OSCContentType_RecommendBlog:
            path = [OSCAPIClient relativePathForBlogDetailWithId:self.topicId];
            self.detailItemElementName = @"blog";
            break;
            
        case OSCContentType_Forum:
            path = [OSCAPIClient relativePathForTopicDetailWithId:self.topicId];
            self.detailItemElementName = @"post";
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [OSCRelativeEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCRelativeCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
    
    // TODO:news boday http://www.oschina.net/action/api/news_detail?id=47609
    if ([elementName isEqualToString:self.detailItemElementName]) {
        self.detailDictionary = [NSMutableDictionary dictionary];
        self.superElementName = self.detailItemElementName;
    }
    else if ([self.superElementName isEqualToString:self.detailItemElementName]) {
        self.tmpInnerElementText = [[NSMutableString alloc] init];;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [super parser:parser foundCharacters:string];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([self.superElementName isEqualToString:self.detailItemElementName]) {
        if (self.detailDictionary  && self.tmpInnerElementText) {
            [self.detailDictionary setObject:self.tmpInnerElementText forKey:elementName];
        }
    }
    // super will set nil to self.tmpInnerElementText
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.topicDetailEntity = [OSCCommonDetailEntity entityWithDictionary:self.detailDictionary];
// TODO: show relative reading
#if 0
    [super parserDidEndDocument:parser];
#else
    NSArray* indexPaths = nil;
    // just set empty array, show empty data but no error
    indexPaths = [NSArray array];
    if (self.showIndexPathsBlock) {
        self.showIndexPathsBlock(indexPaths, nil);
    }
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [super parser:parser parseErrorOccurred:parseError];
}

@end
