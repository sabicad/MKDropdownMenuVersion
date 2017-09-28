//
//  TableViewCell.m
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "TitleSubtitleSelectableCell.h"

@implementation TitleSubtitleSelectableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.titleTextLabel.attributedText = attributedTitle;
}

- (void)setAttributedDescription:(NSAttributedString *)attributedDescription {
    self.descriptionTextLabel.attributedText = attributedDescription;
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

@end
