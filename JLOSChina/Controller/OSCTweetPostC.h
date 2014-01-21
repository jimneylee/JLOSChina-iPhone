//
//  SMMBlogPostC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-4.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetPostModel.h"
#import "OSCEmotionMainView.h"
#import "OSCPostButtonBar.h"
#import "OSCPostPhotoBrowseC.h"
#import "OSCFriendsC.h"

@interface OSCTweetPostC : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITextViewDelegate,
OSCEmotionDelegate, OSCFriendsDelegate, OSCPostPhotoBrowseDelegate>

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, copy) NSString* streetPlace;

// 发表@某人微博
- (id)initWithUserName:(NSString*)username;

@end
