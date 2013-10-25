//
//  Animator.h
//  TestTransitions
//
//  Created by Liam Dunne on 25/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) BOOL presenting;
@end
