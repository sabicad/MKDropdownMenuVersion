//
//  DropdownCell.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

import UIKit

public class DropdownCell: NSObject {
    public let title: String
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let descriptionText: String
    public let descriptionFont: UIFont
    public let descriptionColor: UIColor
    public let image: UIImage
    public var isSelected: Bool
    public let tapHandler: ButtonHandlerBlock
    
    public init(title: String = "", titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0),
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
