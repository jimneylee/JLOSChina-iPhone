//
//  SMStatusCell.h
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/30/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "NICellCatalog.h"

@interface OSCTweetBodyView : UIView
+ (CGFloat)heightForObject:(id)object withViewWidth:(CGFloat)viewWidth;
- (BOOL)shouldUpdateCellWithObject:(id)object;
@end
