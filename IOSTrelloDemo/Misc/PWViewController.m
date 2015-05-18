//
//  PWViewController.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWViewController.h"
#import "PWDataManager.h"

@interface PWViewController ()

@end

@implementation PWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak PWViewController *weakSelf = self;
    [[RACObserve([PWDataManager sharedInstance], offline) skip:1] subscribeNext:^(NSNumber *newValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newValue.boolValue) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
                    weakSelf.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    weakSelf.navigationItem.title = LocString(@"OFFLINE");
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                    weakSelf.navigationController.navigationBar.tintColor = [UIColor blackColor];
                    weakSelf.navigationItem.title = nil;                    
                }];
            }
        });
    }];
}
@end
