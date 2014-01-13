//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCLoginModel.h"
#import "OSCAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDataAdditions.h"

@interface OSCLoginModel()

@property (nonatomic, copy) NSString* superElementName;
@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
@property (nonatomic, strong) NSMutableString* tmpInnerElementText;//mutable must retain->www.stackoverflow.com/questions/3686341/nsmutablestring-appendstring-generates-a-sigabrt

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCAccountEntity* user, NSError *error))block
{
    NSString* path = [OSCAPIClient relativePathForSignIn];
    
    OSCAPIClient *httpClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:@"1" forKey:@"keep_login"];
    [httpClient postPath:path parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([responseObject isKindOfClass:[NSXMLParser class]]) {
                                         NSXMLParser* parser = (NSXMLParser*)responseObject;
                                         [parser setShouldProcessNamespaces:YES];
                                         parser.delegate = self;
                                         [parser parse];
                                     }
                                     else {
                                         if (block) {
                                             NSError* error = [[NSError alloc] init];
                                             block(nil, error);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (block) {
                                         block(nil, error);
                                     }
                                 }];
        }

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{    
    // TODO:news boday http://www.oschina.net/action/api/news_detail?id=47609
    if ([elementName isEqualToString:XML_USER]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
        self.superElementName = XML_USER;
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
    if ([self.superElementName isEqualToString:self.detailItemElementName]) {
        if (self.detailDictionary  && self.tmpInnerElementText) {
            [self.detailDictionary setObject:self.tmpInnerElementText forKey:elementName];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.topicDetailEntity = [OSCCommonDetailEntity entityWithDictionary:self.detailDictionary];
    [super parserDidEndDocument:parser];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [super parser:parser parseErrorOccurred:parseError];
}

@end
