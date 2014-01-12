//
//  NITimelineTableModel.m
//  NimbusTimeline
//
//  Created by Lee jimney on 7/27/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCBaseTableModel()

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCBaseTableModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {

	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)listKey
{
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)generateParameters
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)apiSharedClient
{
    return [OSCAPIClient sharedClient];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadDataWithBlock:(void(^)(NSArray* indexPaths, NSError *error))block
                     more:(BOOL)more refresh:(BOOL)refresh
{
    self.showIndexPathsBlock = block;
    if (self.isLoading) {
        return;
    }
    else {
        self.isLoading = YES;
    }
    if (more) {
        self.pageCounter++;
    }
    else {
        self.pageCounter = 0;//PAGE_START_INDEX;
    }
    NSString* relativePath = [self relativePath];
    if ([[self apiSharedClient] respondsToSelector:@selector(getPath:parameters:refresh:success:failure:)]) {
        [[self apiSharedClient] getPath:relativePath parameters:[self generateParameters]  refresh:refresh
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    self.isLoading = NO;
                                    if (!more) {
                                        if (self.sections.count > 0) {
                                            [self removeSectionAtIndex:0];
                                        }
                                    }
                                    if ([responseObject isKindOfClass:[NSXMLParser class]]) {
                                        NSXMLParser* parser = (NSXMLParser*)responseObject;
                                        [parser setShouldProcessNamespaces:YES];
                                        parser.delegate = self;
                                        [parser parse];
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    self.isLoading = NO;
                                    if (block) {
                                        block(nil, error);
                                    }
                                }];
    }
    else {
        NSLog(@"Error: can not find method (getPath:parameters:refresh:success:failure:)");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataToIndexPaths
{
    NSArray* entities = [self entitiesParsedFromResponseObject:self.listDataArray];
    NSArray* indexPaths = nil;
    if (entities.count) {
        indexPaths = [self addObjectsFromArray:entities];
    }
    else {
        // just set empty array, show empty data but no error
        indexPaths = [NSArray array];
    }
    if (self.showIndexPathsBlock) {
        self.showIndexPathsBlock(indexPaths, nil);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:self.listElementName]) {
        self.listDataArray = [NSMutableArray arrayWithCapacity:self.perpageCount];
        self.superElementName = self.listElementName;
    }
    else if ([elementName isEqualToString:self.itemElementName]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    else if ([self.superElementName isEqualToString:self.listElementName]) {
        self.tmpInnerElementText = [[NSMutableString alloc] init];;
    }
    // TODO:notice
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
    if ([elementName isEqualToString:self.superElementName]) {
        self.superElementName = nil;
    }
    else if ([self.superElementName isEqualToString:self.listElementName]) {
        
        // ultimize with element array, and for each parse
        if ([elementName isEqualToString:self.itemElementName]) {
            [self.listDataArray addObject:self.currentDictionary];
        }
        else {
            if (self.currentDictionary && self.tmpInnerElementText) {
                [self.currentDictionary setObject:self.tmpInnerElementText forKey:elementName];
            }
        }
    }
    if (self.tmpInnerElementText) {
        self.tmpInnerElementText = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"%@", self.listDataArray);
    [self parseDataToIndexPaths];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Paser Error = %@", parseError);
    NSError* error = [[NSError alloc] init];
    if (self.showIndexPathsBlock) {
        self.showIndexPathsBlock(nil, error);
    }
}

@end
