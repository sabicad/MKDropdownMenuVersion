//
//  UIFont+App.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

import UIKit

public extension UIFont {
    public class func regularAppFontOf(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: fontSize)!
    }
    public class func boldAppFontOf(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Bold", size: fontSize)!
    }
    public class func lightAppFontOf(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Light", size: fontSize)!
    }
    public class func semiBoldAppFontOf(size fontSize: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-SemiBold", size: fontSize)!
    }
}
