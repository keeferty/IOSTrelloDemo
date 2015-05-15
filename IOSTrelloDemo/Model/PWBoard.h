//
//  PWBoard.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "JSONModel.h"

@class PWList;

@interface PWBoard : JSONModel
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) PWList <Optional>*toDoList;
@property (nonatomic, strong) PWList <Optional>*doingList;
@property (nonatomic, strong) PWList <Optional>*doneList;
@end
