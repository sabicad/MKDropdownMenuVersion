//
//  TableViewCell.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonHandlerBlock)(void);

@interface TitleSubtitleSelectableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (nonatomic, strong) ButtonHandlerBlock tapHandler;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setAttributedDescription:(NSAttributedString *)attributedDescription;

- (void)setHighlightColor:(UIColor *)color;

@end
