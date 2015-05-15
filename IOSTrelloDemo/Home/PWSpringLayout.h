//
//  SpringLayout.h
//  Yelago
//
//  Created by Pawel Weglewski on 1/21/14.
//  Copyright (c) 2014 Playsoft Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWSpringLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

@property (nonatomic, assign) NSInteger overlap;

@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end
