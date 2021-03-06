//
//  NADropdownMenu.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 26.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public protocol NADropdownMenuDelegate: class {
    func dropdownMenuDelegateDidOpen()
    func dropdownMenuDelegateDidClose()
}

public class NADropdownMenu: NSObject {
    // MARK: - Public
    
    public var dropdownRoundedCorners: UIRectCorner = .allCorners
    public var useFullScreenWidth: Bool = true
    public var fullScreenInsetLeft: CGFloat = 0
    public var fullScreenInsetRight: CGFloat = 0
    public weak var delegate: NADropdownMenuDelegate?

    public init(navigationModel: DropdownNavigationTitle = DropdownNavigationTitle(),
                titleModel: DropdownTitle = DropdownTitle(),
                cellsData: [DropdownCell] = [],
                button: DropdownButton = DropdownButton(),
                config: DropdownConfig = DropdownConfig()) {
        
        self.navigationModel = navigationModel
        self.titleModel = titleModel
        self.cellsData = cellsData
        self.button = button
        self.config = config
    }
    
    public func createDropdown(frame: CGRect = CGRect(x: 0, y: 0, width: 130, height: 44)) -> MKDropdownMenu {
        dropdownMenu = MKDropdownMenu(frame: frame)
        
        dropdownMenu.dataSource = self
        dropdownMenu.delegate = self

        dropdownMenu.dropdownShowsTopRowSeparator = true
        dropdownMenu.dropdownBouncesScroll = false
        dropdownMenu.dropdownRoundedCorners = dropdownRoundedCorners
        
        dropdownMenu.useFullScreenWidth = useFullScreenWidth
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        if config.relativeDropdownWidth > 1 {
            config.relativeDropdownWidth = 1
        }
        
        let inset = screenWidth - screenWidth * config.relativeDropdownWidth
        
        dropdownMenu.fullScreenInsetLeft = inset / 2
        dropdownMenu.fullScreenInsetRight = inset / 2
        
        dropdownMenu.disclosureIndicatorImage = navigationModel.navigationBarIcon
        
        fillDropdownModels()
        
        return dropdownMenu
    }
    
    public func updateDropdownModel(titleModel: DropdownTitle = DropdownTitle(),
                                  cellsData: [DropdownCell] = [],
                                  button: DropdownButton = DropdownButton(),
                                  config: DropdownConfig = DropdownConfig()) {
        self.titleModel = titleModel
        self.cellsData = cellsData
        self.button = button
        self.config = config
        
        fillDropdownModels()
        dropdownMenu.reloadAllComponents()
    }
    
    public func openDropdown() {
        dropdownMenu.openComponent(0, animated: true)
    }
    
    public func closeDropdown() {
        dropdownMenu.closeAllComponents(animated: true)
    }
    
    // MARK: - Private
    
    fileprivate var dropdownMenu: MKDropdownMenu = MKDropdownMenu()
    fileprivate var navigationModel: DropdownNavigationTitle
    fileprivate var titleModel: DropdownTitle
    fileprivate var cellsData: [DropdownCell]
    fileprivate var button: DropdownButton
    fileprivate var config: DropdownConfig

    fileprivate func fillDropdownModels() {
        dropdownMenu.internalTitle = titleModel
        dropdownMenu.internalCells = cellsData
        dropdownMenu.internalButton = button
        dropdownMenu.internalConfig = config
    }
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
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: navigationModel.navigationBarTitle, attributes: [NSAttributedStringKey.foregroundColor: navigationModel.navigationBarTitleColor])
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
        delegate?.dropdownMenuDelegateDidOpen()
    }
    
    public func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didCloseComponent component: Int) {
        delegate?.dropdownMenuDelegateDidClose()
    }
}
