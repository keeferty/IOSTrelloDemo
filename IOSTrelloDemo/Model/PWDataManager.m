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
    static dispatch_once_t onceToken;
    static PWDataManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [PWDataManager new];
    });
    return sharedManager;
}

#pragma mark - data gathering proxy methods

- (void)login:(NSString *)username password:(NSString *)password
{
    __weak PWDataManager *weakSelf = self;
    [[PWWSManager sharedInstance] login:username
                               password:password
                        completionBlock:^(NSString *accessToken) {
                            self.token = accessToken;
                        } failureBlock:^(NSError *error) {
                            [weakSelf showAlert:LocString(@"errorTitle") message:LocString(@"loginErrorMessage")];
                        }];
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
