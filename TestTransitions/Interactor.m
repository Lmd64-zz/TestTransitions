//
//  Interactor.m
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import "Interactor.h"
#import "OptionsViewController.h"

@interface Interactor () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>
@property (nonatomic,assign) BOOL interactive;
@property (nonatomic,assign) BOOL presenting;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation Interactor

- (id)initWithParentViewController:(UIViewController *)viewController {
    if ((self = [super init])){
        _parentViewController = viewController;
    }
    return self;
}

- (void)presentViewController {
    self.presenting = YES;
    
    OptionsViewController *viewController = [[OptionsViewController alloc] initWithPanTarget:self];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self.parentViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer {
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    CGPoint velocity = [recognizer velocityInView:self.parentViewController.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;
        
        // The side of the screen we're panning from determines whether this is a presentation (left) or dismissal (right)
        if (location.x < CGRectGetMidX(recognizer.view.bounds)) {
            self.presenting = YES;
            OptionsViewController *viewController = [[OptionsViewController alloc] initWithPanTarget:self];
            viewController.modalPresentationStyle = UIModalPresentationCustom;
            viewController.transitioningDelegate = self;
            [self.parentViewController presentViewController:viewController animated:YES completion:nil];
        } else {
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
    
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Determine our ratio between the left edge and the right edge. This means our dismissal will go from 1...0.
        CGFloat ratio = location.x / CGRectGetWidth(self.parentViewController.view.bounds);
        [self updateInteractiveTransition:ratio];

    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        if (self.presenting) {
            if (velocity.x >= 0) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        } else {
            if (velocity.x <= 0) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
    }
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning delegate methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerAnimatedTransitioning delegate methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Used only in non-interactive transitions, despite the documentation
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    DLog(@"");
    if (self.interactive) {
        // nop as per documentation
    } else {
        // This code is lifted wholesale from the TLTransitionAnimator class
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        CGFloat scale = 1.0 - 0.1 * 1.0;
        transform = CGAffineTransformScale(transform, scale, scale);

        if (self.presenting) {
            // The order of these matters – determines the view hierarchy order.
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];
            
            CGRect startFrame = endFrame;
            startFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
            
            toViewController.view.frame = startFrame;
            toViewController.view.alpha = 0.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toViewController.view.frame = endFrame;
                toViewController.view.alpha = 1.0;
                fromViewController.view.transform = transform;
                fromViewController.view.alpha = 1.0 - 0.5 * 1.0;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];
            
            endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);

            fromViewController.view.alpha = 1.0;
            toViewController.view.transform = transform;

            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.frame = endFrame;
                fromViewController.view.alpha = 0.0;
                toViewController.view.transform = CGAffineTransformIdentity;
                toViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}

- (void)animationEnded:(BOOL)transitionCompleted {
    DLog(@"");
    // Reset to our default state
    self.interactive = NO;
    self.presenting = NO;
    self.transitionContext = nil;
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewControllerInteractiveTransitioning methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DLog(@"");
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.presenting){
        // The order of these matters – determines the view hierarchy order.
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
    } else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
    }
    
    toViewController.view.frame = endFrame;
    
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIPercentDrivenInteractiveTransition overridden methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Presenting goes from 0...1 and dismissing goes from 1...0
    CGRect frame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]) * (1.0f - percentComplete), 0);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat scale = 1.0 - 0.1 * percentComplete;
    transform = CGAffineTransformScale(transform, scale, scale);
    
    if (self.presenting){
        toViewController.view.frame = frame;
        toViewController.view.alpha = percentComplete;
        fromViewController.view.transform = transform;
        fromViewController.view.alpha = 1.0 - 0.5 * percentComplete;
    } else {
        fromViewController.view.frame = frame;
        fromViewController.view.alpha = percentComplete;
        toViewController.view.transform = transform;
        toViewController.view.alpha = 1.0 - 0.5 * percentComplete;
    }
}

- (void)finishInteractiveTransition {
    DLog(@"");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat scale = 1.0 - 0.1 * 1.0;
    transform = CGAffineTransformScale(transform, scale, scale);

    if (self.presenting){
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:0.2f animations:^{
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = 1.0;
            fromViewController.view.transform = transform;
            fromViewController.view.alpha = 1.0 - 0.5 * 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    } else {
        CGRect endFrame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[self.transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:0.2f animations:^{
            fromViewController.view.frame = endFrame;
            fromViewController.view.alpha = 0.0;
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

- (void)cancelInteractiveTransition {
    DLog(@"");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting)
    {
        CGRect endFrameTo = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]), 0);
        CGRect endFrameFrom = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:0.5f animations:^{
            fromViewController.view.frame = endFrameFrom;
            fromViewController.view.alpha = 1.0;
            fromViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.frame = endFrameTo;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
    else {
        CGRect endFrameTo = [[transitionContext containerView] bounds];
        CGRect endFrameFrom = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.frame = endFrameTo;
            toViewController.view.alpha = 1.0;
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.frame = endFrameFrom;
            fromViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
}

@end
