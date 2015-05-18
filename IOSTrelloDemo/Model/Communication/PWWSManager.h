//
//  PWWSManager.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AF2OAuth1Token, PWCard;

@interface PWWSManager : NSObject

@property (nonatomic, strong) NSOperationQueue *defaultQueue;

+ (instancetype)sharedInstance;


- (void)login:(NSString *)username
     password:(NSString *)password
completionBlock:(void(^)(NSString *accessToken))completionBlock
 failureBlock:(void(^)(NSError *error))failureBlock;

- (void)getOpenBoards:(void(^)(id responseObject))completionBlock
         failureBlock:(void(^)(NSError *error))failureBlock;

- (void)getBoardLists:(NSString *)boardId
      completionBlock:(void(^)(id responseObject))completionBlock
         failureBlock:(void(^)(NSError *error))failureBlock;

- (void)getListCards:(NSString *)listId
     completionBlock:(void(^)(id responseObject))completionBlock
        failureBlock:(void(^)(NSError *error))failureBlock;

- (void)deleteCard:(PWCard *)card
   completionBlock:(void(^)(id responseObject))completionBlock
      failureBlock:(void(^)(NSError *error))failureBlock;

- (void)modifyCard:(PWCard *)card
   completionBlock:(void(^)(id responseObject))completionBlock
      failureBlock:(void(^)(NSError *error))failureBlock;

- (void)createCard:(PWCard *)card
   completionBlock:(void(^)(id responseObject))completionBlock
      failureBlock:(void(^)(NSError *error))failureBlock;

@end
