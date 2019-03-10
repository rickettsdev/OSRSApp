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
        return viewModel?.itemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !isLoadingCell(indexPath: indexPath) else {
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
        
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: CellNibNames.OSRSItemCell, for: indexPath) as? OSRSItemCell else {
            return UITableViewCell()
        }
        
        itemCell.viewModel = viewModel?.osrsItemViewModelList?[indexPath.row]
        
        if let image = DataFormatter.dataToUIImage(data: itemCell.viewModel?.smallIcon) {
            itemCell.imageView?.image = image
        } else {
            self.viewModel?.fetchSmallIconData(indexPath: indexPath, smallIconURL: itemCell.viewModel?.item?.smallIconURL)
        }
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.viewModel?.itemCount ?? 0 != 0 else {
            return
        }
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height + inset.bottom
        let h = size.height
        let reloadDistance = CGFloat(30.0)
        if y > h + reloadDistance {
            self.tableView.isUserInteractionEnabled = false
            self.tableView.isScrollEnabled = false
            self.viewModel?.reloadCellState = .active
        }
    }
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        guard let itemCount = viewModel?.osrsItemViewModelList?.count else {
            return false
        }
        return itemCount == indexPath.row
    }
}
