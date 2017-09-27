/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Max Konovalov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "MKDropdownMenu.h"
#import "MKDropdownMenuContentViewController.h"
#import "MKDropdownMenuTransition.h"
#import "MKDropdownMenuComponentButton.h"
#import "MKDropdownMenuTableViewCell.h"
#import "UIColor+MKDropdownMenu.h"

#pragma mark - Constants -

static const NSTimeInterval kAnimationDuration = 0.25;
static const CGFloat kDefaultRowHeight = 44;
static NSString * const kCellIdentifier = @"cell";

@interface MKDropdownMenu () <MKDropdownMenuContentViewControllerDelegate>

@property (strong, nonatomic) MKDropdownMenuTransition *transition;

@property (strong, nonatomic) MKDropdownMenuContentViewController *contentViewController;
@property (strong, nonatomic) NSMutableArray<MKDropdownMenuComponentButton *> *buttons;
@property (strong, nonatomic) NSMutableArray<UIView *> *separators;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *components;
@property (assign, nonatomic) NSInteger selectedComponent;
@property (strong, nonatomic) NSMutableArray<NSMutableIndexSet *> *selectedRows;

@end

@implementation MKDropdownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentViewController = [MKDropdownMenuContentViewController new];
    self.contentViewController.delegate = self;
    
    // load content view
    [self.contentViewController view];
    
    self.transition = [[MKDropdownMenuTransition alloc] initWithDropdownMenu:self
                                                       contentViewController:self.contentViewController];
    
    _selectedComponent = NSNotFound;
    
    _componentLineBreakMode = NSLineBreakByTruncatingMiddle;
    _componentTextAlignment = NSTextAlignmentCenter;
    
    _adjustsContentInset = YES;
    _adjustsContentOffset = NO;
    
    _disclosureIndicatorSelectionRotation = M_PI;
    
    self.components = [NSMutableArray new];
    self.selectedRows = [NSMutableArray new];
    self.buttons = [NSMutableArray new];
    self.separators = [NSMutableArray new];
}

- (void)setupComponents {
    if (self.dataSource == nil) {
        return;
    }
    
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfComponentsInDropdownMenu:)], @"required method `numberOfComponentsInDropdownMenu:` in data source not implemented");
    
    NSInteger numberOfComponents = [self.dataSource numberOfComponentsInDropdownMenu:self];
    
    [self.components removeAllObjects];
    [self.selectedRows removeAllObjects];
    
    NSAssert([self.dataSource respondsToSelector:@selector(dropdownMenu:numberOfRowsInComponent:)], @"required method `dropdownMenu:numberOfRowsInComponent:` in data source not implemented");
    
    for (NSInteger i = 0; i < numberOfComponents; i++) {
        NSInteger numberOfRows = [self.dataSource dropdownMenu:self numberOfRowsInComponent:i];
        [self.components addObject:@(numberOfRows)];
        [self.selectedRows addObject:[NSMutableIndexSet new]];
        if (self.buttons.count <= i) {
            MKDropdownMenuComponentButton *button = [MKDropdownMenuComponentButton new];
            [self.buttons addObject:button];
            [self addSubview:button];
            [button addTarget:self action:@selector(selectedComponent:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i < numberOfComponents - 1 && self.separators.count <= i) {
            UIView *separator = [UIView new];
            [self.separators addObject:separator];
            [self addSubview:separator];
        }
    }
    while (self.buttons.count > numberOfComponents) {
        MKDropdownMenuComponentButton *button = self.buttons.lastObject;
        [button removeFromSuperview];
        [self.buttons removeLastObject];
    }
    while (self.separators.count > numberOfComponents - 1) {
        UIView *separator = self.separators.lastObject;
        [separator removeFromSuperview];
        [self.separators removeLastObject];
    }
}

- (void)updateComponentButtons {
    [self.buttons enumerateObjectsUsingBlock:^(MKDropdownMenuComponentButton *btn, NSUInteger idx, BOOL *stop) {
        [self updateButton:btn forComponent:idx];
    }];
    [self updateComponentSeparators];
}

- (void)updateButton:(MKDropdownMenuComponentButton *)button forComponent:(NSInteger)component {
    BOOL enabled = YES;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:enableComponent:)]) {
        enabled = [self.delegate dropdownMenu:self enableComponent:component];
    }
    [button setEnabled:enabled];
    
    button.titleLabel.lineBreakMode = self.componentLineBreakMode;
    switch (self.componentLineBreakMode) {
        case NSLineBreakByCharWrapping:
        case NSLineBreakByWordWrapping:
            button.titleLabel.numberOfLines = 0;
            break;
        default:
            button.titleLabel.numberOfLines = 1;
            break;
    }
    
    [button setTextAlignment:self.componentTextAlignment];
    [button setDisclosureIndicatorImage:self.disclosureIndicatorImage];
    [button setSelectedBackgroundColor:self.selectedComponentBackgroundColor];
    [button setDisclosureIndicatorAngle:self.disclosureIndicatorSelectionRotation];
    [button setDisclosureIndicatorFlipped:self.dropdownShowsContentAbove];
    
    UIView *customView = button.currentCustomView;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:viewForComponent:)]) {
        customView = [self.delegate dropdownMenu:self viewForComponent:component];
    }
    
    if (customView != nil) {
        [button setCustomView:customView];
    } else {
        NSAttributedString *attributedTitle = nil;
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:attributedTitleForComponent:)]) {
            attributedTitle = [self.delegate dropdownMenu:self attributedTitleForComponent:component];
        }
        
        if (attributedTitle == nil && [self.delegate respondsToSelector:@selector(dropdownMenu:titleForComponent:)]) {
            NSString *title = [self.delegate dropdownMenu:self titleForComponent:component];
            if (title != nil) {
                attributedTitle = [[NSAttributedString alloc] initWithString:title];
            }
        }
        
        NSAttributedString *attributedSelectedTitle = nil;
        
        if (attributedTitle != nil) {
            if ([self.delegate respondsToSelector:@selector(dropdownMenu:attributedTitleForSelectedComponent:)]) {
                attributedSelectedTitle = [self.delegate dropdownMenu:self attributedTitleForSelectedComponent:component];
            }
            
            if (attributedSelectedTitle == nil && [self.delegate respondsToSelector:@selector(dropdownMenu:titleForSelectedComponent:)]) {
                NSString *selectedTitle = [self.delegate dropdownMenu:self titleForSelectedComponent:component];
                if (selectedTitle != nil) {
                    attributedSelectedTitle = [[NSAttributedString alloc] initWithString:selectedTitle];
                }
            }
        }
        
        [button setAttributedTitle:attributedTitle selectedTitle:attributedSelectedTitle];
    }
}

- (void)updateComponentSeparators {
    UIColor *separatorColor = self.componentSeparatorColor
    ? self.componentSeparatorColor : [UIColor mk_defaultSeparatorColor];
    
    [self.separators enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.backgroundColor = separatorColor;
        [self bringSubviewToFront:obj];
    }];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window != nil) {
        [self reloadAllComponents];
    }
}

- (void)setDataSource:(id<MKDropdownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.window != nil) {
        [self reloadAllComponents];
    }
}

- (void)layoutComponentButtons {
    if (self.buttons.count == 0) {
        return;
    }
    
    CGFloat totalCustomWidth = 0;
    NSInteger customWidthsCount = 0;
    
    NSMutableArray *widths = [NSMutableArray new];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:widthForComponent:)]) {
        for (NSInteger i = 0; i < self.buttons.count; i++) {
            CGFloat width = [self.delegate dropdownMenu:self widthForComponent:i];
            [widths addObject:@(width)];
            if (width > 0) {
                totalCustomWidth += width;
                customWidthsCount++;
            }
        }
    }
    
    CGFloat defaultWidth = self.bounds.size.width / self.buttons.count;
    if (customWidthsCount > 0 && self.buttons.count > customWidthsCount) {
        defaultWidth = (self.bounds.size.width - totalCustomWidth) / (self.buttons.count - customWidthsCount);
    }
    
    NSAssert(totalCustomWidth <= self.bounds.size.width, @"total width for components (%.1f) must not be greater than view bounds width (%.1f)", totalCustomWidth, self.bounds.size.width);
    
    __block CGFloat dx = 0;
    [self.buttons enumerateObjectsUsingBlock:^(MKDropdownMenuComponentButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat width = 0;
        if (idx == self.buttons.count - 1) {
            width = self.bounds.size.width - dx;
        } else {
            if (idx < widths.count) {
                width = [widths[idx] floatValue];
            }
        }
        if (width <= 0) {
            width = defaultWidth;
        }
        btn.frame = CGRectMake(dx, 0, width, self.bounds.size.height);
        dx += width;
    }];
}

- (void)layoutComponentSeparators {
    [self.separators enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        CGRect btnFrame = self.buttons[idx].frame;
        obj.frame = CGRectMake(CGRectGetMaxX(btnFrame) - 0.25, CGRectGetMinY(btnFrame), 0.5, CGRectGetHeight(btnFrame));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutComponentButtons];
    [self layoutComponentSeparators];
    
    if (self.selectedComponent != NSNotFound) {
        self.contentViewController.contentInset = [self contentInsetForSelectedComponent];
    }
}

#pragma mark - Properties

- (void)setDropdownDropsShadow:(BOOL)dropdownDropsShadow {
    self.contentViewController.shadowView.hidden = !dropdownDropsShadow;
    self.contentViewController.tableContainerView.backgroundColor = dropdownDropsShadow ? [UIColor blackColor] : [UIColor clearColor];
}

- (BOOL)dropdownDropsShadow {
    return !self.contentViewController.shadowView.hidden;
}

- (void)setDropdownBouncesScroll:(BOOL)dropdownBouncesScroll {
    self.contentViewController.tableView.bounces = dropdownBouncesScroll;
}

- (BOOL)dropdownBouncesScroll {
    return self.contentViewController.tableView.bounces;
}

- (void)setDropdownShowsTopRowSeparator:(BOOL)dropdownShowsTopRowSeparator {
    self.contentViewController.showsTopRowSeparator = dropdownShowsTopRowSeparator;
}

- (BOOL)dropdownShowsTopRowSeparator {
    return self.contentViewController.showsTopRowSeparator;
}

- (void)setDropdownShowsBottomRowSeparator:(BOOL)dropdownShowsBottomRowSeparator {
    self.contentViewController.showsBottomRowSeparator = dropdownShowsBottomRowSeparator;
}

- (BOOL)dropdownShowsBottomRowSeparator {
    return self.contentViewController.showsBottomRowSeparator;
}

- (void)setDropdownShowsBorder:(BOOL)dropdownShowsBorder {
    self.contentViewController.showsBorder = dropdownShowsBorder;
}

- (BOOL)dropdownShowsBorder {
    return self.contentViewController.showsBorder;
}

- (void)setDropdownShowsContentAbove:(BOOL)dropdownShowsContentAbove {
    self.contentViewController.showAbove = dropdownShowsContentAbove;
}

- (BOOL)dropdownShowsContentAbove {
    return self.contentViewController.showAbove;
}

- (void)setBackgroundDimmingOpacity:(CGFloat)backgroundDimmingOpacity {
    self.contentViewController.view.backgroundColor = [UIColor colorWithWhite:(backgroundDimmingOpacity < 0 ? 1.0 : 0.0)
                                                                        alpha:fabs(backgroundDimmingOpacity)];
}

- (CGFloat)backgroundDimmingOpacity {
    CGFloat white = 0.0;
    CGFloat alpha = 0.0;
    [self.contentViewController.view.backgroundColor getWhite:&white alpha:&alpha];
    return (white == 1.0 ? -alpha : alpha);
}

- (void)setComponentSeparatorColor:(UIColor *)componentSeparatorColor {
    _componentSeparatorColor = componentSeparatorColor;
    [self updateComponentSeparators];
}

- (void)setRowSeparatorColor:(UIColor *)rowSeparatorColor {
    _rowSeparatorColor = rowSeparatorColor;
    UIColor *separatorColor = rowSeparatorColor ? rowSeparatorColor : [UIColor mk_defaultSeparatorColor];
    self.contentViewController.tableView.separatorColor = separatorColor;
    self.contentViewController.tableView.tableHeaderView.backgroundColor = separatorColor;
    self.contentViewController.borderLayer.strokeColor = separatorColor.CGColor;
}

- (void)setSpacerView:(UIView *)spacerView {
    _spacerView = spacerView;
    [self.contentViewController insertSeparatorView:spacerView];
}

- (void)setSpacerViewOffset:(UIOffset)spacerViewOffset {
    self.contentViewController.separatorViewOffset = spacerViewOffset;
}

- (UIOffset)spacerViewOffset {
    return self.contentViewController.separatorViewOffset;
}

- (void)setComponentLineBreakMode:(NSLineBreakMode)componentLineBreakMode {
    _componentLineBreakMode = componentLineBreakMode;
    [self updateComponentButtons];
}

- (void)setComponentTextAlignment:(NSTextAlignment)componentTextAlignment {
    _componentTextAlignment = componentTextAlignment;
    [self updateComponentButtons];
}

- (void)setRowTextAlignment:(NSTextAlignment)rowTextAlignment {
    self.contentViewController.textAlignment = rowTextAlignment;
    [self.contentViewController updateData];
}

- (NSTextAlignment)rowTextAlignment {
    return self.contentViewController.textAlignment;
}

- (void)setDisclosureIndicatorImage:(UIImage *)disclosureIndicatorImage {
    _disclosureIndicatorImage = disclosureIndicatorImage;
    [self updateComponentButtons];
}

- (void)setDisclosureIndicatorSelectionRotation:(CGFloat)disclosureIndicatorSelectionRotation {
    _disclosureIndicatorSelectionRotation = disclosureIndicatorSelectionRotation;
    [self updateComponentButtons];
}

- (void)setDropdownBackgroundColor:(UIColor *)dropdownBackgroundColor {
    self.contentViewController.tableView.backgroundColor = dropdownBackgroundColor;
}

- (UIColor *)dropdownBackgroundColor {
    return self.contentViewController.tableView.backgroundColor;
}

- (void)setSelectedComponentBackgroundColor:(UIColor *)selectedComponentBackgroundColor {
    _selectedComponentBackgroundColor = selectedComponentBackgroundColor;
    [self updateComponentButtons];
}

- (void)setDropdownCornerRadius:(CGFloat)dropdownCornerRadius {
    self.contentViewController.cornerRadius = dropdownCornerRadius;
    [self.contentViewController updateMask];
}

- (CGFloat)dropdownCornerRadius {
    return self.contentViewController.cornerRadius;
}

- (void)setDropdownRoundedCorners:(UIRectCorner)dropdownRoundedCorners {
    self.contentViewController.roundedCorners = dropdownRoundedCorners;
    [self.contentViewController updateMask];
}

- (UIRectCorner)dropdownRoundedCorners {
    return self.contentViewController.roundedCorners;
}

#pragma mark - Public Methods

- (NSInteger)numberOfComponents {
    return self.components.count;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    return [self.components[component] integerValue];
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.selectedComponent == NSNotFound || component != self.selectedComponent) {
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if ([[self.contentViewController.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
        MKDropdownMenuTableViewCell *cell = [self.contentViewController.tableView cellForRowAtIndexPath:indexPath];
        return cell.currentCustomView;
    }
    return nil;
}

- (void)reloadAllComponents {
    [self setupComponents];
    [self updateComponentButtons];
    [self setNeedsLayout];
    [self.contentViewController updateData];
}

- (void)reloadComponent:(NSInteger)component {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    
    NSAssert([self.dataSource respondsToSelector:@selector(dropdownMenu:numberOfRowsInComponent:)], @"required method `dropdownMenu:numberOfRowsInComponent:` in data source not implemented");
    
    NSInteger numberOfRows = [self.dataSource dropdownMenu:self numberOfRowsInComponent:component];
    self.components[component] = @(numberOfRows);
    
    [self updateButton:self.buttons[component] forComponent:component];
    
    if (self.selectedComponent != NSNotFound && component == self.selectedComponent) {
        [self.contentViewController updateData];
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    NSAssert(row >= 0 && row < [self.components[component] integerValue], @"invalid row: %zd", row);
    
    NSMutableIndexSet *indexesToUpdate = [NSMutableIndexSet new];
    
    if (!self.allowsMultipleRowsSelection) {
        [self.selectedRows[component] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [indexesToUpdate addIndex:idx];
        }];
        [self.selectedRows[component] removeAllIndexes];
    }
    
    [self.selectedRows[component] addIndex:row];
    [indexesToUpdate addIndex:row];
    
    if (component == self.selectedComponent) {
        [self.contentViewController updateDataAtIndexes:indexesToUpdate];
    }
}

- (void)deselectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    NSAssert(row >= 0 && row < [self.components[component] integerValue], @"invalid row: %zd", row);
    
    [self.selectedRows[component] removeIndex:row];
    
    if (component == self.selectedComponent) {
        [self.contentViewController updateDataAtIndexes:[NSIndexSet indexSetWithIndex:row]];
    }
}

- (NSIndexSet *)selectedRowsInComponent:(NSInteger)component {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    return [self.selectedRows[component] copy];
}

- (void)openComponent:(NSInteger)component animated:(BOOL)animated {
    NSAssert(component >= 0 && component < self.components.count, @"invalid component: %zd", component);
    
    NSInteger previousComponent = self.selectedComponent;
    
    void (^presentation)(void) = ^{
        self.selectedComponent = component;
        [self presentDropdownForSelectedComponentAnimated:animated completion:nil];
        if (component != NSNotFound && [self.delegate respondsToSelector:@selector(dropdownMenu:didOpenComponent:)]) {
            [self.delegate dropdownMenu:self didOpenComponent:component];
        }
    };
    
    if (previousComponent != NSNotFound) {
        [self dismissDropdownAnimated:animated completion:^{
            presentation();
        }];
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didCloseComponent:)]) {
            [self.delegate dropdownMenu:self didCloseComponent:previousComponent];
        }
    } else {
        presentation();
    }
}

- (void)closeAllComponentsAnimated:(BOOL)animated {
    [self dismissDropdownAnimated:animated completion:nil];
    [self cleanupSelectedComponents];
}

- (void)bringDropdownViewToFront {
    [self.contentViewController.view.superview bringSubviewToFront:self.contentViewController.view];
}

#pragma mark - Private

- (void)selectedComponent:(MKDropdownMenuComponentButton *)sender {
    if (self.transition.isAnimating) {
        return;
    }
    if (sender == nil) {
        [self closeAllComponentsAnimated:YES];
    } else {
        NSInteger selectedIndex = [self.buttons indexOfObject:sender];
        if (selectedIndex == self.selectedComponent) {
            [self closeAllComponentsAnimated:YES];
        } else {
            [self openComponent:selectedIndex animated:YES];
        }
    }
}

- (UIEdgeInsets)contentInsetForSelectedComponent {
    if (self.selectedComponent == NSNotFound) {
        return UIEdgeInsetsZero;
    }
    
    UIView *presentingView = [self containerView];
    
    BOOL fullWidth = YES;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:shouldUseFullRowWidthForComponent:)]) {
        fullWidth = [self.delegate dropdownMenu:self shouldUseFullRowWidthForComponent:self.selectedComponent];
    }
    
    // L/R + Width
    CGFloat left = 0;
    CGFloat right = 0;
    
    if (fullWidth && self.useFullScreenWidth) {
        left = CGRectGetMinX(presentingView.bounds) + self.fullScreenInsetLeft;
        right = CGRectGetMaxX(presentingView.bounds) - self.fullScreenInsetRight;
    } else if (fullWidth) {
        CGRect leftButtonFrame = [presentingView convertRect:self.buttons.firstObject.frame fromView:self];
        CGRect rightButtonFrame = [presentingView convertRect:self.buttons.lastObject.frame fromView:self];
        left = CGRectGetMinX(leftButtonFrame);
        right = CGRectGetMaxX(rightButtonFrame);
    } else {
        CGRect buttonFrame = [presentingView convertRect:self.buttons[self.selectedComponent].frame fromView:self];
        left = CGRectGetMinX(buttonFrame);
        right = CGRectGetMaxX(buttonFrame);
    }
    
    return UIEdgeInsetsMake(0, left, 0, CGRectGetWidth(presentingView.bounds) - right + 0.5);
}

- (void)cleanupSelectedComponents {
    NSInteger previousComponent = self.selectedComponent;
    self.selectedComponent = NSNotFound;
    if (previousComponent != NSNotFound && [self.delegate respondsToSelector:@selector(dropdownMenu:didCloseComponent:)]) {
        [self.delegate dropdownMenu:self didCloseComponent:previousComponent];
    }
}

- (void)updateComponentButtonsSelection:(BOOL)selected {
    void (^animation)(void) = ^{
        if (selected && self.selectedComponent != NSNotFound) {
            [self.buttons[self.selectedComponent] setSelected:YES];
        } else {
            [self.buttons enumerateObjectsUsingBlock:^(MKDropdownMenuComponentButton *btn, NSUInteger idx, BOOL *stop) {
                [btn setSelected:NO];
            }];
        }
    };
    
    if (self.contentViewController.transitionCoordinator != nil) {
        [self.contentViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            animation();
        } completion:nil];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            animation();
        }];
    }
}

#pragma mark - Dropdown Presenting & Dismissing

- (UIView *)containerView {
    return self.presentingView ?: self.window;
}

- (void)presentDropdownForSelectedComponentAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.selectedComponent == NSNotFound) {
        if (completion) {
            completion();
        }
        return;
    }
    
    UIView *presentingView = [self containerView];
    
    self.contentViewController.contentInset = [self contentInsetForSelectedComponent];
    
    CGFloat rowHeight = 0;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:rowHeightForComponent:)]) {
        rowHeight = [self.delegate dropdownMenu:self rowHeightForComponent:self.selectedComponent];
    }
    self.contentViewController.tableView.rowHeight = (rowHeight > 0) ? rowHeight : kDefaultRowHeight;
    
    UIColor *highlightColor = nil;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:backgroundColorForHighlightedRowsInComponent:)]) {
        highlightColor = [self.delegate dropdownMenu:self backgroundColorForHighlightedRowsInComponent:self.selectedComponent];
    }
    self.contentViewController.highlightColor = highlightColor;
    
    [self.transition presentDropdownInContainerView:presentingView animated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
    
    [self updateComponentButtonsSelection:YES];
}

- (void)dismissDropdownAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.contentViewController.view.window == nil) {
        if (completion) {
            completion();
        }
        return;
    }
    
    [self.transition dismissDropdownAnimated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
    
    [self updateComponentButtonsSelection:NO];
}

#pragma mark - DropdownMenuContentViewControllerDelegate

- (CGFloat)heightForHeader {
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:headerHeightForComponent:)]) {
        return [self.delegate dropdownMenu:self headerHeightForComponent:self.selectedComponent];
    }
    
    return 0.1;
}

- (CGFloat)heightForFooter {
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:footerHeightForComponent:)]) {
        return [self.delegate dropdownMenu:self footerHeightForComponent:self.selectedComponent];
    }
    
    return 0.1;
}

- (NSInteger)numberOfRows {
    if (self.selectedComponent == NSNotFound) {
        return 0;
    }
    return [self numberOfRowsInComponent:self.selectedComponent];
}

- (NSInteger)maximumNumberOfRows {
    if (self.selectedComponent == NSNotFound) {
        return 0;
    }
    
    NSInteger maxRows = 0;
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:maximumNumberOfRowsInComponent:)]) {
        maxRows = [self.delegate dropdownMenu:self maximumNumberOfRowsInComponent:self.selectedComponent];
    }
    
    return MAX(0, maxRows);
}

- (NSAttributedString *)attributedTitleForRow:(NSInteger)row {
    NSAttributedString *attributedTitle = nil;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:attributedTitleForRow:forComponent:)]) {
        attributedTitle = [self.delegate dropdownMenu:self attributedTitleForRow:row forComponent:self.selectedComponent];
    }
    
    if (attributedTitle == nil && [self.delegate respondsToSelector:@selector(dropdownMenu:titleForRow:forComponent:)]) {
        NSString *title = [self.delegate dropdownMenu:self titleForRow:row forComponent:self.selectedComponent];
        if (title != nil) {
            attributedTitle = [[NSAttributedString alloc] initWithString:title];
        }
    }
    
    return attributedTitle;
}

- (UIView *)customViewForRow:(NSInteger)row reusingView:(UIView *)view {
    UIView *customView = nil;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:viewForRow:forComponent:reusingView:)]) {
        customView = [self.delegate dropdownMenu:self viewForRow:row forComponent:self.selectedComponent reusingView:view];
    }
    
    return customView;
}

- (UIView *)accessoryViewForRow:(NSInteger)row {
    UIView *accessoryView = nil;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:accessoryViewForRow:forComponent:)]) {
        accessoryView = [self.delegate dropdownMenu:self accessoryViewForRow:row forComponent:self.selectedComponent];
    }
    
    return accessoryView;
}

- (UIColor *)backgroundColorForRow:(NSInteger)row {
    UIColor *backgroundColor = nil;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:backgroundColorForRow:forComponent:)]) {
        backgroundColor = [self.delegate dropdownMenu:self backgroundColorForRow:row forComponent:self.selectedComponent];
    }
    
    if (backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
    }
    
    return backgroundColor;
}

- (void)didSelectRow:(NSInteger)row {
    if (row == NSNotFound) {
        [self selectedComponent:nil];
    } else if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectRow:inComponent:)]) {
        [self.delegate dropdownMenu:self didSelectRow:row inComponent:self.selectedComponent];
    }
}

- (void)didDeselectRow:(NSInteger)row {
    if (row == NSNotFound) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didDeselectRow:inComponent:)]) {
        [self.delegate dropdownMenu:self didDeselectRow:row inComponent:self.selectedComponent];
    }
}

- (void)willDisappear {
    if (self.selectedComponent != NSNotFound) {
        [self cleanupSelectedComponents];
        [self updateComponentButtonsSelection:NO];
    }
}

@end
