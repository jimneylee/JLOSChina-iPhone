//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserActiveTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCActivityEntity.h"
#import "OSCActivityCell.h"

#define XML_NOTICE @"notice"

@interface OSCUserActiveTimelineModel()
@property (nonatomic, copy) NSString* detailItemElementName;
@property (nonatomic, strong) NSMutableDictionary* detailDictionary;
@end

@implementation OSCUserActiveTimelineModel

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
        self.detailItemElementName = @"user";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path =
    [OSCAPIClient relativePathForUserActiveListWithUserId:self.userId
                                               orUsername:self.username
                                            loginedUserId:[OSCGlobalConfig loginedUserEntity].authorId
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
    
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
    // TODO: dirty code: set uid -> authorid, name -> author
    NSMutableDictionary* dic = self.detailDictionary;
    if (dic[@"uid"]) {
        [dic setObject:dic[@"uid"] forKey:@"authorid"];
    }
    if (dic[@"name"]) {
        [dic setObject:dic[@"name"] forKey:@"author"];
    }
    if (dic[@"from"]) {
        [dic setObject:dic[@"from"] forKey:@"location"];
    }
    self.userEntity = [OSCUserFullEntity entityWithDictionary:self.detailDictionary];
    [super parserDidEndDocument:parser];
}

@end
