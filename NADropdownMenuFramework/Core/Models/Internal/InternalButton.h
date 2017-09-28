//
//  InternalButton.h
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 28.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternalButton : NSObject
typedef void(^ButtonHandlerBlock)(void);

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) ButtonHandlerBlock tapHandler;

@end
