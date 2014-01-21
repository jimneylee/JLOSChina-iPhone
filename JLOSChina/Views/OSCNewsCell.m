//
//  SMStatusCell.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCNewsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NimbusNetworkImage.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "UIImage+nimbusImageNamed.h"
#import "OSCCommonEntity.h"
//#import "RCForumTopicsC.h"
#import "OSCUserHomeC.h"

#define TITLE_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define CREATED_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define REPLIES_COUNT_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define HEAD_IAMGE_HEIGHT 34

@interface OSCNewsCell()<NIAttributedLabelDelegate>
@property (nonatomic, strong) OSCCommonEntity* topicEntity;
@property (nonatomic, strong) UILabel* repliesCountLabel;
@property (nonatomic, strong) NIAttributedLabel* createdLabel;
@end

@implementation OSCNewsCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[OSCCommonEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_4;
        CGFloat contentViewMarin = CELL_PADDING_6;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        CGFloat height = sideMargin;
        
        OSCCommonEntity* o = (OSCCommonEntity*)object;
        
        CGFloat kTitleLength = tableView.width -  sideMargin * 2;
#if 1
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:o.title
                                        attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){kTitleLength, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize titleSize = rect.size;
#else
        CGSize titleSize = [o.topicTitle sizeWithFont:TITLE_FONT_SIZE
                                    constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
#endif
        height = height + titleSize.height;

        height = height + CELL_PADDING_4;
        height = height + CREATED_FONT_SIZE.lineHeight;
        
        height = height + sideMargin;
        
        return height;
    }
    
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // topic title
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
        
        // replies count
        self.repliesCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.repliesCountLabel.font = REPLIES_COUNT_FONT_SIZE;
        self.repliesCountLabel.textColor = [UIColor whiteColor];
        self.repliesCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.repliesCountLabel];
        
        // topic title
        self.createdLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.createdLabel.font = CREATED_FONT_SIZE;
        self.createdLabel.textColor = [UIColor grayColor];
        self.createdLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.createdLabel.autoDetectLinks = YES;
        self.createdLabel.delegate = self;
        self.createdLabel.attributesForLinks =
        @{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.createdLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.contentView addSubview:self.createdLabel];
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        // bg color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.repliesCountLabel.backgroundColor = RGBCOLOR(27, 128, 219);//[UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.createdLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IOS_IS_AT_LEAST_7) {
    }
    else {
        // set here compatible with ios6.x
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    // layout
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_6;
    //CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    // replies count
    CGSize repliesCountSize = CGSizeZero;
    if (IOS_IS_AT_LEAST_7) {
        repliesCountSize = [self.repliesCountLabel.text sizeWithAttributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    }
    else {
        repliesCountSize = [self.repliesCountLabel.text sizeWithFont:TITLE_FONT_SIZE];
    }
    self.repliesCountLabel.frame = CGRectMake(0.f, 0.f,
                                              repliesCountSize.width + CELL_PADDING_6,
                                              self.repliesCountLabel.font.lineHeight);
    self.repliesCountLabel.right = self.contentView.width - contentViewMarin;
    self.repliesCountLabel.bottom = self.contentView.height - contentViewMarin;
    // title
    CGFloat kTitleLength = self.contentView.width - contentViewMarin * 2;
#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.textLabel.text
                                    attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kTitleLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize titleSize = rect.size;
#else
    CGSize titleSize = [self.topicTitleLabel.text sizeWithFont:TITLE_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kTitleLength, FLT_MAX)];
#endif
    self.textLabel.frame = CGRectMake(contentViewMarin, contentViewMarin,
                                        kTitleLength, titleSize.height);
    
    self.createdLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom + CELL_PADDING_4,
                                             self.textLabel.width, 0.f);
    [self.createdLabel sizeToFit];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[OSCCommonEntity class]]) {
        OSCCommonEntity* o = (OSCCommonEntity*)object;
        self.topicEntity = o;
        self.repliesCountLabel.text = [NSString stringWithFormat:@"%lu", o.repliesCount];
        self.textLabel.text = o.title;

        self.createdLabel.text = [NSString stringWithFormat:@"%@发表于%@",
                                          o.user.authorName, [o.createdAtDate formatRelativeTime]];
        NSString* atSomeoneUrl = [NSString stringWithFormat:@"%@%@",
                                      PROTOCOL_AT_SOMEONE, [o.user.authorName urlEncoded]];
        [self.createdLabel addLink:[NSURL URLWithString:atSomeoneUrl]
                                 range:NSMakeRange(0, o.user.authorName.length)];
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [OSCGlobalConfig HUDShowMessage:self.topicEntity.user.authorName
                       addedToView:[UIApplication sharedApplication].keyWindow];
    if (superviewC) {
        OSCUserHomeC* c = [[OSCUserHomeC alloc] initWithUserId:self.topicEntity.user.authorId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIAttributedLabelDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point {
    NSURL* url = nil;
    if (NSTextCheckingTypePhoneNumber == result.resultType) {
        url = [NSURL URLWithString:[@"tel://" stringByAppendingString:result.phoneNumber]];
        
    } else if (NSTextCheckingTypeLink == result.resultType) {
        url = result.URL;
    }
    
    if (nil != url) {
        UIViewController* superviewC = self.viewController;
        if ([url.absoluteString hasPrefix:PROTOCOL_AT_SOMEONE]) {
            NSString* someone = [url.absoluteString substringFromIndex:PROTOCOL_AT_SOMEONE.length];
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [OSCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"%@，暂时接口不支持", someone]
                               addedToView:[UIApplication sharedApplication].keyWindow];
            if (superviewC) {
                //TODO:
                //OSCUserHomeC* c = [[OSCUserHomeC alloc] initWithUsername:someone];
                //[superviewC.navigationController pushViewController:c animated:YES];
            }
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_NODE]) {
            NSString* somenode = [url.absoluteString substringFromIndex:PROTOCOL_NODE.length];
            somenode = [somenode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            if (superviewC) {
                if ([superviewC.title isEqualToString:somenode]) {
                    [OSCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"Already in %@", somenode]
                                       addedToView:[UIApplication sharedApplication].keyWindow];
                }
                else {
                    [OSCGlobalConfig HUDShowMessage:[NSString stringWithFormat:@"Go to %@", somenode]
                                       addedToView:[UIApplication sharedApplication].keyWindow];
//                    RCForumTopicsC* topicsC = [[RCForumTopicsC alloc] initWithNodeName:self.topicEntity.nodeName
//                                                                          nodeId:self.topicEntity.nodeId];
//                    [superviewC.navigationController pushViewController:topicsC animated:YES];
                }
            }
        }
        else {
            if (superviewC) {
                NIWebController* webC = [[NIWebController alloc] initWithURL:url];
                [superviewC.navigationController pushViewController:webC animated:YES];
            }
        }
    }
    else {
        [OSCGlobalConfig HUDShowMessage:@"抱歉，这是无效的链接" addedToView:self.viewController.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel
shouldPresentActionSheet:(UIActionSheet *)actionSheet
 withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    return NO;
}

@end
