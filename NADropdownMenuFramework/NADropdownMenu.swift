//
//  NADropdownMenu.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 26.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public enum DropdownCellType: Int {
    case dropDownCellTypeTitle = 0
    case dropDownCellTypeTitleDescription = 1
    case dropDownCellTypeTitleDescriptionImage = 2
}

public enum DropdownMenuType: Int {
    case dropdownMenuTypeTitleCellsCancel = 0
}

open class NADropdownMenu: NSObject {
    let navigationModel: DropdownNavigationTitle
    let titleModel: DropdownTitle
    let cellsData: [DropdownCell]
    let button: DropdownButton
    
    // MARK: - Public
    
    var rowSeparatorColor: UIColor = UIColor.red
    
    // Round all corners (by default only bottom corners are rounded)
    var dropdownRoundedCorners: UIRectCorner = .allCorners
    
    // Make background light instead of dark when presenting the dropdown
    var backgroundDimmingOpacity: CGFloat = 0
    
    // Let the dropdown take the whole width of the screen with 10pt insets
    var useFullScreenWidth: Bool = true
    var fullScreenInsetLeft: CGFloat = 0
    var fullScreenInsetRight: CGFloat = 0
    
    public init(navigationModel: DropdownNavigationTitle = DropdownNavigationTitle(), titleModel: DropdownTitle = DropdownTitle(),
         cellsData: [DropdownCell] = [], button: DropdownButton = DropdownButton()) {
        self.navigationModel = navigationModel
        self.titleModel = titleModel
        self.cellsData = cellsData
        self.button = button
    }
    
    open func createDropdown() -> MKDropdownMenu {
        dropdownMenu = MKDropdownMenu(frame: CGRect(x: 0, y: 0, width: 130, height: 44))
        dropdownMenu.dataSource = self
        dropdownMenu.delegate = self
        
        dropdownMenu.backgroundDimmingOpacity = backgroundDimmingOpacity
        
        dropdownMenu.disclosureIndicatorImage = navigationModel.navigationBarIcon
        
        // Hide top row separator to blend with the arrow
        dropdownMenu.dropdownShowsTopRowSeparator = true
        dropdownMenu.dropdownBouncesScroll = false
        
        dropdownMenu.rowSeparatorColor = rowSeparatorColor
        dropdownMenu.dropdownRoundedCorners = dropdownRoundedCorners
        
        // Let the dropdown take the whole width of the screen with 10pt insets
        dropdownMenu.useFullScreenWidth = useFullScreenWidth
        dropdownMenu.fullScreenInsetLeft = fullScreenInsetLeft
        dropdownMenu.fullScreenInsetRight = fullScreenInsetRight
        
        return dropdownMenu
    }
    
    // MARK: - Private
    
    fileprivate var dropdownMenu: MKDropdownMenu = MKDropdownMenu()
}

// MARK: - MKDropdownMenuDataSource

extension NADropdownMenu: MKDropdownMenuDataSource {
    public func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return cellsData.count
    }
}

// MARK: - MKDropdownMenuDelegate

extension NADropdownMenu: MKDropdownMenuDelegate {
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, footerHeightForComponent component: Int) -> CGFloat {
        return 58.0
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, headerHeightForComponent component: Int) -> CGFloat {
        return 43.0
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: navigationModel.navigationBarTitle, attributes: [NSAttributedStringKey.foregroundColor: navigationModel.navigationBarTitleColor])
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
        return cellsData[row].title
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForRow row: Int, forComponent component: Int) -> UIColor? {
        if dropdownMenu.selectedRows(inComponent: 0).contains(row) {
            return UIColor.gray
        }
        return UIColor.orange
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForHighlightedRowsInComponent component: Int) -> UIColor? {
        return UIColor.black
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        dropdownMenu.selectRow(row, inComponent: component)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150),
                                      execute: {
                                        dropdownMenu.closeAllComponents(animated: true)
        })
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didDeselectRow row: Int, inComponent component: Int) {
        dropdownMenu.deselectRow(row, inComponent: component)
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didOpenComponent component: Int) {
        
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didCloseComponent component: Int) {
        
    }
}
