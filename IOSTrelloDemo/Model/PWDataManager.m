//
//  PWDataManager.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWDataManager.h"

@implementation PWDataManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static PWDataManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [PWDataManager new];
    });
    return sharedManager;
}
@end
