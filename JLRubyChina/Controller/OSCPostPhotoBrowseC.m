//
//  SMPostPhotoBrowseC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-7.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCPostPhotoBrowseC.h"

@interface OSCPostPhotoBrowseC ()

@end

@implementation OSCPostPhotoBrowseC

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUrlPath:(NSString*)urlPath
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.urlPath = urlPath;
        if (self.urlPath && self.imageView) {
            [_imageView setPathToNetworkImage:self.urlPath];
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithImage:(UIImage*)image
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.image = image;
        if (self.image && self.imageView) {
            _imageView.initialImage = self.image;
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        self.navigationItem.rightBarButtonItem = [OSCGlobalConfig createBarButtonItemWithTitle:@"删除照片"
                                                                                       target:self
                                                                                       action:@selector(deletePhoto)];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(showOrHideNavigationBar)];
        [self.view addGestureRecognizer:tapGesture];
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
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height
                              - NIStatusBarHeight() - NIToolbarHeightForOrientation(self.interfaceOrientation));
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0f;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    _imageView = [[NINetworkImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_imageView];
    
    if (self.urlPath) {
        [_imageView setPathToNetworkImage:self.urlPath];
    }
    else if (self.image) {
        _imageView.initialImage = self.image;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showOrHideNavigationBar
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    self.scrollView.frame = self.view.bounds;
    //NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrolViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deletePhoto
{
    if ([self.deletePhotoDelegate respondsToSelector:@selector(deletePhoto)]) {
        [self.deletePhotoDelegate deletePhoto];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrolViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
