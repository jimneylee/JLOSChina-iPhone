//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseModel.h"
#import "OSCAPIClient.h"
#import "NSDataAdditions.h"

@interface OSCBaseModel()

@property (nonatomic, copy) NSString* itemElementName;//TODO: itemElementNames array
@property (nonatomic, copy) NSString* superElementName;
@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
@property (nonatomic, strong) NSMutableString* tmpInnerElementText;//mutable must retain->www.stackoverflow.com/questions/3686341/nsmutablestring-appendstring-generates-a-sigabrt

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCBaseModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementName = nil;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)generateParameters
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postParams:(NSDictionary*)params errorBlock:(void(^)(OSCErrorEntity* errorEntity))errorBlock
{
    NSString* path = [self relativePath];
    OSCAPIClient *httpClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    [httpClient postPath:path parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSXMLParser class]]) {
                                         NSXMLParser* parser = (NSXMLParser*)responseObject;
                                         [parser setShouldProcessNamespaces:YES];
                                         parser.delegate = self;
                                         [parser parse];
                                     }
                                     else {
                                         if (errorBlock) {
                                             OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                                             errorBlock(errorEntity);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (errorBlock) {
                                         OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                                         errorBlock(errorEntity);
                                     }
                                 }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getParams:(NSDictionary*)params errorBlock:(void(^)(OSCErrorEntity* errorEntity))errorBlock
{
    NSString* path = [self relativePath];
    OSCAPIClient *httpClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    [httpClient getPath:path parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if ([responseObject isKindOfClass:[NSXMLParser class]]) {
                         NSXMLParser* parser = (NSXMLParser*)responseObject;
                         [parser setShouldProcessNamespaces:YES];
                         parser.delegate = self;
                         [parser parse];
                     }
                     else {
                         if (errorBlock) {
                             OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                             errorBlock(errorEntity);
                         }
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (errorBlock) {
                         OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                         errorBlock(errorEntity);
                     }
                 }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataDictionary
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    // check current start element if is one of itemElementNamesArray
    BOOL isEntityElement = NO;
    for (NSString* name in self.itemElementNamesArray) {
        if ([elementName isEqualToString:name]) {
            isEntityElement = YES;
        }
    }
    if (isEntityElement) {
        self.itemElementName = elementName;
    }
    
    // set super element and create dic
    if ([elementName isEqualToString:self.itemElementName]
        || [elementName isEqualToString:XML_RESULT]
        || [elementName isEqualToString:XML_NOTICE]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
        self.superElementName = elementName;
    }
    
    // tmptext to store value in <e>value</e>
    if ([self.superElementName isEqualToString:self.itemElementName]
        || [self.superElementName isEqualToString:XML_RESULT]
        || [self.superElementName isEqualToString:XML_NOTICE]) {
        self.tmpInnerElementText = [[NSMutableString alloc] init];;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (self.tmpInnerElementText) {
        [self.tmpInnerElementText appendString:string];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // item
    if ([elementName isEqualToString:self.itemElementName]) {
        if (!self.dataDictionary) {
            self.dataDictionary = [NSMutableDictionary dictionary];
        }
        [self.dataDictionary setObject:self.currentDictionary forKey:self.itemElementName];
        self.currentDictionary = nil;
        self.superElementName = nil;
    }
    // get result error
    else if ([elementName isEqualToString:XML_RESULT]) {
        self.errorEntity = [OSCErrorEntity entityWithDictionary:self.currentDictionary];
        self.currentDictionary = nil;
        self.superElementName = nil;
    }
    // get notice
    else if ([elementName isEqualToString:XML_NOTICE]) {
        self.noticeEntiy = [OSCNoticeEntity entityWithDictionary:self.currentDictionary];
        self.currentDictionary = nil;
        self.superElementName = nil;
    }
    // set objects to item's dictionary
    else if ([self.superElementName isEqualToString:self.itemElementName]
        || [self.superElementName isEqualToString:XML_RESULT]
        || [self.superElementName isEqualToString:XML_NOTICE]) {
        if (self.currentDictionary && self.tmpInnerElementText) {
            [self.currentDictionary setObject:self.tmpInnerElementText forKey:elementName];
        }
    }
    
    self.tmpInnerElementText = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // TODO: switch code value:
    if (ERROR_CODE_SUCCESS == self.errorEntity.errorCode) {
        [self parseDataDictionary];
        [self didFinishLoad];
    }
    else {
        [self didFailLoad];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self didFailLoad];
}

@end
