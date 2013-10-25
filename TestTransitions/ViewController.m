//
//  ViewController.m
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import "ViewController.h"
#import "Interactor.h"

@interface ViewController ()
@property (strong, nonatomic) Interactor* interactor;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];
    self.interactor = [[Interactor alloc] initWithParentViewController:self];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Home"];
    [label setFrame:CGRectMake(20, 30, 200, 40)];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor clearColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"transition" forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button setFrame:CGRectMake(200, 30, 80, 40)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(presentOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textview = [[UITextView alloc] init];
    [textview setText:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."];
    [textview setFrame:CGRectMake(20, 80, 280, 200)];
    [self.view addSubview:textview];
    textview.backgroundColor = [UIColor clearColor];
    [textview setEditable:NO];

    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactor action:@selector(userDidPan:)];
    gestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
    
//    UIScreenEdgePanGestureRecognizer *gestureRecognizerRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactor action:@selector(userDidPan:)];
//    gestureRecognizerRight.edges = UIRectEdgeRight;
//    [self.view addGestureRecognizer:gestureRecognizerRight];
    
}

- (void)presentOptions:(id)sender{
    [self.interactor presentViewController];
}

@end
