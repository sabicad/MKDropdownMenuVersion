//
//  DropdownTitle.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

open class DropdownTitle: NSObject {
    public let title: String
    public let titleFont: UIFont
    public let titleColor: UIColor
    
    public init(title: String = "", titleFont: UIFont = UIFont.systemFont(ofSize: 14.0),
                titleColor: UIColor = UIColor.appBlack68()) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
    }
}
