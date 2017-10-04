//
//  TableViewCell.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADropdownMenuFramework/NADropdownMenuFramework-Swift.h"

typedef void(^ButtonHandlerBlock)(void);

@interface TitleSelectableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (nonatomic, strong) ButtonHandlerBlock tapHandler;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;

- (void)setHighlightColor:(UIColor *)color;
- (void)fillWithModel:(DropdownCell *)model config:(DropdownConfig *)config hideSeparator:(BOOL)value;
- (CGFloat)getHeightForWidth:(CGFloat)width;

@end
