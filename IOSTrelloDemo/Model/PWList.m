//
//  PWList.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWList.h"

@implementation PWList

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identifier",
                                                       }];
}

- (NSMutableArray<Ignore,PWCard> *)cards
{
    if (!_cards) {
        _cards = (NSMutableArray<Ignore,PWCard> *)[NSMutableArray new];
    }
    return _cards;
}

@end
