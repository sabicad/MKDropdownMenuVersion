//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@class MKDropdownMenuContentViewController;

@protocol MKDropdownMenuContentViewControllerDelegate <NSObject>

- (NSInteger)numberOfRows;
- (NSInteger)maximumNumberOfRows;
- (void)didSelectRow:(NSInteger)row;
- (void)didDeselectRow:(NSInteger)row;
- (void)willDisappear;
- (void)cancelButtonAction;
- (InternalTitle *)getTitleModel;
- (NSMutableArray<InternalCell *> *)getCellsModel;
- (InternalButton *)getButtonModel;
- (InternalConfig *)getConfigModel;

@end

#pragma mark Controller

@interface MKDropdownMenuContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    NSLayoutConstraint *_heightConstraint;
    NSLayoutConstraint *_topConstraint;
    NSLayoutConstraint *_leftConstraint;
    NSLayoutConstraint *_bottomConstraint;
    NSLayoutConstraint *_rightConstraint;
    BOOL _didSetRoundedCorners;
}
@property (weak, nonatomic) id<MKDropdownMenuContentViewControllerDelegate> delegate;

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) UIView *borderView;
@property (strong, nonatomic) CAShapeLayer *borderLayer;
@property (assign, nonatomic) BOOL showsBorder;
@property (assign, nonatomic) BOOL showAbove;

@property (strong, nonatomic) UIView *tableContainerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *separatorContainerView;
@property (assign, nonatomic) UIOffset separatorViewOffset;
@property (assign, nonatomic) BOOL showsTopRowSeparator;
@property (assign, nonatomic) BOOL showsBottomRowSeparator;

@property (strong, nonatomic) UIColor *highlightColor;

@property (assign, nonatomic) UIEdgeInsets contentInset;

@property (assign, nonatomic) NSTextAlignment textAlignment;

@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) UIRectCorner roundedCorners;

@property (assign, nonatomic) NSInteger rowsCount;
@property (assign, nonatomic) NSInteger maxRows;
@property (readonly, nonatomic) CGFloat maxHeight;
@property (readonly, nonatomic) CGFloat contentHeight;

- (void)insertSeparatorView:(UIView *)separator;
- (void)updateData;
- (void)updateDataAtIndexes:(NSIndexSet *)indexes;
- (void)updateMask;

@end
