//
//  PWPushAnimator.m
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWPushAnimator.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation PWPushAnimator
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] insertSubview:toViewController.view aboveSubview:fromViewController.view];
    toViewController.view.transform = [self rotationPoint:(CGPoint){.x = 0, .y = [UIScreen mainScreen].bounds.size.height} degrees:-90];
    toViewController.view.alpha = 0;
    fromViewController.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1;
                         
                         fromViewController.view.transform = [self rotationPoint:(CGPoint){.x = 0, .y = -[UIScreen mainScreen].bounds.size.height} degrees:-90];
                         fromViewController.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         fromViewController.view.transform = CGAffineTransformIdentity;
//                         fromViewController.view.alpha = 1;
                     }];
}

- (CGAffineTransform)rotationPoint:(CGPoint)point degrees:(NSInteger)deg
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x, point.y);
    transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(deg));
    transform = CGAffineTransformTranslate(transform,-point.x, -point.y);
    return transform;
}
@end
