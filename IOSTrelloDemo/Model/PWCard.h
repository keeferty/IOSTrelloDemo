//
//  PWCard.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, CardOperationType){
    CardOperationTypeCreate,
    CardOperationTypeModify,
    CardOperationTypeDelete,
    CardOperationTypeRedy,
    
    CardOperationTypeCount
};

@protocol PWCard
@end

@interface PWCard : JSONModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *idList;

@property (nonatomic) CardOperationType operationType;

- (void)create;
- (void)save;
- (void)remove;

- (void)restart;

@end
