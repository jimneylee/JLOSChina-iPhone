//
//  SMTrendCell.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-8-15.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCActivityCell.h"
#import "OSCActivityEntity.h"

#define TITLE_FONT_SIZE [UIFont boldSystemFontOfSize:17.f]

@implementation OSCActivityCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 44.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.font = TITLE_FONT_SIZE;

    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[OSCActivityEntity class]]) {
        OSCActivityEntity* entity = (OSCActivityEntity*)object;
        self.textLabel.text = [entity authorName];
    }
    return YES;
}

@end
