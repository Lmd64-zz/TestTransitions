//
//  ViewController.h
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

@interface ViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) OptionsViewController *optionsViewController;

@end
