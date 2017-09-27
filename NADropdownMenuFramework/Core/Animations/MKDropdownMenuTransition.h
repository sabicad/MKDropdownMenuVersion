//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "MKDropdownMenu.h"
#import "MKDropdownMenuContentViewController.h"

@interface MKDropdownMenuTransition : NSObject {
    CGFloat _previousScrollViewBottomInset;
}

@property (assign, nonatomic) NSTimeInterval duration;
@property (readonly, nonatomic) BOOL isAnimating;
@property (weak, nonatomic) MKDropdownMenu *menu;
@property (weak, nonatomic) MKDropdownMenuContentViewController *controller;
@property (weak, nonatomic) UIView *containerView;

- (instancetype)initWithDropdownMenu:(MKDropdownMenu *)menu
               contentViewController:(MKDropdownMenuContentViewController *)controller;
- (void)presentDropdownInContainerView:(UIView *)containerView animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissDropdownAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
