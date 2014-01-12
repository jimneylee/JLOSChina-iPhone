//
//  RCGlobalConfig.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCGlobalConfig.h"

static NSString* myToken = @"test";
static NSString* myLoginId = @"jimneylee";

@implementation OSCGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global Data

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)myToken
{
    return myToken;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setMyToken:(NSString*)token
{
    myToken = [token copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)myLoginId
{
    return myLoginId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setMyLoginId:(NSString*)loginId
{
    myLoginId = [loginId copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Config

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view
{
    static MBProgressHUD* hud = nil;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 1.0f;
    [hud hide:YES afterDelay:1.0f];
    return hud;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle Target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action
{
    if (IOS_IS_AT_LEAST_7) {
        return [[UIBarButtonItem alloc] initWithImage:[UIImage nimbusImageNamed:@"icon_menu.png"]
                                                style:UIBarButtonItemStylePlain
                                               target:target action:action];
    }
    else {
        return [OSCGlobalConfig createBarButtonItemWithTitle:@"菜单" Target:target action:action];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                         target:target action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController
{
    OSCLoginC* loginC = [[OSCLoginC alloc] initWithStyle:UITableViewStyleGrouped];
    [navigationController pushViewController:loginC animated:YES];
}
@end
