//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#pragma mark - Content Controller -

#import "MKDropdownMenuContentViewController.h"
#import "UIColor+MKDropdownMenu.h"
#import "MKDropdownMenuTableViewCell.h"
#import "TitleSubtitleSelectableCell.h"

static const CGFloat kDefaultRowHeight = 44;
static const CGFloat kDefaultCornerRadius = 2;
static const CGFloat kDefaultBackgroundDimmingOpacity = 0.2;
static const CGFloat kShadowOpacity = 0.2;
static NSString * const kCellIdentifier = @"cell";

@implementation MKDropdownMenuContentViewController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.presentingViewController.preferredStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kDefaultBackgroundDimmingOpacity];
    self.view.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _textAlignment = NSTextAlignmentLeft;
    
    /* Setup Views */
    
    // Container View
    
    self.containerView = [UIView new];
    self.containerView.clipsToBounds = NO;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Table Container View
    
    self.tableContainerView = [UIView new];
    self.tableContainerView.clipsToBounds = YES;
    self.tableContainerView.backgroundColor = [UIColor blackColor];
    self.tableContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.tableContainerView.bounds;
    mask.fillColor = [[UIColor whiteColor] CGColor];
    self.tableContainerView.layer.mask = mask;
    self.cornerRadius = kDefaultCornerRadius;
    
    // Table View
    
    self.tableView = [UITableView new];
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = kDefaultRowHeight;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor mk_defaultSeparatorColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.showsTopRowSeparator = YES;
    self.showsBottomRowSeparator = YES;
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"TitleSubtitleSelectableCell" bundle:frameworkBundle];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TitleSubtitleSelectableCell"];
    [self.tableView registerClass:[MKDropdownMenuTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:@"DropdownTitleHeaderView" bundle:frameworkBundle];
    [self.tableView registerNib:headerNib forCellReuseIdentifier:@"DropdownTitleHeaderView"];
    
    // Shadow
    
    self.shadowView = [UIView new];
    self.shadowView.clipsToBounds = NO;
    self.shadowView.backgroundColor = [UIColor clearColor];
    self.shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowView.layer.shadowOpacity = kShadowOpacity;
    self.shadowView.layer.shadowRadius = kDefaultCornerRadius;
    
    // Separator
    
    self.separatorContainerView = [UIView new];
    self.separatorContainerView.clipsToBounds = NO;
    self.separatorContainerView.backgroundColor = [UIColor clearColor];
    self.separatorContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Border
    
    self.borderView = [UIView new];
    self.borderView.backgroundColor = [UIColor clearColor];
    self.borderView.userInteractionEnabled = NO;
    self.borderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.borderLayer = [CAShapeLayer layer];
    self.borderLayer.frame = self.tableContainerView.bounds;
    self.borderLayer.fillColor = [[UIColor clearColor] CGColor];
    self.borderLayer.strokeColor = [[UIColor mk_defaultSeparatorColor] CGColor];
    self.borderLayer.lineWidth = 1;
    
    [self.borderView.layer addSublayer:self.borderLayer];
    
    self.borderView.hidden = YES;
    
    /* Add subviews */
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.shadowView];
    [self.containerView addSubview:self.borderView];
    [self.containerView addSubview:self.separatorContainerView];
    [self.containerView addSubview:self.tableContainerView];
    [self.tableContainerView addSubview:self.tableView];
    
    /* Setup constraints */
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self.tableContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kDefaultRowHeight];
    [self.tableContainerView addConstraint:_heightConstraint];
    
    _leftConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    _rightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    
    [self.view addConstraints:@[_leftConstraint, _rightConstraint,
                                [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]];
    
    _topConstraint = [NSLayoutConstraint constraintWithItem:self.separatorContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
    [self.separatorContainerView addConstraint:_topConstraint];
    
    [self.containerView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.separatorContainerView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.containerView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.containerView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.separatorContainerView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0.0]]];
    
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:kNilOptions metrics:nil views:@{@"v": self.tableContainerView}]];
    
    _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraint:_bottomConstraint];
    _bottomConstraint.active = NO;
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[s][v]|" options:kNilOptions metrics:nil views:@{@"s": self.separatorContainerView, @"v": self.tableContainerView}]];
    
    [self.tableContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:kNilOptions metrics:nil views:@{@"v": self.tableView}]];
    [self.tableContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:kNilOptions metrics:nil views:@{@"v": self.tableView}]];
    
    [self.containerView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.shadowView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.shadowView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.shadowView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.shadowView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0.0]]];
    
    [self.containerView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.borderView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.borderView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.borderView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0.0],
                                         [NSLayoutConstraint constraintWithItem:self.tableContainerView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.borderView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0.0]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateContainerHeight];
    [self updateShadow];
    [self updateMask];
}

- (void)updateShadow {
    UIBezierPath *shadowPath = [UIBezierPath new];
    CGRect bounds = self.shadowView.bounds;
    CGPoint p0 = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGPoint p1 = CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds));
    CGPoint p2 = CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
    CGPoint p3 = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
    CGPoint p4 = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    [shadowPath moveToPoint:p0];
    if (self.showAbove) {
        [shadowPath addLineToPoint:p3];
        [shadowPath addLineToPoint:p4];
        [shadowPath addLineToPoint:p1];
        [shadowPath addLineToPoint:p2];
    } else {
        [shadowPath addLineToPoint:p1];
        [shadowPath addLineToPoint:p2];
        [shadowPath addLineToPoint:p3];
        [shadowPath addLineToPoint:p4];
    }
    [shadowPath closePath];
    self.shadowView.layer.shadowPath = shadowPath.CGPath;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, self.showAbove ? -1 : 1);
}

- (void)updateMask {
    if (!_didSetRoundedCorners) {
        // Set rounded corners automatically if not overriden
        _roundedCorners = self.showAbove
        ? UIRectCornerTopLeft|UIRectCornerTopRight
        : UIRectCornerBottomLeft|UIRectCornerBottomRight;
    }
    
    CGFloat r = self.cornerRadius;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tableContainerView.bounds
                                                   byRoundingCorners:self.roundedCorners
                                                         cornerRadii:CGSizeMake(r, r)];
    CAShapeLayer *mask = (CAShapeLayer *)self.tableContainerView.layer.mask;
    mask.path = maskPath.CGPath;
    self.shadowView.layer.shadowRadius = MAX(r, kDefaultCornerRadius);
    
    self.borderLayer.path = maskPath.CGPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
    self.tableView.contentOffset = CGPointZero;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate willDisappear];
}

- (void)updateData {
    self.rowsCount = [self.delegate numberOfRows];
    self.maxRows = [self.delegate maximumNumberOfRows];
    [self updateContainerHeight];
    [self.tableView reloadData];
}

- (void)updateDataAtIndexes:(NSIndexSet *)indexes {
    NSMutableArray *indexPaths = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateContainerHeight {
    _heightConstraint.constant = self.contentHeight;
    [self.containerView layoutIfNeeded];
}

- (CGFloat)maxHeight {
    NSInteger limit = (self.maxRows > 0) ? self.maxRows : NSIntegerMax;
    limit = MIN(limit, self.view.bounds.size.height / self.tableView.rowHeight);
    return limit * self.tableView.rowHeight;
}

- (CGFloat)contentHeight {
    return MIN(MAX(self.rowsCount * self.tableView.rowHeight, 0), self.maxHeight) + [self.delegate heightForHeader] + [self.delegate heightForFooter];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _leftConstraint.active = NO;
    _rightConstraint.active = NO;
    _leftConstraint.constant = contentInset.left;
    _rightConstraint.constant = contentInset.right;
    _leftConstraint.active = YES;
    _rightConstraint.active = YES;
    [self.view layoutIfNeeded];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(_topConstraint.constant, _leftConstraint.constant, 0, _rightConstraint.constant);
}

- (void)insertSeparatorView:(UIView *)separator {
    [self.separatorContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    if (separator != nil) {
        height = separator.frame.size.height;
        separator.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        separator.frame = self.separatorContainerView.bounds;
        [self.separatorContainerView addSubview:separator];
    }
    
    _topConstraint.constant = height;
    
    [self updateSeparatorViewOffset];
}

- (void)updateSeparatorViewOffset {
    for (UIView *separator in self.separatorContainerView.subviews) {
        separator.frame = CGRectOffset(self.separatorContainerView.bounds,
                                       self.separatorViewOffset.horizontal, self.separatorViewOffset.vertical);
    }
}

- (void)setSeparatorViewOffset:(UIOffset)separatorViewOffset {
    _separatorViewOffset = separatorViewOffset;
    [self updateSeparatorViewOffset];
}

- (void)setShowsTopRowSeparator:(BOOL)showsTopRowSeparator {
    
}

- (BOOL)showsTopRowSeparator {
    return YES;
}

- (void)setShowsBottomRowSeparator:(BOOL)showsBottomRowSeparator {
    
}

- (BOOL)showsBottomRowSeparator {
    return YES;
}

- (void)setShowsBorder:(BOOL)showsBorder {
    self.borderView.hidden = !showsBorder;
}

- (BOOL)showsBorder {
    return !self.borderView.hidden;
}

- (void)setRoundedCorners:(UIRectCorner)roundedCorners {
    _roundedCorners = roundedCorners;
    _didSetRoundedCorners = YES;
}

- (void)setShowAbove:(BOOL)showAbove {
    _showAbove = showAbove;
    if (showAbove) {
        _topConstraint.active = NO;
        _bottomConstraint.active = YES;
    } else {
        _bottomConstraint.active = NO;
        _topConstraint.active = YES;
    }
}

#pragma mark - Gestures

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate didSelectRow:NSNotFound];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleSubtitleSelectableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleSubtitleSelectableCell" forIndexPath:indexPath];

    NSAttributedString *attributedTitle = [self.delegate attributedTitleForRow:indexPath.row];
    [cell setAttributedTitle:attributedTitle];
    
    [cell setHighlightColor:self.highlightColor];
    
    cell.backgroundColor = [self.delegate backgroundColorForRow:indexPath.row];
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didDeselectRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.delegate heightForHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.delegate heightForFooter];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DropdownTitleHeaderView"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DropdownTitleHeaderView"];
}

@end
