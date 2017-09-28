//
//  DropdownTitleHeaderView.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonHandlerBlock)(void);

@protocol DropdownButtonFooterViewDelegate <NSObject>

- (void)dropdownButtonFooterViewDelegateCancelAction;

@end

@interface DropdownButtonFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) id<DropdownButtonFooterViewDelegate> delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundCellView;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (nonatomic, strong) ButtonHandlerBlock tapHandler;

@end
