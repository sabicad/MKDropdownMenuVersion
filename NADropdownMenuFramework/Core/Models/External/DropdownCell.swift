//
//  DropdownCell.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

import UIKit

@objc public class DropdownCell: NSObject {
    @objc public var title: String
    @objc public var titleFont: UIFont
    @objc public var titleColor: UIColor
    @objc public var descriptionText: String
    @objc public var descriptionFont: UIFont
    @objc public var descriptionColor: UIColor
    @objc public var image: UIImage
    @objc public var isSelected: Bool
    @objc public var tapHandler: ButtonHandlerBlock?
    
    @objc public init(title: String = "", titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0),
                titleColor: UIColor = UIColor.appBlack68(),
                description: String = "", descriptionFont: UIFont = UIFont.systemFont(ofSize: 14.0), descriptionColor: UIColor = UIColor.appBlack68Alpha30(),
                image: UIImage = UIImage(), isSelected: Bool = false,
                tapHandler: @escaping ButtonHandlerBlock = {}) {
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.descriptionText = description
        self.descriptionColor = descriptionColor
        self.descriptionFont = descriptionFont
        self.image = image
        self.tapHandler = tapHandler
        self.isSelected = isSelected
        
        UIFont.systemFont(ofSize: 15.0)
        UIFont.boldSystemFont(ofSize: 15.0)
    }
}
