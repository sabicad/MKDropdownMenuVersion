//
//  DropdownButton.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

open class DropdownButton: NSObject {
    public let title: String
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let buttonHandler: (() -> Void)?
    
    public init(title: String = "", titleFont: UIFont = UIFont.systemFont(ofSize: 14.0),
                titleColor: UIColor = UIColor.appBlack68(), buttonHandler: @escaping ButtonHandlerBlock = {}) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonHandler = buttonHandler
    }
}
