//
//  File.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@objc public class DropdownNavigationTitle: NSObject {
    @objc public var navigationBarTitle: String
    @objc public var navigationBarIcon: UIImage
    @objc public var navigationBarTitleFont: UIFont
    @objc public var navigationBarTitleColor: UIColor
    
    @objc public init(navigationBarTitle: String = "", navigationBarIcon: UIImage = UIImage(),
         navigationBarTitleFont: UIFont = UIFont.systemFont(ofSize: 16.0),
         navigationBarTitleColor: UIColor = UIColor.white) {
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarIcon = navigationBarIcon
        self.navigationBarTitleFont = navigationBarTitleFont
        self.navigationBarTitleColor = navigationBarTitleColor
    }
}
