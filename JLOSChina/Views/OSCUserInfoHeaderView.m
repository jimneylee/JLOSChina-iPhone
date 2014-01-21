//
//  RCReplyCell.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCUserInfoHeaderView.h"
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

@interface OSCUserInfoHeaderView()
@property (nonatomic, strong) OSCUserFullEntity* user;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* locationLabel;
@property (nonatomic, strong) UILabel* tagLineLabel;
@property (nonatomic, strong) NINetworkImageView* headView;

@property (nonatomic, strong) UIButton* detailBtn;
@property (nonatomic, strong) UIButton* favoriteBtn;
@property (nonatomic, strong) UIButton* followersBtn;
@property (nonatomic, strong) UIButton* fansBtn;
@end

@implementation OSCUserInfoHeaderView

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
        UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        locationLabel.font = LOGIN_ID_FONT_SIZE;
        locationLabel.textColor = [UIColor blackColor];
        [contentView addSubview:locationLabel];
        self.locationLabel = locationLabel;
        
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
        self.locationLabel.backgroundColor = [UIColor clearColor];
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
    self.locationLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + CELL_PADDING_4,
                                         topWidth, self.locationLabel.font.lineHeight);
    
    // introduce
    self.tagLineLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                         kContentMaxWidth, self.tagLineLabel.font.lineHeight);
    height = height + self.tagLineLabel.height + CELL_PADDING_4;
    
    // bottom margin
    height = height + sideMargin;
    
    // content view
    self.contentView.frame = CGRectMake(cellMargin, cellMargin, kContentMaxWidth, height - cellMargin * 2);
    
    // self height
    self.height = height;
    
    // detail btn
    self.detailBtn.right = self.contentView.width;
    self.detailBtn.centerY = self.contentView.height / 2;
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
        self.locationLabel.text = user.location;
        self.tagLineLabel.text = @"TODO:api接口还未添加签名字段";//[NSString stringWithFormat:@"签名：%@", user.tagline.length ? user.tagline : @"这个人很懒，啥也没写"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

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
        [_detailBtn setTitle:@"详细资料" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_detailBtn setBackgroundColor:TABLE_VIEW_BG_COLOR];
        [_detailBtn addTarget:self action:@selector(showDetailAction)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailBtn];
        _detailBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _detailBtn.layer.borderWidth = 1.0f;
    }
    return _detailBtn;
}

@end
