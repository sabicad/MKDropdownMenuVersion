//
//  DropdownConfig.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 29/09/17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@objc public class DropdownConfig: NSObject {
    @objc public var navTitleBackgroundColor: UIColor
    @objc public var titleBackgroundColor: UIColor
    @objc public var cellsBackgroundColor: UIColor
    @objc public var cellsHighlightColor: UIColor
    @objc public var cellsSeparatorColor: UIColor
    @objc public var footerBackgroundColor: UIColor
    @objc public var titleHeight: CGFloat
    @objc public var cellsHeight: CGFloat
    @objc public var footerHeight: CGFloat
    @objc public var relativeDropdownWidth: CGFloat
    
    @objc public init(navTitleBackgroundColor: UIColor = UIColor.white,
                titleBackgroundColor: UIColor = UIColor.white,
                cellsBackgroundColor: UIColor = UIColor.white,
                cellsHighlightColor: UIColor = UIColor.lightGray,
                cellsSeparatorColor: UIColor = UIColor.appSeparato(),
                footerBackgroundColor: UIColor = UIColor.white,
                titleHeight: CGFloat = 43.0,
                cellsHeight: CGFloat = 60.0,
                footerHeight: CGFloat = 58.0,
                relativeDropdownWidth: CGFloat = 1) {
        self.navTitleBackgroundColor = navTitleBackgroundColor
        self.titleBackgroundColor = titleBackgroundColor
        self.cellsBackgroundColor = cellsBackgroundColor
        self.cellsHighlightColor = cellsHighlightColor
        self.cellsSeparatorColor = cellsSeparatorColor
        self.footerBackgroundColor = footerBackgroundColor
        self.titleHeight = titleHeight
        self.cellsHeight = cellsHeight
        self.footerHeight = footerHeight
        self.relativeDropdownWidth = relativeDropdownWidth
    }
}
