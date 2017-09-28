//
//  InternalConfig.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 29/09/17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternalConfig : NSObject

@property (nonatomic, strong) UIColor *navTitleBackgroundColor;
@property (nonatomic, strong) UIColor *titleBackgroundColor;
@property (nonatomic, strong) UIColor *cellsBackgroundColor;
@property (nonatomic, strong) UIColor *cellsSeparatorColor;
@property (nonatomic, strong) UIColor *footerBackgroundColor;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat cellsHeight;
@property (nonatomic, assign) CGFloat footerHeight;


@end
