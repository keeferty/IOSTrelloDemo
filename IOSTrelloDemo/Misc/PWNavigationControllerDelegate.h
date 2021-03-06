//
//  PWNavigationControllerDelegate.h
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PWNavigationControllerDelegate : NSObject <UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;

@end
