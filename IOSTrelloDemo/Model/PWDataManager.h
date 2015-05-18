//
//  PWDataManager.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWBoard.h"
#import "PWList.h"
#import "PWCard.h"

@interface PWDataManager : JSONModel

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) PWBoard *board;
@property (nonatomic) BOOL loggedIn;
@property (nonatomic) BOOL offline;
@property (strong, nonatomic) NSMutableArray <PWCard>*stack;


+ (instancetype)sharedInstance;
- (void)save;
- (void)reloadStackedOperations;


- (void)login:(NSString *)username password:(NSString *)password;
- (void)getOpenBoards;
- (void)getBoardLists;
- (void)getListCards:(PWList *)list;
- (void)getWholeBoard;

@end
