//
//  SMStatusCell.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCTweetCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NimbusNetworkImage.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "UIImage+nimbusImageNamed.h"
#import "OSCTweetEntity.h"
#import "RCKeywordEntity.h"
#import "JLFullScreenPhotoBrowseView.h"
#import "OSCCommonRepliesListC.h"
#import "OSCTweetC.h"
//#import "RCUserHomepageC.h"

// 自定义链接协议
#define PROTOCOL_AT_SOMEONE @"atsomeone://"
#define PROTOCOL_SHARP_TREND @"sharptrend://"

// 布局字体
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:18.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define BUTTON_FONT_SIZE [UIFont systemFontOfSize:14.f]

// 本微博：字体 行高 文本色设置
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:18.f]
#define CONTENT_LINE_HEIGHT 24.f
#define CONTENT_TEXT_COLOR RGBCOLOR(30, 30, 30)

// 布局固定参数值
#define HEAD_IAMGE_HEIGHT 34
#define CONTENT_IMAGE_HEIGHT 160
#define BUTTON_SIZE CGSizeMake(65.f, 25.f)

@interface OSCTweetCell()<NIAttributedLabelDelegate>
// data entity
@property (nonatomic, strong) OSCTweetEntity* tweetEntity;
// content
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) NIAttributedLabel* contentLabel;
@property (nonatomic, strong) NINetworkImageView* contentImageView;
// action buttons
@property (nonatomic, strong) UIButton* commentBtn;
@end

@implementation OSCTweetCell

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)addAllLinksInContentLabel:(NIAttributedLabel*)contentLabel
                       withStatus:(OSCTweetEntity*)o
                     fromLocation:(NSInteger)location
{
    RCKeywordEntity* keyworkEntity = nil;
    NSString* url = nil;
    if (o.atPersonRanges.count) {
        for (int i = 0; i < o.atPersonRanges.count; i++) {
            keyworkEntity = (RCKeywordEntity*)o.atPersonRanges[i];
            url =[NSString stringWithFormat:@"%@%@", PROTOCOL_AT_SOMEONE, [keyworkEntity.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(keyworkEntity.range.location + location, keyworkEntity.range.length)];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)insertAllEmotionsInContentLabel:(NIAttributedLabel*)contentLabel
                             withStatus:(OSCTweetEntity*)o
{
    RCKeywordEntity* keyworkEntity = nil;
    if (o.emotionRanges.count) {
        NSString* emotionImageName = nil;
        // replace emotion from nail to head, so range's location is right. it's very important, good idea!
        for (int i = 0; i < o.emotionRanges.count; i++) {
            keyworkEntity = (RCKeywordEntity*)o.emotionRanges[i];
            if (i < o.emotionImageNames.count) {
                emotionImageName = o.emotionImageNames[i];
                if (emotionImageName.length) {
                    [contentLabel insertImage:[UIImage nimbusImageNamed:emotionImageName]
                                      atIndex:keyworkEntity.range.location];
                }
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)attributeHeightForEntity:(OSCTweetEntity*)o withWidth:(CGFloat)width
{
    // only alloc one time,reuse it, optimize best
    static NIAttributedLabel* contentLabel = nil;
    
    if (!contentLabel) {
        contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = CONTENT_FONT_SIZE;
        contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        contentLabel.width = width;
    }
    else {
        // reuse contentLabel and reset frame, it's great idea from my mind
        contentLabel.frame = CGRectZero;
        contentLabel.width = width;
    }
    
    contentLabel.text = o.body;
    [OSCTweetCell insertAllEmotionsInContentLabel:contentLabel withStatus:o];
    //[contentLabel sizeToFit];
    CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    if (contentSize.height < CONTENT_LINE_HEIGHT) {
        contentSize.height = CONTENT_LINE_HEIGHT;
    }
    return contentSize.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[OSCTweetEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_4;
        CGFloat contentViewMarin = CELL_PADDING_6;
        CGFloat sideMargin = cellMargin + contentViewMarin;

        CGFloat height = sideMargin;
        
        // head image
        height = height + HEAD_IAMGE_HEIGHT;
        height = height + CELL_PADDING_10;
        
        // content
        OSCTweetEntity* o = (OSCTweetEntity*)object;
        CGFloat kContentLength = tableView.width - sideMargin * 2;
        
#if 0// sizeWithFont
        CGSize contentSize = [o.text sizeWithFont:CONTENT_FONT_SIZE
                                constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height;
#else// sizeToFit
        height = height + [self attributeHeightForEntity:o withWidth:kContentLength];
#endif
        
        // content image
        if (o.smallImageUrl.length) {
            height = height + CELL_PADDING_10;
            height = height + CONTENT_IMAGE_HEIGHT;
        }
        
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
        
        // head image
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                             HEAD_IAMGE_HEIGHT)];
        [self.contentView addSubview:self.headView];
        
        // name
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // source from & date
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // status content
        self.contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = CONTENT_FONT_SIZE;
        self.contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        self.contentLabel.textColor = CONTENT_TEXT_COLOR;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.autoDetectLinks = YES;
        self.contentLabel.delegate = self;
        self.contentLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        self.contentLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        [self.contentView addSubview:self.contentLabel];
        
        // content image
        self.contentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.contentView addSubview:self.contentImageView];
        
        // content image gesture
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapContentImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(showContentOriginImage)];
        [self.contentImageView addGestureRecognizer:tapContentImageGesture];
        
        // border style
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        // bg color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.headView.image) {
        [self.headView setImage:nil];
    }
    if (self.contentImageView.image) {
        [self.contentImageView setImage:nil];
    }
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
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);

    
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // name
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      self.width - sideMargin * 2 - (self.headView.right + CELL_PADDING_10),
                                      self.textLabel.font.lineHeight);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom,
                                            self.width - sideMargin * 2 - self.textLabel.left,
                                            self.detailTextLabel.font.lineHeight);
    
    // status content
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;
    self.contentLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_10,
                                         kContentLength, 0.f);
    [self.contentLabel sizeToFit];
    
#if 0// close debug log
    CGSize contentSize = [self.contentLabel.text sizeWithFont:CONTENT_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"sizeWithFont height = %f", contentSize.height);
    NSLog(@"sizeToFit height    = %f", self.contentLabel.height);
#endif
    
    // content image
    self.contentImageView.left = self.contentLabel.left;
    self.contentImageView.top = self.contentLabel.bottom + CELL_PADDING_10;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // layout buttons
    self.commentBtn.right = self.contentView.width;// - contentViewMarin * 2;
    self.commentBtn.top = contentViewMarin * 2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[OSCTweetEntity class]]) {
        OSCTweetEntity* o = (OSCTweetEntity*)object;
        self.tweetEntity = o;
        if (o.user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:o.user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        
        self.textLabel.text = o.user.authorName;
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                     [o.createdAtDate formatRelativeTime]];// 解决动态计算时间
        if (o.repliesCount > 0) {
            [self.commentBtn setTitle:[NSString stringWithFormat:@"回复%ld", o.repliesCount]
                             forState:UIControlStateNormal];
        }
        else {
            [self.commentBtn setTitle:[NSString stringWithFormat:@"回复"]
                             forState:UIControlStateNormal];
        }

        self.contentLabel.text = o.body;
        
        [OSCTweetCell addAllLinksInContentLabel:self.contentLabel withStatus:o fromLocation:0];
        [OSCTweetCell insertAllEmotionsInContentLabel:self.contentLabel withStatus:o];
        
        if (o.smallImageUrl.length) {
            self.contentImageView.hidden = NO;
            self.contentImageView.scaleOptions |= NINetworkImageViewScaleToFitCropsExcess;
            [self.contentImageView setPathToNetworkImage:o.smallImageUrl contentMode:UIViewContentModeScaleAspectFit];
            self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            self.contentImageView.hidden = YES;
            [self.contentImageView setPathToNetworkImage:nil];
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [OSCGlobalConfig HUDShowMessage:self.tweetEntity.user.authorName
                       addedToView:[UIApplication sharedApplication].keyWindow];
//    if (superviewC) {
//        RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.tweetEntity.user.loginId];
//        [superviewC.navigationController pushViewController:c animated:YES];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)commentAction
{
    // if logined, and do reply action
    if (0 == self.tweetEntity.repliesCount) {
        UIViewController* superviewC = self.viewController;
        if ([OSCGlobalConfig loginedUserEntity]) {
            if ([superviewC isKindOfClass:[OSCTweetC class]]) {
                OSCTweetC* tweetC = (OSCTweetC*)superviewC;
                [tweetC showReplyAsInputAccessoryViewWithTweetId:self.tweetEntity.tweetId];
            }
        }
        else {
            [OSCGlobalConfig showLoginControllerFromNavigationController:superviewC.navigationController];
        }
    }
    else {
        [self showRepliesListView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showRepliesListView
{
    UIViewController* superviewC = self.viewController;
    OSCCommonRepliesListC* c = [[OSCCommonRepliesListC alloc] initWithTopicId:self.tweetEntity.tweetId
                                                                    topicType:OSCContentType_Tweet];
    [superviewC.navigationController pushViewController:c animated:YES];
    
    // table header view with body
    // TODO: new class OSCTweetBodyView
    OSCTweetCell* bodyCell = [[OSCTweetCell alloc] initWithFrame:self.bounds];
    [bodyCell shouldUpdateCellWithObject:self.tweetEntity];
    CGFloat height = [OSCTweetCell heightForObject:self.tweetEntity atIndexPath:nil tableView:c.tableView];
    bodyCell.height = height;
    c.tableView.tableHeaderView = bodyCell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showContentOriginImage
{
    if (self.viewController) {
        if ([self.viewController isKindOfClass:[UITableViewController class]]) {
            UITableView* tableView = ((UITableViewController*)self.viewController).tableView;
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            // convert rect to self(cell)
            CGRect rectInCell = [self.contentView convertRect:self.contentImageView.frame toView:self];
            
            // convert rect to tableview
            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
            
            // convert rect to window
            CGRect rectInWindow = [tableView convertRect:rectInTableView toView:window];
            
            // show photo full screen
            UIImage* image = self.contentImageView.image;
            if (image) {
                rectInWindow = CGRectMake(rectInWindow.origin.x + (rectInWindow.size.width - image.size.width) / 2.f,
                                          rectInWindow.origin.y + (rectInWindow.size.height - image.size.height) / 2.f,
                                          image.size.width, image.size.height);
            }
            JLFullScreenPhotoBrowseView* browseView =
            [[JLFullScreenPhotoBrowseView alloc] initWithUrlPath:self.tweetEntity.bigImageUrl
                                                       thumbnail:self.contentImageView.image
                                                        fromRect:rectInWindow];
            [window addSubview:browseView];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_commentBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_commentBtn setBackgroundColor:TABLE_VIEW_BG_COLOR];
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        _commentBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _commentBtn.layer.borderWidth = 1.0f;
    }
    return _commentBtn;
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
            [OSCGlobalConfig HUDShowMessage:someone
                               addedToView:[UIApplication sharedApplication].keyWindow];
            if (superviewC) {
//                RCUserHomepageC* c = [[RCUserHomepageC alloc] initWithUserLoginId:self.tweetEntity.lastRepliedUser.loginId];
//                [superviewC.navigationController pushViewController:c animated:YES];
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
