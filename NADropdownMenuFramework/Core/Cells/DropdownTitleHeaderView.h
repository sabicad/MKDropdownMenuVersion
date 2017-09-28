//
//  DropdownTitleHeaderView.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownTitleHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundCellView;
@property (weak, nonatomic) IBOutlet UIView *separator;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;

@end
