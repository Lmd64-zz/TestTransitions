//
//  OptionsViewController.h
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsViewControllerPanTarget <NSObject>
- (void)userDidPan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
@end

@interface OptionsViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, readonly) id<OptionsViewControllerPanTarget> panTarget;
- (id)initWithPanTarget:(id<OptionsViewControllerPanTarget>)panTarget;

@end
