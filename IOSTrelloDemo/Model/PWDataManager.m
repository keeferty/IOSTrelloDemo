//
//  PWDataManager.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWDataManager.h"
#import "PWWSManager.h"
#import "AppDelegate.h"

@implementation PWDataManager

+ (instancetype)sharedInstance
{
    static PWDataManager *sharedManager = nil;
    
    if (!sharedManager) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"PWDataManager"]) {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"PWDataManager"];
            sharedManager = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedManager = [PWDataManager new];
                sharedManager.token = nil;
                sharedManager.board = nil;
                sharedManager.stack = (NSMutableArray<PWCard> *)[NSMutableArray new];
            });
        }
    }
    return sharedManager;
}

#pragma mark - Data Manager internal functionality

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"PWDataManager"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setOffline:(BOOL)offline
{
    _offline = offline;
    if (!offline) {
        [self reloadStackedOperations];
    }
}

- (void)reloadStackedOperations
{
    __weak PWDataManager *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.stack enumerateObjectsUsingBlock:^(PWCard *card, NSUInteger idx, BOOL *stop) {
            [card restart];
        }];
    });
}
#pragma mark - data gathering proxy methods

- (void)login:(NSString *)username password:(NSString *)password
{
    __weak PWDataManager *weakSelf = self;
    [[PWWSManager sharedInstance] login:username
                               password:password
                        completionBlock:^(NSString *accessToken) {
                            weakSelf.token = accessToken;
                            weakSelf.loggedIn = YES;
                            [weakSelf save];
                        } failureBlock:^(NSError *error) {
                            [weakSelf showAlert:LocString(@"errorTitle")
                                        message:LocString(@"loginErrorMessage")];
                        }];
}

- (void)getOpenBoards
{
    __weak PWDataManager *weakSelf = self;
    [[PWWSManager sharedInstance] getOpenBoards:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSError *error;
                    PWBoard *board = [[PWBoard alloc]initWithDictionary:obj error:&error];
                    if ((error == nil) && (board != nil) && ([board.name isEqualToString:LocString(@"My_Board")])) {
                        weakSelf.board = board;
                        [weakSelf getBoardLists];
                        *stop = YES;
                    }
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlert:LocString(@"errorTitle")
                    message:LocString(@"getOpenBoardsErrorMessage")];
    }];
}

- (void)getBoardLists
{
    __weak PWDataManager *weakSelf = self;
    [[PWWSManager sharedInstance] getBoardLists:self.board.identifier
                                completionBlock:^(id responseObject) {
                                    if ([responseObject isKindOfClass:[NSArray class]]) {
                                        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                                NSError *error;
                                                PWList *list = [[PWList alloc]initWithDictionary:obj error:&error];
                                                if ((error == nil) && (list != nil)) {
                                                    if ([list.name isEqualToString:LocString(@"To do")]) {
                                                        weakSelf.board.toDoList = list;
                                                        [weakSelf getListCards:list];
                                                    }
                                                    if ([list.name isEqualToString:LocString(@"Doing")]) {
                                                        weakSelf.board.doingList = list;
                                                        [weakSelf getListCards:list];
                                                    }
                                                    if ([list.name isEqualToString:LocString(@"Done")]) {
                                                        weakSelf.board.doneList = list;
                                                        [weakSelf getListCards:list];
                                                    }
                                                }
                                            }
                                        }];
                                    }
                                }
                                failureBlock:^(NSError *error) {
                                    [weakSelf showAlert:LocString(@"errorTitle")
                                                message:LocString(@"getBoardListsErrorMessage")];
                                }];
}

- (void)getListCards:(PWList *)list
{
    __weak PWDataManager *weakSelf = self;
    __weak PWList *weakList = list;
    [[PWWSManager sharedInstance] getListCards:list.identifier
                               completionBlock:^(id responseObject) {
                                   if ([responseObject isKindOfClass:[NSArray class]]) {
                                       list.cards = nil;
                                       [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                           if ([obj isKindOfClass:[NSDictionary class]]) {
                                               NSError *error;
                                               PWCard *card = [[PWCard alloc]initWithDictionary:obj error:&error];
                                               card.operationType = CardOperationTypeRedy;
                                               if ((error == nil) && (card != nil)) {
                                                   [weakList.cards addObject:card];
                                               }
                                           }
                                       }];
                                       weakSelf.board.updated = [NSDate date];
                                   }
                               }
                                  failureBlock:^(NSError *error) {
                                      weakSelf.board.updated = [NSDate date];

                                      [weakSelf showAlert:LocString(@"errorTitle")
                                                  message:LocString(@"getListCardsErrorMessage")];
                                  }];
}

- (void)getWholeBoard
{
    __weak PWDataManager *weakSelf = self;
    [RACObserve(self, board.updated) subscribeNext:^(id x) {
        [weakSelf save];
    }];
    [self getOpenBoards];
}

#pragma mark - Helper Stuff

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocString(@"OK")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    [ApplicationDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];

}
@end
