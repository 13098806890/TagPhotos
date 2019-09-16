//
//  MenuController.swift
//  TagPhotos
//
//  Created by Teemo on 2019/9/13.
//  Copyright © 2019 Teemo. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var menuTable: UITableView
    weak var container: ContainerViewController?
    var model: MenuModel
    
    init(model: MenuModel) {
        self.model = model
        menuTable = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        menuTable.frame = CGRect.init(x: 0, y: 0, width: ContainerViewController.menuWidth, height: self.view.frame.height)
        self.view.addSubview(menuTable)
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.numbersOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfItemsForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as?  MenuTableViewCell {
            setCellContent(cell: cell, at: indexPath)
            
            return cell
        } else {
            let cell = MenuTableViewCell.init(style: .default, reuseIdentifier: "MenuTableViewCell")
            setCellContent(cell: cell, at: indexPath)
            
            return cell
        }
    }
    
    func setCellContent(cell: MenuTableViewCell, at indexPath: IndexPath) {
        let cellModel = model.itemForIndexPath(indexPath: indexPath)
        cell.iconLabel.text = cellModel.0
        cell.descriptionLabel.text = cellModel.1
        cell.countLabel.text = cellModel.2
    }

}
