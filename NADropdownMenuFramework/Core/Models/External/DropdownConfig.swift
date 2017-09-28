//
//  DropdownConfig.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 29/09/17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public class DropdownConfig: NSObject {
    public let navTitleBackgroundColor: UIColor
    public let titleBackgroundColor: UIColor
    public let cellsBackgroundColor: UIColor
    public let cellsSeparatorColor: UIColor
    public let footerBackgroundColor: UIColor
    public let titleHeight: CGFloat
    public let cellsHeight: CGFloat
    public let footerHeight: CGFloat
    public let sideInsects: CGFloat
    
    public init(navTitleBackgroundColor: UIColor = UIColor.white,
                titleBackgroundColor: UIColor = UIColor.white,
                cellsBackgroundColor: UIColor = UIColor.white,
                cellsSeparatorColor: UIColor = UIColor.appSeparato(),
                footerBackgroundColor: UIColor = UIColor.white,
                titleHeight: CGFloat = 43.0,
                cellsHeight: CGFloat = 60.0,
                footerHeight: CGFloat = 58.0,
                sideInsects: CGFloat = 0) {
        self.navTitleBackgroundColor = navTitleBackgroundColor
        self.titleBackgroundColor = titleBackgroundColor
        self.cellsBackgroundColor = cellsBackgroundColor
        self.cellsSeparatorColor = cellsSeparatorColor
        self.footerBackgroundColor = footerBackgroundColor
        self.titleHeight = titleHeight
        self.cellsHeight = cellsHeight
        self.footerHeight = footerHeight
        self.sideInsects = sideInsects
    }
}
