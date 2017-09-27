//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "MKDropdownMenuTransition.h"

static const NSTimeInterval kAnimationDuration = 0.25;
static const CGFloat kScrollViewBottomSpace = 5;

@implementation MKDropdownMenuTransition

- (instancetype)initWithDropdownMenu:(MKDropdownMenu *)menu
               contentViewController:(MKDropdownMenuContentViewController *)controller {
    self = [super init];
    if (self) {
        self.menu = menu;
        self.controller = controller;
        self.duration = kAnimationDuration;
        _previousScrollViewBottomInset = CGFLOAT_MAX;
    }
    return self;
}

- (void)presentDropdownInContainerView:(UIView *)containerView animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.containerView = containerView;
    
    [self.controller beginAppearanceTransition:YES animated:animated];
    
    CGRect frame = [containerView convertRect:self.menu.bounds fromView:self.menu];
    CGFloat topOffset = CGRectGetMaxY(frame);
    CGFloat contentHeight = self.controller.contentHeight;
    CGFloat contentY = topOffset - contentHeight - self.menu.frame.size.height;
    
    // Adjust scrollView + height
    CGFloat height = CGRectGetHeight(containerView.bounds);
    void (^scrollViewAdjustBlock)(void) = ^{};
    
    if ([containerView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)containerView;
        
        CGFloat contentMaxY = topOffset + contentHeight + kScrollViewBottomSpace;
        CGFloat inset = contentMaxY - scrollView.contentSize.height - scrollView.contentInset.bottom;
        CGFloat offset = 0;
        
        if (self.controller.showAbove) {
            
            height = frame.origin.y;
            // No scroll => adjust top
            topOffset = offset = contentY < scrollView.contentOffset.y ? contentY : scrollView.contentOffset.y;
        }
        else {
            offset = contentMaxY - scrollView.bounds.size.height;
            height = MAX(height - scrollView.contentInset.top, scrollView.contentSize.height + scrollView.contentInset.bottom);
            
            if (_menu.adjustsContentInset) {
                height = MAX(height, contentMaxY);
            }
        }
        
        scrollViewAdjustBlock = ^{
            if (_menu.adjustsContentInset && inset > 0) {
                _previousScrollViewBottomInset = scrollView.contentInset.bottom;
                UIEdgeInsets contentInset = scrollView.contentInset;
                contentInset.bottom += inset;
                scrollView.contentInset = contentInset;
            }
            if (_menu.adjustsContentOffset
                && (self.controller.showAbove ? offset < scrollView.contentOffset.y : scrollView.contentOffset.y < offset)) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, offset);
            }
        };
    }
    else if (self.controller.showAbove) {
        topOffset = 0;
        height = frame.origin.y;
    }
    
    // Set frame to dropdown's content TableView
    self.controller.view.frame = CGRectMake(CGRectGetMinX(containerView.bounds), topOffset,
                                            CGRectGetWidth(containerView.bounds), height - topOffset);
    
    // Show dropdown
    [containerView addSubview:self.controller.view];
    [self.controller.view layoutIfNeeded];
    
    if (!animated) {
        scrollViewAdjustBlock();
        [self.controller endAppearanceTransition];
        if (completion) {
            completion();
        }
        return;
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 0.5);
    CGFloat tyScale = self.controller.showAbove ? 0.5 : -2;
    t = CGAffineTransformTranslate(t, 0, tyScale * CGRectGetHeight(self.controller.containerView.frame));
    self.controller.containerView.transform = t;
    
    self.controller.view.alpha = 0.0;
    
    _isAnimating = YES;
    
    [UIView animateWithDuration:self.duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:kNilOptions
                     animations:^{
                         self.controller.view.alpha = 1.0;
                         self.controller.containerView.transform = CGAffineTransformIdentity;
                         scrollViewAdjustBlock();
                     }
                     completion:^(BOOL finished) {
                         [self.controller endAppearanceTransition];
                         _isAnimating = NO;
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)dismissDropdownAnimated:(BOOL)animated completion:(void (^)(void))completion {
    
    [self.controller beginAppearanceTransition:NO animated:animated];
    
    void (^scrollViewResetBlock)(void) = ^{};
    
    if ([self.containerView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.containerView;
        scrollViewResetBlock = ^{
            if (_previousScrollViewBottomInset != CGFLOAT_MAX) {
                UIEdgeInsets contentInset = scrollView.contentInset;
                contentInset.bottom = _previousScrollViewBottomInset;
                scrollView.contentInset = contentInset;
                _previousScrollViewBottomInset = CGFLOAT_MAX;
            }
            if (_menu.adjustsContentOffset && scrollView.contentOffset.y < 0) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            }
        };
    }
    
    if (!animated) {
        scrollViewResetBlock();
        [self.controller.view removeFromSuperview];
        [self.controller endAppearanceTransition];
        if (completion) {
            completion();
        }
        return;
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 0.5);
    CGFloat tyScale = self.controller.showAbove ? 0.5 : -2;
    t = CGAffineTransformTranslate(t, 0, tyScale * CGRectGetHeight(self.controller.containerView.frame));
    
    _isAnimating = YES;
    
    [UIView animateWithDuration:self.duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:kNilOptions
                     animations:^{
                         self.controller.view.alpha = 0.0;
                         self.controller.containerView.transform = t;
                         scrollViewResetBlock();
                     }
                     completion:^(BOOL finished) {
                         [self.controller.view removeFromSuperview];
                         self.controller.view.alpha = 1.0;
                         self.controller.containerView.transform = CGAffineTransformIdentity;
                         [self.controller endAppearanceTransition];
                         _isAnimating = NO;
                         if (completion) {
                             completion();
                         }
                     }];
    
    self.containerView = nil;
}

@end
