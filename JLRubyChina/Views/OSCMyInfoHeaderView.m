//
//  RCReplyCell.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCMyInfoHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+nimbusImageNamed.h"
#import "UIView+findViewController.h"
#import "OSCUserFullEntity.h"

#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:22.f]
#define LOGIN_ID_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define TAG_LINE_ID_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define BUTTON_FONT_SIZE [UIFont boldSystemFontOfSize:15.f]

#define HEAD_IAMGE_HEIGHT 60
#define BUTTON_SIZE CGSizeMake(78.f, 40.f)//(104.f, 40.f)

@interface OSCMyInfoHeaderView()
@property (nonatomic, strong) OSCUserFullEntity* user;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* loginIdLabel;
@property (nonatomic, strong) UILabel* tagLineLabel;
@property (nonatomic, strong) NINetworkImageView* headView;

@property (nonatomic, strong) UIButton* detailBtn;
@property (nonatomic, strong) UIButton* favoriteBtn;
@property (nonatomic, strong) UIButton* followersBtn;
@property (nonatomic, strong) UIButton* fansBtn;
@end

@implementation OSCMyInfoHeaderView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // content
        UIView* contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        self.contentView = contentView;

        // head
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                                    HEAD_IAMGE_HEIGHT)];
        self.headView.initialImage = [UIImage nimbusImageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        
        // username
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = NAME_FONT_SIZE;
        nameLabel.textColor = [UIColor blackColor];
        [contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // login id
        UILabel* loginIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loginIdLabel.font = LOGIN_ID_FONT_SIZE;
        loginIdLabel.textColor = [UIColor blackColor];
        [contentView addSubview:loginIdLabel];
        self.loginIdLabel = loginIdLabel;
        
        // introduce
        UILabel* tagLineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tagLineLabel.font = TAG_LINE_ID_FONT_SIZE;
        tagLineLabel.textColor = [UIColor blackColor];
        [contentView addSubview:tagLineLabel];
        self.tagLineLabel = tagLineLabel;
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];//CELL_CONTENT_VIEW_BG_COLOR;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.loginIdLabel.backgroundColor = [UIColor clearColor];
        self.tagLineLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_10;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    CGFloat kContentMaxWidth = self.width - cellMargin * 2;
    
    CGFloat height = sideMargin;
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // head image
    height = height + HEAD_IAMGE_HEIGHT;
    
    // name
    CGFloat topWidth = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_10);
    self.nameLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      topWidth, self.nameLabel.font.lineHeight);
    
    // login id
    self.loginIdLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + CELL_PADDING_4,
                                            topWidth, self.loginIdLabel.font.lineHeight);
    
    // introduce
    self.tagLineLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                         kContentMaxWidth, self.tagLineLabel.font.lineHeight);
    height = height + self.tagLineLabel.height + CELL_PADDING_4;
    
    // bottom margin
    height = height + sideMargin;
    
    // botton height
    height = height + BUTTON_SIZE.height;
    
    // content view
    self.contentView.frame = CGRectMake(cellMargin, cellMargin, kContentMaxWidth, height - cellMargin * 2);
    
    // self height
    self.height = height;
    
    // button
    self.favoriteBtn.left = 0.f;
    self.favoriteBtn.bottom = self.contentView.height;
    self.followersBtn.left = self.favoriteBtn.right;
    self.followersBtn.bottom = self.favoriteBtn.bottom;
    self.fansBtn.left = self.followersBtn.right;
    self.fansBtn.bottom = self.followersBtn.bottom;
    self.detailBtn.left = self.fansBtn.right;
    self.detailBtn.bottom = self.fansBtn.bottom;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewForUser:(OSCUserFullEntity*)user
{
    if (user) {
        self.user = user;
        if (user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        self.nameLabel.text = user.authorName;
        self.loginIdLabel.text = user.location;
        self.tagLineLabel.text = @"TODO:api接口还未添加签名字段";//[NSString stringWithFormat:@"签名：%@", user.tagline.length ? user.tagline : @"这个人很懒，啥也没写"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showFavoritedTopicsAction
{
    UIViewController* superviewC = self.viewController;
    //    if (superviewC) {
    //        RCForumTopicsC* c = [[RCForumTopicsC alloc] initForFavoritedWithUserLoginId:self.user.loginId];
    //        [superviewC.navigationController pushViewController:c animated:YES];
    //    }
    // TODO:
    [OSCGlobalConfig HUDShowMessage:@"to do it!"
                        addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showFollowersAction
{
    UIViewController* superviewC = self.viewController;
//    if (superviewC) {
//        RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithUserLoginId:self.user.loginId];
//        [superviewC.navigationController pushViewController:c animated:YES];
//    }
    // TODO:
    [OSCGlobalConfig HUDShowMessage:@"to do it!"
                        addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showFansAction
{
    UIViewController* superviewC = self.viewController;
    //    if (superviewC) {
    //        RCForumTopicsC* c = [[RCForumTopicsC alloc] initWithUserLoginId:self.user.loginId];
    //        [superviewC.navigationController pushViewController:c animated:YES];
    //    }
    // TODO:
    [OSCGlobalConfig HUDShowMessage:@"to do it!"
                        addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDetailAction
{
    // TODO:
    [OSCGlobalConfig HUDShowMessage:@"to do it!"
                        addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View init

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                  BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_detailBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_detailBtn setTitle:@"详细" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_detailBtn addTarget:self action:@selector(showDetailAction)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailBtn];
        _detailBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _detailBtn.layer.borderWidth = 1.0f;
    }
    return _detailBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)favoriteBtn
{
    if (!_favoriteBtn) {
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_favoriteBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favoriteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_favoriteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_favoriteBtn addTarget:self action:@selector(showFavoritedTopicsAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favoriteBtn];
        _favoriteBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _favoriteBtn.layer.borderWidth = 1.0f;
    }
    return _favoriteBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)followersBtn
{
    if (!_followersBtn) {
        _followersBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                      BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_followersBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_followersBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_followersBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_followersBtn addTarget:self action:@selector(showFollowersAction)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followersBtn];
        _followersBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _followersBtn.layer.borderWidth = 1.0f;
    }
    return _followersBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)fansBtn
{
    if (!_fansBtn) {
        _fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                         BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_fansBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_fansBtn.titleLabel setTextColor:[UIColor grayColor]];
        [_fansBtn setTitle:@"粉丝" forState:UIControlStateNormal];
        [_fansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fansBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_fansBtn addTarget:self action:@selector(showFansAction)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_fansBtn];
        _fansBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _fansBtn.layer.borderWidth = 1.0f;
    }
    return _fansBtn;
}

@end
