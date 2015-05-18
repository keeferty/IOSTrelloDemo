//
//  PWDetailViewController.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWViewController.h"
#import "PWCard.h"

@interface PWDetailViewController : PWViewController
@property (weak, nonatomic) PWCard *card;
@end
