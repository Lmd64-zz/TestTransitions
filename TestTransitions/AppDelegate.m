//
//  AppDelegate.m
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.

    self.viewController = [[ViewController alloc] init];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    [self.navigationController setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.viewController;
    [self.window setBackgroundColor:[UIColor darkGrayColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
@end
