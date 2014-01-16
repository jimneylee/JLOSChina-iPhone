//
//  SMPostPhotoBrowseC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-7.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//


@protocol OSCPostPhotoBrowseDelegate;
@interface OSCPostPhotoBrowseC : UIViewController<UIScrollViewDelegate>

- (id)initWithUrlPath:(NSString*)urlPath;
- (id)initWithImage:(UIImage*)image;

@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NINetworkImageView* imageView;
@property (nonatomic, assign) id<OSCPostPhotoBrowseDelegate> deletePhotoDelegate;

@end

@protocol OSCPostPhotoBrowseDelegate <NSObject>
@optional
- (void)deletePhoto;
@end