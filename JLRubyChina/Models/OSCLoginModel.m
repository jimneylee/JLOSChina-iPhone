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

@property (nonatomic, copy) NSString* itemElementName;
@property (nonatomic, copy) NSString* superElementName;
@property (nonatomic, strong) NSMutableDictionary *currentDictionary;
@property (nonatomic, strong) NSMutableString* tmpInnerElementText;//mutable must retain->www.stackoverflow.com/questions/3686341/nsmutablestring-appendstring-generates-a-sigabrt

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementName = XML_USER;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
                    block:(void(^)(OSCUserFullEntity* userEntity, OSCErrorEntity* errorEntity))block
{
    self.returnBlock = block;
    NSString* path = [OSCAPIClient relativePathForSignIn];
    
    OSCAPIClient *httpClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:@"1" forKey:@"keep_login"];
    self.accountEntity = [[OSCAccountEntity alloc] initWithUsername:username password:password];
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
                                             OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                                             block(nil, errorEntity);
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (block) {
                                         OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                                         block(nil, errorEntity);
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

    // item user
    if ([elementName isEqualToString:self.itemElementName]) {
        // TODO: dirty code: set uid -> authorid, name -> author
        if (self.currentDictionary[@"uid"]) {
            [self.currentDictionary setObject:self.currentDictionary[@"uid"] forKey:@"authorid"];
        }
        if (self.currentDictionary[@"name"]) {
            [self.currentDictionary setObject:self.currentDictionary[@"name"] forKey:@"author"];
        }
        self.userEntity = [OSCUserFullEntity entityWithDictionary:self.currentDictionary];
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
    if (ERROR_CODE_SUCCESS == self.errorEntity.errorCode) {
        [OSCAccountEntity storePassword:self.accountEntity.password
                            forUsername:self.accountEntity.username];
        if (self.returnBlock) {
            self.returnBlock(self.userEntity, self.errorEntity);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
}

@end
