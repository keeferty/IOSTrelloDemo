//
//  PWHomeCollectionViewCell.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWHomeCollectionViewCell.h"
#import "PWCard.h"

@interface PWHomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation PWHomeCollectionViewCell

- (void)setupWithCard:(PWCard *)card
{
    self.title.text = card.name;
    self.desc.text = card.desc;
}
@end
