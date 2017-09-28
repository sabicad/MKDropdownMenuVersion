//
//  DropdownTitleHeaderView.m
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import "DropdownButtonFooterView.h"

@implementation DropdownButtonFooterView

- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dropdownButtonFooterViewDelegateCancelAction)]) {
        [self.delegate dropdownButtonFooterViewDelegateCancelAction];
    }
    self.tapHandler();
}

@end
