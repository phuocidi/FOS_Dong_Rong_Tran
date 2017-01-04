//
//  User.m
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import "User.h"

@interface User()



@end

@implementation User

+( instancetype )sharedInstance
{
    static User* mfs_Instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mfs_Instance = [ [ User alloc ] init ];
        mfs_Instance.phone = [[NSString alloc] init];
        mfs_Instance.name = [[NSString alloc] init];
        mfs_Instance.email = [[NSString alloc] init];
        mfs_Instance.address = [[NSString alloc] init];
    });
    return mfs_Instance;
}


@end
