//
//  RCTopicDetailEntity.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCNewsDetailEntity.h"
#import "RCRegularParser.h"
#import "NSString+Emojize.h"
#import "NSAttributedStringMarkdownParser.h"
#import "MarkdownSyntaxGenerator.h"

@implementation OSCNewsDetailEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.body = dic[XML_BODY];
        self.attributedBody = [[NSAttributedString alloc] initWithString:self.body];
        [self parseAllKeywords];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic.count || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCNewsDetailEntity* entity = [[OSCNewsDetailEntity alloc] initWithDictionary:dic];
    return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share话题 标签
- (void)parseAllKeywords
{
    if (self.body.length) {
        NSString* trimedString = self.body;
        self.imageUrlsArray = [RCRegularParser imageUrlsInString:self.body trimedString:&trimedString];
        self.body = trimedString;
        
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.body];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// idea from MarkdownSyntaxEditor/MarkdownTextView, not perfect but better than before
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:18.f]
- (NSAttributedString*)parseAttributedStringFromMarkdownString:(NSString*)markdownString
{
    if (markdownString.length) {
        MarkdownSyntaxGenerator* parser = [[MarkdownSyntaxGenerator alloc] init];
        NSArray *models = [parser syntaxModelsForText:markdownString];
        // set default font
        NSDictionary* defaultAttributes = @{NSFontAttributeName : CONTENT_FONT_SIZE};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.body
                                                                                             attributes:defaultAttributes];
        // set line height
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.minimumLineHeight = 21.f;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, attributedString.length)];
        for (MarkdownSyntaxModel *model in models) {
            [attributedString addAttributes:AttributesFromMarkdownSyntaxType(model.type) range:model.range];
        }
        return attributedString;
    }
    return nil;
}

@end
