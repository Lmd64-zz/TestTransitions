//
//  Interactor.h
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

@interface Interactor : UIPercentDrivenInteractiveTransition <OptionsViewControllerPanTarget>

@property (nonatomic, readonly) UIViewController *parentViewController;

- (id)initWithParentViewController:(UIViewController *)viewController;
- (void)presentViewController;

@end
