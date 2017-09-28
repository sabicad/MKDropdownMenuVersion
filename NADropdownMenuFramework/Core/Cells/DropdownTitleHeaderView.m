//
//  DropdownTitleHeaderView.m
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "DropdownTitleHeaderView.h"

@implementation DropdownTitleHeaderView

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.headerTextLabel.attributedText = attributedTitle;
}

@end
