//
//  AppDelegate.h
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ViewController *viewController;

@end
