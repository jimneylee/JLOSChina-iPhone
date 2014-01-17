//
//  OSCQuAnC.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCForumC.h"
#import "SDSegmentedControl.h"

#import "OSCForumTimelineModel.h"
#import "OSCCommonEntity.h"
#import "OSCCommonDetailC.h"

@interface OSCForumC ()

@property (nonatomic, assign) OSCForumTopicType topicType;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;

@end

@implementation OSCForumC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"社区问答";
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
    
    [self initSegmentedControl];
    ((OSCForumTimelineModel*)self.model).topicType = self.segmentedControl.selectedSegmentIndex;
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
- (void)initSegmentedControl
{
    if (!_segmentedControl) {
        // TODO: pull request to author fix this bug: initWithFrame can not call [self commonInit]
        _segmentedControl = [[SDSegmentedControl alloc] init];
        _segmentedControl.frame = CGRectMake(0.f, 0.f, self.view.width, _segmentedControl.height);
        _segmentedControl.interItemSpace = 0.f;
        [_segmentedControl addTarget:self action:@selector(segmentedDidChange)
                    forControlEvents:UIControlEventValueChanged];
    }
    
    NSArray* sectionNames = @[@"问答互动", @"技术分享", @"灌水综合", @"职业规划", @"站务反馈"];
    for (int i = 0; i < sectionNames.count; i++) {
        [self.segmentedControl insertSegmentWithTitle:sectionNames[i]
                                              atIndex:i
                                             animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)segmentedDidChange
{
    // first cancel request operation
    [self.model cancelRequstOperation];
    
    ((OSCForumTimelineModel*)self.model).topicType = self.segmentedControl.selectedSegmentIndex;
    
    // remove all, sometime crash, fix later on
    //    if (self.model.sections.count > 0) {
    //        [self.model removeSectionAtIndex:0];
    //    }
    
    // after scrollToTopAnimated then pull down to refresh, performce perfect
    [self scrollToTopAnimated:NO];
    [self performSelector:@selector(autoPullDownRefreshActionAnimation) withObject:self afterDelay:0.1f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, 0.f,
                                                   self.tableView.width, self.tableView.height)
                               animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCForumTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if ([object isKindOfClass:[OSCCommonEntity class]]) {
            OSCCommonEntity* entity = (OSCCommonEntity*)object;
            if (entity.newsId > 0) {
                OSCCommonDetailC* c = [[OSCCommonDetailC alloc] initWithTopicId:entity.newsId
                                                                  topicType:OSCContentType_Forum];
                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                [OSCGlobalConfig HUDShowMessage:@"不存在或已被删除！" addedToView:self.view];
            }
        }
        return YES;
    };
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentedControl;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat kDefaultSegemetedControlHeight = 43.f;// see: SDSegmentedControl commonInit
    return kDefaultSegemetedControlHeight;
}

@end
