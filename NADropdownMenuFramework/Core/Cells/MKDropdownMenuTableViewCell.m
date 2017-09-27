//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "MKDropdownMenuTableViewCell.h"

@implementation MKDropdownMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)setup {
    self.clipsToBounds = YES;
    
    _containerView = [UIView new];
    _containerView.frame = self.contentView.bounds;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _containerView.userInteractionEnabled = YES;
    [self.contentView addSubview:_containerView];
}

- (UIView *)currentCustomView {
    return self.containerView.subviews.lastObject;
}

- (void)setCustomView:(UIView *)customView {
    if (customView == nil) {
        [self.currentCustomView removeFromSuperview];
        self.containerView.hidden = YES;
    } else if (self.currentCustomView != customView) {
        [self.currentCustomView removeFromSuperview];
        customView.frame = self.containerView.bounds;
        customView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:customView];
    }
    self.containerView.hidden = NO;
    [self setAttributedTitle:nil];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.textLabel.attributedText = attributedTitle;
}

- (void)setHighlightColor:(UIColor *)color {
    if (color != nil) {
        UIView *selectionView = [UIView new];
        selectionView.backgroundColor = color;
        self.selectedBackgroundView = selectionView;
    } else {
        self.selectedBackgroundView = nil;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.currentCustomView removeFromSuperview];
    self.containerView.hidden = YES;
}

@end
