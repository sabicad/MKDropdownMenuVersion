//
//  DropdownButton.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@objc open class DropdownButton: NSObject {
    @objc public var title: String
    @objc public var titleFont: UIFont
    @objc public var titleColor: UIColor
    @objc public var buttonHandler: (() -> Void)?
    
    @objc public init(title: String = "", titleFont: UIFont = UIFont.systemFont(ofSize: 14.0),
                titleColor: UIColor = UIColor.appBlack68(), buttonHandler: @escaping ButtonHandlerBlock = {}) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonHandler = buttonHandler
    }
}
