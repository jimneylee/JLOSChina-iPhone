//
//  SMMBlogPostC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetPostC.h"
#import "TTGlobalUICommon.h"
#import "UIImage+Resizing.h"
#import "UIImage+FixOrientation.h"
#import "JLNetworkSpy.h"
#import "MTStatusBarOverlay.h"
#import "OSCFriendEntity.h"
#import "OSCTweetPostModel.h"

@interface OSCTweetPostC ()
{
    UITextView* _statusesTextView;
    UIButton* _textCountBtn;
    UIButton* _clearTextBtn;
    UIImageView* _inputBackgroundImageView;
    OSCPostButtonBar* _postBtnBar;
    OSCEmotionMainView* _emotionMainView;
    OSCFriendsC* _friendsC;
    UIImagePickerController* _picker;
    
    OSCTweetPostModel* _postModel;
    NSString* _atUsername;
}
@end

#define TEXT_COUNT_BTN_WIDTH 45
#define CLEAR_BTN_WIDTH 20

#define BAR_BTN_MAX_COUNT 4
#define INPUT_TEXT_MAX_COUNT 160

#define CLEAR_TEXT_ACTION_SHEET_TAG 1000
#define PHOTO_PICK_ACTION_SHEET_TAG 1001
#define SAVE_TO_DRAFT_ACTION_SHEET_TAG 1002

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCTweetPostC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserName:(NSString*)username
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        if (username.length > 0) {
            _atUsername = [[NSString stringWithFormat:@"@%@ ", username] copy];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发表新动弹";
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.leftBarButtonItem = [OSCGlobalConfig createBarButtonItemWithTitle:@"取消"
                                                                                      target:self
                                                                                      action:@selector(dismissSelf)];
        self.navigationItem.rightBarButtonItem = [OSCGlobalConfig createBarButtonItemWithTitle:@"发送"
                                                                                       target:self
                                                                                       action:@selector(send)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 文本输入框
    _statusesTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _statusesTextView.font = [UIFont systemFontOfSize:18.f];
    _statusesTextView.delegate = self;
    [self.view addSubview:_statusesTextView];
    
    // 文本计数按钮
    _textCountBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_textCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_textCountBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_textCountBtn addTarget:self action:@selector(showClearTextActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textCountBtn];
    
    // 清空文本按钮
    _clearTextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_clearTextBtn setImage:[UIImage nimbusImageNamed:@"clearbutton_background.png"]
                   forState:UIControlStateNormal];
    [_clearTextBtn addTarget:self
                      action:@selector(showClearTextActionSheet)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearTextBtn];
    
    // 内容选择工具条
    [self createPostButtonBar];
    
    // 键盘表情选择框底图messages_inputview_background.png
    _inputBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _inputBackgroundImageView.image = [UIImage nimbusImageNamed:@"emoticon_keyboard_background.png"];
    [self.view addSubview:_inputBackgroundImageView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self presetStatusesText];
    [self limitPostStatusesText];
    [self registerForKeyboardNotifications];
    [_statusesTextView becomeFirstResponder];
    [self layoutViewsWithKeyboardHeight:TTKeyboardHeightForOrientation(self.interfaceOrientation)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutViewsWithKeyboardHeight:(CGFloat)keboardHeight
{
    // 布局由下到上，从右到左反计算
    _inputBackgroundImageView.frame = CGRectMake(0, self.view.height - keboardHeight,
                                                 self.view.width, keboardHeight);
    _postBtnBar.frame = CGRectMake(0, _inputBackgroundImageView.top - NIToolbarHeightForOrientation(self.interfaceOrientation),
                                   self.view.width, NIToolbarHeightForOrientation(self.interfaceOrientation));
    _clearTextBtn.frame = CGRectMake(self.view.width - CELL_PADDING_4 - CLEAR_BTN_WIDTH,
                                     _postBtnBar.top,
                                     CLEAR_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _textCountBtn.frame = CGRectMake(_clearTextBtn.left - TEXT_COUNT_BTN_WIDTH + CELL_PADDING_4,//右移一点
                                     _clearTextBtn.top
                                     ,TEXT_COUNT_BTN_WIDTH, CLEAR_BTN_WIDTH);
    _statusesTextView.frame = CGRectMake(0, 0, self.view.width, _textCountBtn.top);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem*)getSendButton
{
	return [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(send)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createPostButtonBar
{
    OSCPostButtonBar* bar = [[OSCPostButtonBar alloc] initWithFrame:CGRectZero];
    bar.backgroundColor = [UIColor whiteColor];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
	[bar addButton:nil target:self action:@selector(buttonSelected:)];
    
	int i = 0;
	for (UIButton* btn in bar.buttons) {
		switch (i) {
			case 0:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_camerabutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_camerabutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
			case 1:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_mentionbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
            case 2:
            {
				[btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
            }
				break;
		}
		i++;
	}
    _postBtnBar = bar;
    [self.view addSubview:_postBtnBar];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addBarImageBtn
{
    if (_image) {
        if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
            UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
            [btn setImage:_image forState:UIControlStateNormal];
            // display after change image, important
            [btn setNeedsDisplay];
        }
        else {
            [_postBtnBar addButton:nil target:self action:@selector(buttonSelected:)];
            UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
            [btn setImage:_image forState:UIControlStateNormal];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeBarImageBtn
{
    if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
        UIButton* btn = [_postBtnBar.buttons objectAtIndex:BAR_BTN_MAX_COUNT - 1];
        [btn removeFromSuperview];
        [(NSMutableArray*)_postBtnBar.buttons removeObjectAtIndex:BAR_BTN_MAX_COUNT - 1];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showPhotoPickerActionSheet
{
    UIActionSheet* as = nil;
    if (BAR_BTN_MAX_COUNT == _postBtnBar.buttons.count) {
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照", @"用户相册", @"删除图片", nil];
        
    }
    else {
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照", @"用户相册", nil];
        
    }
    as.tag = PHOTO_PICK_ACTION_SHEET_TAG;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showClearTextActionSheet
{
    if (_statusesTextView.text.length > 0) {
        UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                               cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除文字"
                                               otherButtonTitles:nil];
        as.tag = CLEAR_TEXT_ACTION_SHEET_TAG;
        [as showInView:self.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showPhotoBrowseView
{
    OSCPostPhotoBrowseC* browseC = [[OSCPostPhotoBrowseC alloc] initWithImage:_image];
    browseC.deletePhotoDelegate = self;
    [self.navigationController pushViewController:browseC animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDismissSaveToDraftActionSheet
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存"
                                           otherButtonTitles:@"TODO:保存草稿", nil];
    as.tag = SAVE_TO_DRAFT_ACTION_SHEET_TAG;
    [as showInView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissSelf
{
    if (_statusesTextView.text.length > 0
        || _image) {
        [self showDismissSaveToDraftActionSheet];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveToDraftAndDissmisSelf
{
    // TODO: save to draft
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presetStatusesText
{
    _statusesTextView.text = _atUsername;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)send
{
    UIImage* image = _image;
    NSString* content = _statusesTextView.text;
    if (image || content.length > 0) {
        if (!_postModel) {
            _postModel = [[OSCTweetPostModel alloc] init];
        }
        [[MTStatusBarOverlay sharedOverlay] postMessage:@"动弹发布中..."];
        
#if 0//simulate post success and notification to auto refresh
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_POST_NEW_TWEET_SUCCESS_NOTIFICATION
                                                            object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"发布成功" duration:2.0f animated:YES];
        return;
#endif
        
        [_postModel postNewTweetWithBody:_statusesTextView.text image:image success:^{
            [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"发布成功" duration:2.0f animated:YES];
            // notification to update
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_POST_NEW_TWEET_SUCCESS_NOTIFICATION
                                                                object:nil userInfo:nil];
        } failure:^(OSCErrorEntity *errorEntity) {
            [[MTStatusBarOverlay sharedOverlay] postImmediateFinishMessage:@"发布失败！" duration:2.0f animated:YES];
            // TODO: save to draft
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [OSCGlobalConfig HUDShowMessage:@"请输入内容" addedToView:self.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 位置 图片 话题 @用户 表情/键盘
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)buttonSelected:(id)sender
{
	int selectedIndex = [[_postBtnBar buttons] indexOfObject:sender];
    switch (selectedIndex) {
        case 0:
            // 拍照 or 相册
            [self showPhotoPickerActionSheet];
            break;
            
        case 1:
            // @某用户
        {
            OSCFriendsC* friendC = [[OSCFriendsC alloc] initWithNibName:nil bundle:nil];;
            friendC.friendsDelegate = self;
            [self.navigationController pushViewController:friendC animated:YES];
        }
            break;
            
        case 2:
            // 表情
        {
            if (TTIsKeyboardVisible()) {
                // 隐藏键盘
                [_statusesTextView resignFirstResponder];
                // 显示表情选择框
                if (!_emotionMainView) {
                    _emotionMainView = [[OSCEmotionMainView alloc] initWithFrame:_inputBackgroundImageView.frame];
                    _emotionMainView.EmotionDelegate = self;
                }
                [self popupEmotionViewAnimation];
                
                // 修改按钮为显示键盘图标
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:selectedIndex];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_keyboardbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_keyboardbutton_background_hightlighted.png"]
                     forState:UIControlStateHighlighted];
            }
            else {
                // 显示键盘
                [_statusesTextView becomeFirstResponder];
                // 移除表情选择框
                [self popdownEmotionViewAnimation];
                
                // 修改按钮为显示表情图标
                UIButton* btn = [_postBtnBar.buttons objectAtIndex:selectedIndex];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background.png"]
                     forState:UIControlStateNormal];
                [btn setImage:[UIImage nimbusImageNamed:@"compose_emoticonbutton_background_hightlighted.png"]
                     forState:UIControlStateHighlighted];
            }
        }
            break;
        case 3:
        {
            [self showPhotoBrowseView];
        }
            break;
        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popupEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionMainView.top = _inputBackgroundImageView.top;
    [self.view addSubview:_emotionMainView];
    [UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popdownEmotionViewAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    _emotionMainView.top = _inputBackgroundImageView.bottom;
    [UIView commitAnimations];
}

/*
 相册里的原图
 3264x2448，大小2.1M
 
 新浪客户端处理图片的方法
 1. 通过wifi上传
 s_90x120     3.4k
 m_440x586    44k
 l_1200x1600  271k
 
 2. 通过2g 3g上传
 s_90x120     3.4k
 m_440x586    44k
 l_768x1024   112k
 
 2g 3g得到的图片是完全一样的；上传后的图片都能自动旋转
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)optimizeSizeForNetStatusWithImage:(UIImage*)image
{
    CGSize size = image.size;
    CGFloat compressionQuality = 1.0f;
    if ([[JLNetworkSpy sharedNetworkSpy] isReachableViaWiFi] ) {
        size = CGSizeMake(1200, 1600);
        compressionQuality = 0.45f;
    }
    else {
        size = CGSizeMake(768, 1024);
        compressionQuality = 0.5f;
    }
    
    UIImage* newImage = [image scaleToFitSize:size];
    NSData* data = UIImageJPEGRepresentation(newImage, compressionQuality);
    newImage = [[UIImage alloc] initWithData:data];
    
    return newImage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)limitPostStatusesText
{
    int delta = INPUT_TEXT_MAX_COUNT - _statusesTextView.text.length;
    
    if (delta > 0) {
        [_textCountBtn setTitle:[NSString stringWithFormat:@"%d", delta] forState:UIControlStateNormal];
    }
    else {
        // 地理位置占10字符
        int maxCount = INPUT_TEXT_MAX_COUNT;
        _statusesTextView.text = [_statusesTextView.text substringToIndex:maxCount];
        [_textCountBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    
    // 是否显示清空按钮
    [self checkIfNeedShowClearButton];
    
    // 发送按钮是否可点击
    if (_statusesTextView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkIfNeedShowClearButton
{
    if (_statusesTextView.text.length > 0) {
        _clearTextBtn.hidden = NO;
    }
    else {
        _clearTextBtn.hidden = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIKeyboardNotification

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self layoutViewsWithKeyboardHeight:kbSize.height];
	
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self layoutViewsWithKeyboardHeight:kbSize.height];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDPostPhotoDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deletePhoto
{
    [self removeBarImageBtn];
    self.image = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OSCEmotionDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)emotionSelectedWithCode:(NSString*)code
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, code];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDTrendsDelegate

- (void)didSelectATrend:(NSString*)trend
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@", _statusesTextView.text, trend];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ZDFriendsDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectAFriend:(OSCFriendEntity*)user
{
    _statusesTextView.text = [NSString stringWithFormat:@"%@%@ ", _statusesTextView.text, [user getNameWithAt]];
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextViewDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView
{
    [self limitPostStatusesText];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (SAVE_TO_DRAFT_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            case 1:
                [self saveToDraftAndDissmisSelf];
            default:
                break;
        }
    }
    else if (CLEAR_TEXT_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
                _statusesTextView.text = @"";
                [self limitPostStatusesText];
                break;
                
            default:
                break;
        }
    }
    else if (PHOTO_PICK_ACTION_SHEET_TAG == actionSheet.tag) {
        switch (buttonIndex) {
            case 0:
            {
                // 隐藏键盘
                [_statusesTextView resignFirstResponder];
                
                // 拍照
                if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:NULL];
                }
                else {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:NULL];
                }
            }
                break;
                
            case 1:
            {
                // 隐藏键盘
                [_statusesTextView resignFirstResponder];
                
                // 用户相册
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            case 2:
            {
                [self deletePhoto];
            }
                break;
                
            default:
                break;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIImagePickerControllerDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [OSCGlobalConfig HUDShowMessage:@"处理中..." addedToView:self.view];
    
    _picker = picker;
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [NSThread detachNewThreadSelector:@selector(optimizeImage:) toTarget:self withObject:image];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 此处异步animation会导致程序crash
	[picker dismissViewControllerAnimated:YES completion:NULL];
    _picker = nil;
    // 显示键盘
    [_statusesTextView becomeFirstResponder];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)optimizeImage:(UIImage*)image
{
    // 处理图片，并菊花提示
    self.image = [self optimizeSizeForNetStatusWithImage:image];
    // 界面显示放入主线程
    [self performSelectorOnMainThread:@selector(dismissPickerViewAndAddBarImageBtn) withObject:nil waitUntilDone:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissPickerViewAndAddBarImageBtn
{
    [self addBarImageBtn];
    
    // 此处异步animation会导致程序crash
	[_picker dismissViewControllerAnimated:YES completion:NULL];
    _picker = nil;
    // 显示键盘
    [_statusesTextView becomeFirstResponder];
}

@end
