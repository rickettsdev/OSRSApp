//
//  ViewController+UITableViewController.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/21/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

public struct CellNibNames {
    static let OSRSItemCell = "OSRSItemCellID"
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.osrsItemViewModelList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: "OSRSItemCellID", for: indexPath) as? OSRSItemCell else {
            return UITableViewCell()
        }
        itemCell.imageView?.image = nil
        itemCell.viewModel = viewModel?.osrsItemViewModelList?[indexPath.row]
        
        return itemCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController : OSRSViewModelUpdated {
    func viewModelUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
