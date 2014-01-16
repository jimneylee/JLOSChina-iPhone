//
//  SMEmotionEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-5.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCEmotionEntity.h"

@implementation OSCEmotionEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
// imageName:001.png
// code:[0]
// name:[微笑]
+ (id)entityWithDictionary:(NSDictionary*)dic atIndex:(int)index
{
	OSCEmotionEntity* entity = [[OSCEmotionEntity alloc] init];
    entity.name = dic[@"name"];
    entity.code = [NSString stringWithFormat:@"[%d]", index];//[dic objectForKey:@"code"];
	entity.imageName = [NSString stringWithFormat:@"%03d.png", index+1];//[dic objectForKey:@"image"];
	return entity;
}

@end
