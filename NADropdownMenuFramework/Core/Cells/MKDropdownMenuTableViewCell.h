//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@interface MKDropdownMenuTableViewCell : UITableViewCell

@property (readonly, nonatomic) UIView *containerView;
@property (readonly, nonatomic) UIView *currentCustomView;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setCustomView:(UIView *)customView;
- (void)setHighlightColor:(UIColor *)color;

@end

