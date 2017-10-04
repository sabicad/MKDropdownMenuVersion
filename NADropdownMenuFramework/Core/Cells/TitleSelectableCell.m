//
//  TableViewCell.m
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "TitleSelectableCell.h"

@interface TitleSelectableCell ()

@property (strong, nonatomic) DropdownCell* model;

@end

@implementation TitleSelectableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.titleTextLabel.attributedText = attributedTitle;
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

- (void)fillWithModel:(DropdownCell *)model config:(DropdownConfig *)config hideSeparator:(BOOL)value {
    NSAttributedString *attrTitle = nil;
    
    self.model = model;
    
    if (model) {
        NSDictionary *attrTitleDict = @{NSFontAttributeName: model.titleFont,
                                        NSForegroundColorAttributeName: model.titleColor};
        
        attrTitle = [[NSAttributedString alloc] initWithString:model.title attributes:attrTitleDict];
    }
    
    [self setAttributedTitle:attrTitle];
    
    [self setHighlightColor:config.cellsHighlightColor];
    self.backgroundColor = config.cellsBackgroundColor;
    
    self.iconImageView.image = model.image;
    self.iconImageView.hidden = !model.isSelected;
    self.separator.backgroundColor = config.cellsSeparatorColor;
    self.tapHandler = model.tapHandler;
    self.separator.hidden = value;
    
    self.preservesSuperviewLayoutMargins = NO;
    self.layoutMargins = UIEdgeInsetsZero;
}

- (CGFloat)getHeightForWidth:(CGFloat)width {
    NSAttributedString *attrStringTitle = self.titleTextLabel.attributedText;
    
    CGFloat maximumWidth = width - 70.0;
    
    CGRect rectTitle = [attrStringTitle boundingRectWithSize:CGSizeMake(maximumWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rectTitle.size.height + 40.0;
}

@end
