//
//  PWBoard.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWBoard.h"

@implementation PWBoard

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identifier",
                                                       }];
}

@end
