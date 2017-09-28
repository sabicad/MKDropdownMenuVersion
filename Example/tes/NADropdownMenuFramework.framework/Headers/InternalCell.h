//
//  InternalCell.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 28.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ButtonHandlerBlock)(void);

@interface InternalCell : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) UIFont *descriptionFont;
@property (nonatomic, strong) UIColor *descriptionColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ButtonHandlerBlock tapHandler;
@property (nonatomic, assign) BOOL isSelected;

@end
