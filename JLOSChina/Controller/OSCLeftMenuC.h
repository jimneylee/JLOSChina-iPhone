//
//  LeftViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LeftMenuType_Tweet,
    LeftMenuType_NewsBlog,
    LeftMenuType_Forum,
    LeftMenuType_Mine,
    LeftMenuType_More
}LeftMenuType;

@protocol RCLeftMenuDelegate;
@interface OSCLeftMenuC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<RCLeftMenuDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)setSelectedMenuType:(LeftMenuType)type;

@end

@protocol RCLeftMenuDelegate <NSObject>

- (void)didSelectLeftMenuType:(LeftMenuType)type;

@end
