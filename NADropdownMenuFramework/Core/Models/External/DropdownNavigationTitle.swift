//
//  File.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public class DropdownNavigationTitle: NSObject {
    public let navigationBarTitle: String
    public let navigationBarIcon: UIImage
    public let navigationBarTitleFont: UIFont
    public let navigationBarTitleColor: UIColor
    
    public init(navigationBarTitle: String = "", navigationBarIcon: UIImage = UIImage(),
         navigationBarTitleFont: UIFont = UIFont.systemFont(ofSize: 16.0),
         navigationBarTitleColor: UIColor = UIColor.white, someString: NSString = "") {
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarIcon = navigationBarIcon
        self.navigationBarTitleFont = navigationBarTitleFont
        self.navigationBarTitleColor = navigationBarTitleColor
    }
}
