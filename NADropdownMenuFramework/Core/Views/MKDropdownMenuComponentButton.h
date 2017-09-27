//
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 22.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@interface MKDropdownMenuComponentButton : UIButton

@property (readonly, nonatomic) UIImageView *disclosureIndicatorView;
@property (readonly, nonatomic) UIView *containerView;
@property (readonly, nonatomic) UIView *currentCustomView;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (assign, nonatomic) CGFloat disclosureIndicatorAngle;
@property (assign, nonatomic) BOOL disclosureIndicatorFlipped;

- (void)setAttributedTitle:(NSAttributedString *)title selectedTitle:(NSAttributedString *)selectedTitle;
- (void)setCustomView:(UIView *)customView;
- (void)setDisclosureIndicatorImage:(UIImage *)image;

@end
