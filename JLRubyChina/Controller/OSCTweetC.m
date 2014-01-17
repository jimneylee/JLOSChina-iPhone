//
//  OSCTweetC.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetC.h"
#import "SDSegmentedControl.h"

#import "OSCTweetTimelineModel.h"
#import "OSCTweetEntity.h"
#import "OSCCommonDetailC.h"
#import "OSCQuickReplyC.h"
#import "OSCCommonRepliesListC.h"
#import "OSCTweetCell.h"
#import "OSCTweetPostC.h"

@interface OSCTweetC ()<RCQuickReplyDelegate>

@property (nonatomic, strong) SDSegmentedControl *segmentedControl;
@property (nonatomic, strong) OSCQuickReplyC* quickReplyC;

@end

@implementation OSCTweetC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"社区动弹";
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:
         [OSCGlobalConfig createRefreshBarButtonItemWithTarget:self
                                                        action:@selector(autoPullDownRefreshActionAnimation)],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                       target:self action:@selector(postNewTweetAction)],
         nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginNotification)
                                                     name:DID_LOGIN_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostNewTweetNotification)
                                                     name:DID_POST_NEW_TWEET_SUCCESS_NOTIFICATION object:nil];
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
    ((OSCTweetTimelineModel*)self.model).tweetType = self.segmentedControl.selectedSegmentIndex;
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
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showReplyAsInputAccessoryViewWithTweetId:(unsigned long)tweetId
{
    if (![self.quickReplyC.textView.internalTextView isFirstResponder]) {
        self.quickReplyC.topicId = tweetId;
        self.quickReplyC.catalogType = OSCCatalogType_Tweet;
        // each time addSubview to keyWidow, otherwise keyborad is not showed, sorry, so dirty!
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
        self.quickReplyC.textView.internalTextView.inputAccessoryView = self.quickReplyC.view;
        
        // call becomeFirstResponder twice, I donot know why, feel so bad!
        // maybe because textview is in superview(self.quickReplyC.view)
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
    }
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
    
    NSArray* sectionNames = @[@"最新动弹", @"热门动弹", @"我的动弹"];
    for (int i = 0; i < sectionNames.count; i++) {
        [self.segmentedControl insertSegmentWithTitle:sectionNames[i]
                                              atIndex:i
                                             animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)segmentedDidChange
{
    if (OSCTweetType_Mine == self.segmentedControl.selectedSegmentIndex
        && ![OSCGlobalConfig loginedUserEntity]) {
        [OSCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
    }
    else {
        // first cancel request operation
        [self.model cancelRequstOperation];
        
        // scroll top
        ((OSCTweetTimelineModel*)self.model).tweetType = self.segmentedControl.selectedSegmentIndex;
        
        // TODO:remove all, sometime crash, fix later on
        //    if (self.model.sections.count > 0) {
        //        [self.model removeSectionAtIndex:0];
        //    }
        
        // after scrollToTopAnimated then pull down to refresh, performce perfect
        [self scrollToTopAnimated:NO];
        [self performSelector:@selector(autoPullDownRefreshActionAnimation) withObject:self afterDelay:0.1f];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, 0.f,
                                                   self.tableView.width, self.tableView.height)
                               animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (OSCQuickReplyC*)quickReplyC
{
    if (!_quickReplyC) {
        _quickReplyC = [[OSCQuickReplyC alloc] init];
        _quickReplyC.replyDelegate = self;
        // setting the first responder view of the table but we don't know its type (cell/header/footer)
        // [self.view addSubview:_quickReplyC.view];
        // so mush show it in keywindow, same to keyborad :)
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
    }
    return _quickReplyC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewTweetAction
{
    OSCTweetPostC* postC = [[OSCTweetPostC alloc] init];
    [self.navigationController pushViewController:postC animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popDownReplyView
{
    if (self.quickReplyC.textView.isFirstResponder) {
        [self.quickReplyC.textView resignFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCTweetTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if ([object isKindOfClass:[OSCTweetEntity class]]) {
            OSCTweetEntity* entity = (OSCTweetEntity*)object;
            if (entity.tweetId > 0) {
                OSCCommonRepliesListC* c = [[OSCCommonRepliesListC alloc] initWithTopicId:entity.tweetId
                                                                                topicType:OSCContentType_Tweet];
                [self.navigationController pushViewController:c animated:YES];
                // table header view with body
                // TODO: new class OSCTweetBodyView
                OSCTweetCell* bodyCell = [[OSCTweetCell alloc] initWithFrame:self.view.bounds];
                [bodyCell shouldUpdateCellWithObject:entity];
                CGFloat height = [OSCTweetCell heightForObject:entity atIndexPath:nil tableView:c.tableView];
                bodyCell.height = height;
                c.tableView.tableHeaderView = bodyCell;
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
#pragma mark - Login/Logout Notification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLoginNotification
{
    if (OSCTweetType_Mine == self.segmentedControl.selectedSegmentIndex
        && ![OSCGlobalConfig loginedUserEntity]) {
        // TODO:remove all, sometime crash, fix later on
        //    if (self.model.sections.count > 0) {
        //        [self.model removeSectionAtIndex:0];
        //    }
        [OSCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLogoutNotification
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - New Tweet Notification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPostNewTweetNotification
{
    if (OSCTweetType_Latest == ((OSCTweetTimelineModel*)self.model).tweetType
        || OSCTweetType_Mine ==  ((OSCTweetTimelineModel*)self.model).tweetType) {
        [self scrollToTopAnimated:NO];
        [self performSelector:@selector(autoPullDownRefreshActionAnimation) withObject:self afterDelay:0.1f];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self popDownReplyView];
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RCQuickReplyDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplySuccessWithMyReply:(OSCReplyEntity*)replyEntity
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (replyEntity) {
        // nothing to do
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyFailure
{
    // nothing to do
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyCancel
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
