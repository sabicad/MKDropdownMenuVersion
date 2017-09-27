//
//  TableViewCell.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleSubtitleSelectableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setHighlightColor:(UIColor *)color;

@end
