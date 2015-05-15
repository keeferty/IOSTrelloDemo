//
//  PWWSManager.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AF2OAuth1Token;

@interface PWWSManager : NSObject

+ (instancetype)sharedInstance;

- (void)login:(NSString *)username
     password:(NSString *)password
completionBlock:(void(^)(NSString *accessToken))completionBlock
 failureBlock:(void(^)(NSError *error))failureBlock;

@end
