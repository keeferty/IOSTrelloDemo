//
//  PWHomeCollectionViewCell.h
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWCard;

@interface PWHomeCollectionViewCell : UICollectionViewCell

- (void)setupWithCard:(PWCard *)card;

@end
