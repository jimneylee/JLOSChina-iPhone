//
//  RCForumTopicsC.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserHomeC.h"

#import "OSCUserActiveTimelineModel.h"
#import "OSCCommonEntity.h"
#import "OSCCommonDetailC.h"
#import "OSCUserInfoHeaderView.h"

@interface OSCUserHomeC ()

@property (nonatomic, assign) OSCContentType contentType;
@property (nonatomic, strong) OSCUserInfoHeaderView* homepageHeaderView;

@end

@implementation OSCUserHomeC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserId:(unsigned long)userId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        ((OSCUserActiveTimelineModel*)self.model).userId = userId;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 暂时无用
- (id)initWithUsername:(NSString*)username
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        ((OSCUserActiveTimelineModel*)self.model).username = username;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"他(她)的主页";
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:
         [OSCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                       action:@selector(autoPullDownRefreshActionAnimation)],
         nil];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTopicHeaderViewWithUserEntity:(OSCUserFullEntity*)userEntity
{
    if (!_homepageHeaderView) {
        _homepageHeaderView = [[OSCUserInfoHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
    }
    [self.homepageHeaderView updateViewForUser:userEntity];
    // call layoutSubviews at first to calculte view's height, dif from setNeedsLayout
    [self.homepageHeaderView layoutIfNeeded];
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.homepageHeaderView;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCUserActiveTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if ([object isKindOfClass:[OSCCommonEntity class]]) {
            OSCCommonEntity* entity = (OSCCommonEntity*)object;
            if (entity.newsId > 0) {
                [OSCGlobalConfig HUDShowMessage:@"TODO it!" addedToView:self.view];
//                OSCCommonDetailC* c = [[OSCCommonDetailC alloc] initWithTopicId:entity.newsId
//                                                                  topicType:self.segmentedControl.selectedSegmentIndex];
//                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                [OSCGlobalConfig HUDShowMessage:@"帖子不存在或已被删除！" addedToView:self.view];
            }
        }
        return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadData
{
    [super didFinishLoadData];
    [self updateTopicHeaderViewWithUserEntity:((OSCUserActiveTimelineModel*)self.model).userEntity];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    [super didFailLoadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"信息为空";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    NSString* msg = @"抱歉，无法获取信息！";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    NSString* msg = @"已是最后一页";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = 20.f;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, tableHeaderHeight)];
    label.backgroundColor = TABLE_VIEW_BG_COLOR;
    label.textColor = [UIColor darkGrayColor];
    label.text = @"  最新活动";
    return label;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = 20.f;
    return tableHeaderHeight;
}

@end
