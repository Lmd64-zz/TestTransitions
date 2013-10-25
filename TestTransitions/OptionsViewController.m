//
//  OptionsViewController.m
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import "OptionsViewController.h"

@implementation OptionsViewController

- (id)initWithPanTarget:(id<OptionsViewControllerPanTarget>)panTarget{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _panTarget = panTarget;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];

    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Options"];
    [label setFrame:CGRectMake(10, 30, 240, 40)];
    [label setTextColor:[UIColor whiteColor]];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button setFrame:CGRectMake(220, 30, 80, 40)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textview = [[UITextView alloc] init];
    [textview setText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."];
    [textview setTextColor:[UIColor whiteColor]];
    [textview setFrame:CGRectMake(10, 80, 300, 200)];
    [self.view addSubview:textview];
    textview.backgroundColor = [UIColor clearColor];
    [textview setEditable:NO];

    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.panTarget action:@selector(userDidPan:)];
    gestureRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:gestureRecognizer];

}

- (void)dismissViewController:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
