//
//  DropdownButton.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public struct DropdownButton {
    let title: String
    let titleFont: UIFont
    let titleColor: UIColor
    let buttonHandler: (() -> Void)?
    
    public init(title: String = "", titleFont: UIFont = UIFont.regularAppFontOf(size: 14.0), titleColor: UIColor = UIColor.appBlack68(), buttonHandler: (() -> Void)? = nil) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonHandler = buttonHandler
    }
}
