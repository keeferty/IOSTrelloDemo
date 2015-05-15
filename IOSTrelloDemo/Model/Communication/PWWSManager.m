//
//  PWWSManager.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWWSManager.h"
#import <AFNetworking.h>
#import <AFNetworkActivityLogger.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <AF2OAuth1Client.h>

#import "PWDataManager.h"

#define BASE_URL            @"https://trello.com/1/"

#define LOGIN_REQUEST       @"OAuthGetRequestToken"
#define LOGIN_AUTHORIZE     @"OAuthAuthorizeToken"
#define LOGIN_GET_ACESS     @"OAuthGetAccessToken"

#define GET_BOARDS          @"members/my/boards"
#define GET_BOARD_LISTS     @"boards/%@/lists"

#define GET_LIST_CARDS      @"lists/%@/cards"

@interface PWWSManager ()

@property (nonatomic, strong) NSOperationQueue *defaultQueue;
@property (nonatomic, strong) AF2OAuth1Client *authClient;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation PWWSManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static PWWSManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [PWWSManager new];
        [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(afNetworkingListener:) name:AFNetworkingTaskDidCompleteNotification object:nil];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
#ifdef DEBUG
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif

    });
    return sharedManager;
}

#pragma mark - Listener for errors

- (void)afNetworkingListener:(NSNotification *)note
{
    NSError *error = note.userInfo[AFNetworkingTaskDidCompleteErrorKey];
    CLS_LOG(@"%@",[error localizedDescription]);
}

#pragma mark - Getters for lazy instantiation

- (NSOperationQueue *)defaultQueue
{
    if (!_defaultQueue) {
        _defaultQueue = [NSOperationQueue new];
        [_defaultQueue setMaxConcurrentOperationCount:3];
    }
    return _defaultQueue;
}

- (AF2OAuth1Client *)authClient
{
    if (!_authClient) {
        _authClient = [[AF2OAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]
                                                          key:TRELLO_KEY
                                                       secret:TRELLO_SECRET];
    }
    return _authClient;
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        [_operationManager setOperationQueue:self.defaultQueue];
    }
    return _operationManager;
}

#pragma mark - API Calls

- (void)login:(NSString *)username
     password:(NSString *)password
completionBlock:(void(^)(NSString *accessToken))completionBlock
 failureBlock:(void(^)(NSError *error))failureBlock
{
    [self.authClient authorizeUsingOAuthWithRequestTokenPath:LOGIN_REQUEST
                                       userAuthorizationPath:LOGIN_AUTHORIZE
                                                 callbackURL:[NSURL URLWithString:@"trellodemo://success"]
                                             accessTokenPath:LOGIN_GET_ACESS
                                                accessMethod:@"POST"
                                                       scope:nil
                                                     success:^(AF2OAuth1Token *accessToken, id responseObject) {
                                                         if (completionBlock) {
                                                             completionBlock(accessToken.key);
                                                         }
                                                     } failure:^(NSError *error) {
                                                         if (failureBlock) {
                                                             failureBlock(error);
                                                         }
                                                     }];
}

- (void)getOpenBoards:(void(^)(id responseObject))completionBlock
         failureBlock:(void(^)(NSError *error))failureBlock
{
    [self.operationManager GET:GET_BOARDS
                    parameters:@{@"key" : TRELLO_KEY, @"token" : [PWDataManager sharedInstance].token}
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if (completionBlock) {
                               completionBlock(responseObject);
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           if (failureBlock) {
                               failureBlock(error);
                           }
                       }];
}

- (void)getBoardLists:(NSString *)boardId
      completionBlock:(void(^)(id responseObject))completionBlock
         failureBlock:(void(^)(NSError *error))failureBlock
{
    [self.operationManager GET:[NSString stringWithFormat:GET_BOARD_LISTS,boardId]
                    parameters:@{@"key" : TRELLO_KEY, @"token" : [PWDataManager sharedInstance].token}
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if (completionBlock) {
                               completionBlock(responseObject);
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           if (failureBlock) {
                               failureBlock(error);
                           }
                       }];
}

- (void)getListCards:(NSString *)listId
      completionBlock:(void(^)(id responseObject))completionBlock
         failureBlock:(void(^)(NSError *error))failureBlock
{
    [self.operationManager GET:[NSString stringWithFormat:GET_LIST_CARDS,listId]
                    parameters:@{@"key" : TRELLO_KEY, @"token" : [PWDataManager sharedInstance].token}
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if (completionBlock) {
                               completionBlock(responseObject);
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           if (failureBlock) {
                               failureBlock(error);
                           }
                       }];
}

@end
