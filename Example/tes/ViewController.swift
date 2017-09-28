//
//  ViewController.swift
//  tes
//
//  Created by Yuriy Holovatskyi on 27.09.17.
//  Copyright © 2017 Netatmo. All rights reserved.
//

import UIKit
import NADropdownMenuFramework

class ViewController: UIViewController {

    var menu: NADropdownMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let icon = UIImage(named: "ic_dropdown")
        let checkmark = UIImage(named: "ic_checkmark")
        
        let navigationTitle = DropdownNavigationTitle(navigationBarTitle: "Home Paris",
                                                      navigationBarIcon: icon!,
                                                      navigationBarTitleColor: UIColor.white)
        
        let dropdownTitle = DropdownTitle(title: "Vos maisons", titleColor: UIColor.black)
        
        let cells = [DropdownCell(title: "Row 1", description: "d", image: checkmark!) {
                print("CALLED FROM CELL HANDLER")
            },
                     DropdownCell(title: "Row 2", description: "d", image: checkmark!, isSelected: true) {
                        print("CALLED FROM CELL HANDLER 2")
            }]
        
        let button = DropdownButton(title: "Annuler", titleFont: UIFont.boldSystemFont(ofSize: 16.0),
                                    titleColor: UIColor(red: 0/255.0, green: 145/255.0, blue: 210/255.0, alpha: 1.0)) {
            print("CALLED FROM HANDLER")
        }
        
        menu = NADropdownMenu.init(navigationModel: navigationTitle,
                                   titleModel: dropdownTitle,
                                   cellsData: cells,
                                   button: button)
        
        
        
        navigationItem.titleView = menu!.createDropdown()
    }

}

