//
//  PWViewController.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWViewController.h"
#import "PWWSManager.h"
@interface PWViewController ()

@end

@implementation PWViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PWWSManager sharedInstance]login:@"pawel.weglewski@implix.com" password:@"Anathemized193"];
}

@end
