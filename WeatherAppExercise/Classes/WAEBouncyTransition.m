//
//  WAEBouncyTransition.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/22/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAEBouncyTransition.h"

@implementation WAEBouncyTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = CGRectMake(fromFrame.origin.x,
                                 fromFrame.size.height + 16.f,
                                 CGRectGetWidth(fromFrame),
                                 fromFrame.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.f
         usingSpringWithDamping:.5
          initialSpringVelocity:.6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.view.frame = fromFrame;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
