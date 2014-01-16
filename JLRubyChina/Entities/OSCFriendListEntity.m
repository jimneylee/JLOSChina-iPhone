//
//  SMFriendsEntity.m
//  SinaMBlog
//
//  Created by jimney on 13-3-12.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCFriendListEntity.h"
#import "OSCFriendEntity.h"

@implementation OSCFriendListEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDataArray:(NSArray*)dataArray
{
    OSCFriendListEntity* entity = [OSCFriendListEntity new];
    if (dataArray.count > 0) {
        
        entity.unsortedArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (NSDictionary* d in dataArray) {
            OSCFriendEntity* e = [OSCFriendEntity entityWithDictionary:d];
            if (e) {
                [entity.unsortedArray addObject:e];
            }
        }
        
        [entity sort];
    }
    return entity;
}

@end
