//
//  ViewController.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/20/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: ViewModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // TODO: Look into making custom tableview class
    
    weak var presentedDetailView: OSRSItemDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        registerNibs()
        self.viewModel = ViewModel(using: self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func registerNibs() {
        tableView.register(UINib(nibName: "OSRSItemCell", bundle: nil), forCellReuseIdentifier: CellNibNames.OSRSItemCell)
    }
    func removeLoadingCellIfNeeded() {
        DispatchQueue.main.async { [unowned self] in
            let numberOfCells = self.tableView.numberOfRows(inSection: 0)
            if numberOfCells > self.viewModel!.itemCount {
                let lastCellIndex = IndexPath(row: (numberOfCells-1), section: 0)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [lastCellIndex], with: .fade)
                self.tableView.endUpdates()
                self.tableView.scrollToRow(at: IndexPath(row: numberOfCells-2, section: 0), at: .bottom, animated: true)
            }
            
            self.tableView.isUserInteractionEnabled = true
            self.tableView.isScrollEnabled = true
        }
    }
}

extension ViewController : ViewModelItemsReceived {
    func osrsItemsReceived() {
        // reload tableview
        self.viewModel?.osrsItemViewModelList?.forEach({(element) in element.delegate = self })
        self.removeLoadingCellIfNeeded()
        self.tableView?.reloadData()
    }
    func newDataReceived(at indexPath: IndexPath, with data: Data?) {
        guard let count = self.viewModel?.itemCount, indexPath.row < count else {
            return
        }
        if let image = DataFormatter.dataToUIImage(data: data), let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
            cellToUpdate.imageView?.image = image
            cellToUpdate.setNeedsLayout()
            cellToUpdate.layoutIfNeeded()
        }
    }
    func prepareForNewSearchString() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    func prepareForAdditionalItems() {
        guard
            let row = self.viewModel?.itemCount,
            let itemCount = self.viewModel?.osrsItemViewModelList?.count,
            itemCount < row else {
            return
        }
        let index = IndexPath(row: row-1, section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [index], with: .bottom)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
        self.tableView.reloadData()
    }
    func itemsWereNotReceived() {
        self.removeLoadingCellIfNeeded()
    }
}

extension ViewController : OSRSViewModelUpdated {
    func presentedViewImageUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.presentedDetailView?.loadLargeIconImage()
        }
    }
    func itemPriceDataReceived(for id: Int?) {
        guard let id = id else {
            return
        }
        
        guard self.presentedDetailView?.itemViewModel?.item?.id == id else {
            return
        }
        self.presentedDetailView?.createGraphIfPossible()
    }
}

