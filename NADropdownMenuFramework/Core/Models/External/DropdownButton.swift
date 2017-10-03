//
//  DropdownButton.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@objc open class DropdownButton: NSObject {
    @objc public let title: String
    @objc public let titleFont: UIFont
    @objc public let titleColor: UIColor
    @objc public let buttonHandler: (() -> Void)?
    
    @objc public init(title: String = "", titleFont: UIFont = UIFont.systemFont(ofSize: 14.0),
                titleColor: UIColor = UIColor.appBlack68(), buttonHandler: @escaping ButtonHandlerBlock = {}) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonHandler = buttonHandler
    }
}
