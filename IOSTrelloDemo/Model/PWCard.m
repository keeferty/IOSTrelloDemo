//
//  PWCard.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWCard.h"
#import "PWWSManager.h"
#import "PWDataManager.h"

@implementation PWCard

#pragma mark - JSONModel setup methods

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identifier",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"operationType"]) return YES;
    return NO;
}

#pragma mark - API interaction

- (void)create
{
    __weak PWCard *weakSelf = self;
    if (self.operationType == CardOperationTypeRedy) {
        [[PWDataManager sharedInstance].stack addObject:self];
    }
    self.operationType = CardOperationTypeCreate;
    [[PWWSManager sharedInstance] createCard:self completionBlock:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            weakSelf.identifier = responseObject[@"id"];
            weakSelf.operationType = CardOperationTypeRedy;
            [[PWDataManager sharedInstance].stack removeObject:weakSelf];
        }
    } failureBlock:^(NSError *error) {
        CLS_LOG(@"%@",[error localizedDescription]);
    }];
}

- (void)save
{
    __weak PWCard *weakSelf = self;
    if (self.operationType == CardOperationTypeRedy) {
        [[PWDataManager sharedInstance].stack addObject:self];
        self.operationType = CardOperationTypeModify;
    }
    [[PWWSManager sharedInstance] modifyCard:self completionBlock:^(id responseObject) {
        weakSelf.operationType = CardOperationTypeRedy;
        [[PWDataManager sharedInstance].stack removeObject:weakSelf];
    } failureBlock:^(NSError *error) {
        CLS_LOG(@"%@",[error localizedDescription]);
    }];
}

- (void)remove
{
    __weak PWCard *weakSelf = self;
    if (self.operationType == CardOperationTypeRedy) {
        [[PWDataManager sharedInstance].stack addObject:self];
    }
    self.operationType = CardOperationTypeDelete;
    [[PWWSManager sharedInstance] deleteCard:self completionBlock:^(id responseObject) {
        [[PWDataManager sharedInstance].stack removeObject:weakSelf];
    } failureBlock:^(NSError *error) {
        CLS_LOG(@"failure");        
    }];
}

- (void)restart
{
    switch (self.operationType) {
        case CardOperationTypeDelete:
            [self remove];
            break;
        case CardOperationTypeModify:
            [self save];
            break;
        case CardOperationTypeCreate:
            [self create];
            break;
        default:
            break;
    }
}
@end
