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
    static let OSRSItemDetailView = "OSRSItemDetailView"
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.osrsItemViewModelList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: CellNibNames.OSRSItemCell, for: indexPath) as? OSRSItemCell else {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pull up description
        guard let detailView = Bundle(for: OSRSItemDetailView.self).loadNibNamed("OSRSItemDetailView", owner: self, options: nil)?.first as? OSRSItemDetailView else {
            return
        }
        self.presentedDetailView = detailView
        self.presentedDetailView?.itemViewModel = self.viewModel?.osrsItemViewModelList?[indexPath.row]
        self.view.addSubview(self.presentedDetailView!)
        self.presentedDetailView?.translatesAutoresizingMaskIntoConstraints = false
        let views = ["detailView":self.presentedDetailView!]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[detailView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
    }
}
