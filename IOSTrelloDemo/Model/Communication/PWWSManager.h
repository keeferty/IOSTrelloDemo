//
//  PWWSManager.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWWSManager : NSObject

+ (instancetype)sharedInstance;

- (void)login:(NSString *)username password:(NSString *)password;

@end
