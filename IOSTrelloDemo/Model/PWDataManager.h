//
//  PWDataManager.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWDataManager : NSObject

@property (nonatomic, copy) NSString *token;

+ (instancetype)sharedInstance;
@end
