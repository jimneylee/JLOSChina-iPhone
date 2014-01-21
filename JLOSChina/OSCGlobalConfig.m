//
//  RCGlobalConfig.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCGlobalConfig.h"
#import "OSCEmotionEntity.h"

// emotion
static NSArray* emotionsArray = nil;
static OSCUserFullEntity* loginedUserEntity = nil;

@implementation OSCGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global Data

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCUserFullEntity*)loginedUserEntity
{
    return loginedUserEntity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setLoginedUserEntity:(OSCUserFullEntity*)userEntity
{
    loginedUserEntity = userEntity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Info

///////////////////////////////////////////////////////////////////////////////////////////////////
// code from old version
+ (NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }
    else
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [settings setObject:uuidString forKey:@"guid"];
        [settings synchronize];
        return uuidString;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// code from old version
+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"OSChina.NET/%@/%@/%@/%@",APP_VERSION,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCCatalogType)catalogTypeForContentType:(OSCContentType)contentType
{
    OSCCatalogType catalogType = OSCCatalogType_News;
    switch (contentType) {
        case OSCContentType_LatestNews:
            catalogType = OSCCatalogType_News;
            break;
            
        case OSCContentType_LatestBlog:
        case OSCContentType_RecommendBlog:
            catalogType = OSCCatalogType_Blog;
            break;
            
        case OSCContentType_Forum:
            catalogType = OSCCatalogType_Forum;
            
            break;
            
        case OSCContentType_Tweet:
            catalogType = OSCCatalogType_Tweet;
            break;
            
        default:
            break;
    }
    return catalogType;
}

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
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action
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
        return [OSCGlobalConfig createBarButtonItemWithTitle:@"菜单" target:target action:action];
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
#pragma mark -
#pragma mark Emotion
+ (NSArray* )emotionsArray
{
    if (!emotionsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:EMOTION_PLIST ofType:nil];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* entities = [NSMutableArray arrayWithCapacity:array.count];
        OSCEmotionEntity* entity = nil;
        NSDictionary* dic = nil;
        for (int i = 0; i < array.count; i++) {
            dic = array[i];
            entity = [OSCEmotionEntity entityWithDictionary:dic atIndex:i];
            [entities addObject:entity];
        }
        emotionsArray = entities;
    }
    return emotionsArray;
}

+ (NSString*)imageNameForEmotionCode:(NSString*)code
{
    for (OSCEmotionEntity* e in [OSCGlobalConfig emotionsArray]) {
        if ([e.code isEqualToString:code]) {
            return e.imageName;
        }
    }
    return nil;
}

+ (NSString*)imageNameForEmotionName:(NSString*)name
{
    for (OSCEmotionEntity* e in [OSCGlobalConfig emotionsArray]) {
        if ([e.name isEqualToString:name]) {
            return e.imageName;
        }
    }
    return nil;
}

@end
