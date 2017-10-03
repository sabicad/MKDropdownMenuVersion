//
//  DropdownConfig.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 29/09/17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

@objc public class DropdownConfig: NSObject {
    @objc public let navTitleBackgroundColor: UIColor
    @objc public let titleBackgroundColor: UIColor
    @objc public let cellsBackgroundColor: UIColor
    @objc public let cellsSeparatorColor: UIColor
    @objc public let footerBackgroundColor: UIColor
    @objc public let titleHeight: CGFloat
    @objc public let cellsHeight: CGFloat
    @objc public let footerHeight: CGFloat
    @objc public let sideInsets: CGFloat
    
    @objc public init(navTitleBackgroundColor: UIColor = UIColor.white,
                titleBackgroundColor: UIColor = UIColor.white,
                cellsBackgroundColor: UIColor = UIColor.white,
                cellsSeparatorColor: UIColor = UIColor.appSeparato(),
                footerBackgroundColor: UIColor = UIColor.white,
                titleHeight: CGFloat = 43.0,
                cellsHeight: CGFloat = 60.0,
                footerHeight: CGFloat = 58.0,
                sideInsets: CGFloat = 0) {
        self.navTitleBackgroundColor = navTitleBackgroundColor
        self.titleBackgroundColor = titleBackgroundColor
        self.cellsBackgroundColor = cellsBackgroundColor
        self.cellsSeparatorColor = cellsSeparatorColor
        self.footerBackgroundColor = footerBackgroundColor
        self.titleHeight = titleHeight
        self.cellsHeight = cellsHeight
        self.footerHeight = footerHeight
        self.sideInsets = sideInsets
    }
}
