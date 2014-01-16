//
//  SMTrendsC.h
//  SinaMBlog
//
//  Created by jimney on 13-3-8.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusTableViewController.h"

@class OSCFriendEntity;
@protocol OSCFriendsDelegate;

@interface OSCFriendsC : JLNimbusTableViewController
@property(nonatomic, assign) id<OSCFriendsDelegate> friendsDelegate;
@end

@protocol OSCFriendsDelegate <NSObject>
- (void)didSelectAFriend:(OSCFriendEntity*)user;
@end