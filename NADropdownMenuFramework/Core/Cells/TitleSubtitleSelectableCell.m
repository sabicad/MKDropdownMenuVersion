//
//  TableViewCell.m
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "TitleSubtitleSelectableCell.h"

@interface TitleSubtitleSelectableCell ()

@property (strong, nonatomic) DropdownCell* model;

@end

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

- (void)fillWithModel:(DropdownCell *)model config:(DropdownConfig *)config hideSeparator:(BOOL)value {
    NSAttributedString *attrTitle = nil;
    NSAttributedString *attrDescription = nil;
    
    self.model = model;
    
    if (model) {
        NSDictionary *attrTitleDict = @{NSFontAttributeName: model.titleFont,
                                        NSForegroundColorAttributeName: model.titleColor};
        NSDictionary *attrDescriptionDict = @{NSFontAttributeName: model.descriptionFont,
                                              NSForegroundColorAttributeName: model.descriptionColor};
        
        attrTitle = [[NSAttributedString alloc] initWithString:model.title attributes:attrTitleDict];
        attrDescription = [[NSAttributedString alloc] initWithString:model.descriptionText attributes:attrDescriptionDict];
    }
    
    [self setAttributedTitle:attrTitle];
    [self setAttributedDescription:attrDescription];
    
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
    NSAttributedString *attrStringSubTitle = self.descriptionTextLabel.attributedText;
    
    CGFloat maximumWidth = width - 70.0;
    
    CGRect rectTitle = [attrStringTitle boundingRectWithSize:CGSizeMake(maximumWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGRect rectSubtitle = [attrStringSubTitle boundingRectWithSize:CGSizeMake(maximumWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rectTitle.size.height + rectSubtitle.size.height + 6.0 + 40.0;
}

@end
