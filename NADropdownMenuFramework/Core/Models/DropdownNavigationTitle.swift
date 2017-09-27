//
//  File.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public struct DropdownNavigationTitle {
    let navigationBarTitle: String
    let navigationBarIcon: UIImage
    let navigationBarTitleFont: UIFont
    let navigationBarTitleColor: UIColor
    
    public init(navigationBarTitle: String = "", navigationBarIcon: UIImage = UIImage(),
         navigationBarTitleFont: UIFont = UIFont.semiBoldAppFontOf(size: 16.0),
         navigationBarTitleColor: UIColor = UIColor.white) {
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarIcon = navigationBarIcon
        self.navigationBarTitleFont = navigationBarTitleFont
        self.navigationBarTitleColor = navigationBarTitleColor
    }
}
