//
//  SMFriendEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCFriendEntity.h"
#import "NSString+stringFromValue.h"
#import "pinyin.h"

@implementation OSCFriendEntity
@synthesize userId = _userId;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
	OSCFriendEntity* entity = [OSCFriendEntity new];
    entity.userId = [NSString stringFromValue:[dic objectForKey:@"userid"]];
	entity.name = [dic objectForKey:@"name"];

    if (entity.name.length > 0) {
        entity.sortString = [entity createSortString];
        return entity;
    }
    else return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public
- (NSString* )getNameWithAt
{
    return [NSString stringWithFormat:@"@%@", self.name];
}

@end
