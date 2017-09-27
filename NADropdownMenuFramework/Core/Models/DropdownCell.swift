//
//  DropdownCell.swift
//  NADropdownMenuFramework
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

public struct DropdownCell {
    let title: String
    let description: String
    let image: UIImage
    
    public init(title: String = "", description: String = "", image: UIImage = UIImage()) {
        self.title = title
        self.description = description
        self.image = image
    }
}
