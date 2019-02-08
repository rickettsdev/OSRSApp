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
}

extension ViewController : ViewModelItemsReceived {
    func osrsItemsReceived() {
        // reload tableview
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.osrsItemViewModelList?.forEach({(element) in element.delegate = self })
            self?.tableView?.reloadData()
        }
    }
}

extension ViewController : OSRSViewModelUpdated {
    func viewModelUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
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
        // TODO: Reload graph since data has arrived.
        
    }
}

