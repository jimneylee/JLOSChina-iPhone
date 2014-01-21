//
//  SMFriendsC.m
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCFriendsC.h"
#import "OSCFriendsModel.h"
#import "OSCFriendEntity.h"

@interface OSCFriendsC ()

@end

@implementation OSCFriendsC

//////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选择好友";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCFriendsModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NITableViewActionBlock)tapAction
{
    return ^BOOL(id object, id target) {
        if (!self.editing) {
            if ([object isKindOfClass:[OSCFriendEntity class]]) {
                OSCFriendEntity* entity = (OSCFriendEntity*)object;
                if ([self.friendsDelegate respondsToSelector:@selector(didSelectAFriend:)]) {
                    [self.friendsDelegate didSelectAFriend:entity];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            return YES;
        }
        else {
            return NO;
        }
    };
}

@end
