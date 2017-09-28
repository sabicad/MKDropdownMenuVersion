//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "MKDropdownMenuComponentButton.h"

static const CGFloat kDefaultDisclosureIndicatorSize = 8;

static UIImage * MKDropdownMenuDisclosureIndicatorImage() {
    CGFloat a = kDefaultDisclosureIndicatorSize;
    CGFloat h = a * 0.866;
    CGRect rect = CGRectMake(0, a - h, a, h);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(a, a), NO, 0);
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [path closePath];
    [[UIColor blackColor] setFill];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@implementation MKDropdownMenuComponentButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

static UIImage *disclosureIndicatorImage = nil;

- (void)setup {
    self.clipsToBounds = YES;
    self.tintColor = [UIColor whiteColor];
    
    _containerView = [UIView new];
    _containerView.frame = self.bounds;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_containerView];
    
    _disclosureIndicatorView = [UIImageView new];
    _disclosureIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_disclosureIndicatorView];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_disclosureIndicatorView
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:8],
                           [NSLayoutConstraint constraintWithItem:_disclosureIndicatorView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]]];
}

- (UIView *)currentCustomView {
    return self.containerView.subviews.lastObject;
}

- (void)setCustomView:(UIView *)customView {
    if (self.currentCustomView != customView) {
        [self.currentCustomView removeFromSuperview];
        customView.frame = self.containerView.bounds;
        customView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:customView];
    }
    self.containerView.hidden = NO;
    self.accessibilityLabel = customView.accessibilityLabel;
    [self setAttributedTitle:nil selectedTitle:nil];
}

- (void)setAttributedTitle:(NSAttributedString *)title selectedTitle:(NSAttributedString *)selectedTitle {
    [self setAttributedTitle:title forState:UIControlStateNormal];
    [self setAttributedTitle:selectedTitle forState:UIControlStateSelected];
    [self setAttributedTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];
    if (title != nil) {
        [self.currentCustomView removeFromSuperview];
        self.containerView.hidden = YES;
    }
}

- (void)setDisclosureIndicatorImage:(UIImage *)image {
    if (image == nil) {
        if (disclosureIndicatorImage == nil) {
            disclosureIndicatorImage = MKDropdownMenuDisclosureIndicatorImage();
        }
        image = disclosureIndicatorImage;
    }
    
    self.disclosureIndicatorView.image = image;
    [self.disclosureIndicatorView sizeToFit];
    CGFloat insetLeft = 8;
    CGFloat insetRight = (image.size.width > 0) ? image.size.width + 4 + insetLeft : insetLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetLeft, 0, insetRight);
    [self setNeedsLayout];
}

- (void)setDisclosureIndicatorFlipped:(BOOL)disclosureIndicatorFlipped {
    _disclosureIndicatorFlipped = disclosureIndicatorFlipped;
    [self setSelected:self.selected];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    switch (textAlignment) {
        case NSTextAlignmentLeft:
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        case NSTextAlignmentCenter:
        default:
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;
    }
}

- (NSTextAlignment)textAlignment {
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            return NSTextAlignmentLeft;
        case UIControlContentHorizontalAlignmentRight:
            return NSTextAlignmentRight;
        case UIControlContentHorizontalAlignmentCenter:
        default:
            return NSTextAlignmentCenter;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    CGFloat angle = selected ? self.disclosureIndicatorAngle : 0.0;
    if (self.disclosureIndicatorFlipped) {
        angle += M_PI;
    }
    self.disclosureIndicatorView.transform = CGAffineTransformMakeRotation(angle);
    self.backgroundColor = selected ? self.selectedBackgroundColor : nil;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.disclosureIndicatorView.hidden = !enabled;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *targetView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point) && ![targetView isKindOfClass:[UIControl class]]) {
        return self;
    }
    return targetView;
}

@end
