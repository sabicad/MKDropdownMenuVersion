//
//  DropdownTitle.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public struct DropdownTitle {
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    
    public init(title: String = "", titleFont: UIFont = UIFont.regularAppFontOf(size: 14.0), titleColor: UIColor = UIColor.appBlack68()) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
    }
}
