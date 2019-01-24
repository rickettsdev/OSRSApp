//
//  ViewModel.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/20/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

// Meant to be implemented by the tableviewcell
protocol OSRSViewModelUpdated: class {
    func viewModelUpdated()
}

public class OSRSItemViewModel: NSObject {
    var item: OSRSItem?
    weak var delegate: OSRSViewModelUpdated?
    
    var smallIconNeedsUpdate: Bool = true
    
    private var _smallIcon: Data? {
        didSet {
            print("test: \(self.item?.name ?? "")")
            self.delegate?.viewModelUpdated()
        }
    }
    var smallIcon: Data? {
        get {
            guard _smallIcon != nil && self.smallIconNeedsUpdate == false else {
                self.smallIconNeedsUpdate = false
                getSmallIconData()
                return nil
            }
            return _smallIcon
        }
    }
    
    var largeIconNeedsUpdate: Bool = true
    private var _largeIcon: Data? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.viewModelUpdated()
            }
        }
    }
    
    var largeIcon: Data? {
        get {
            guard _largeIcon != nil, self.largeIconNeedsUpdate == true else {
                self.largeIconNeedsUpdate = false
                getLargeIconData()
                return nil
            }
            return _largeIcon
        }
    }
    
    public init(item: OSRSItem) {
        self.item = item
    }
    
    private func getSmallIconData() {
        guard let url = item?.smallIconURL else {
            return
        }
        DataManager.callService(with: url, completion: { [weak self] (data) in
            guard let data = data else {
                return
            }
            self?._smallIcon = data
        })
    }
    private func getLargeIconData() {
        guard let url = item?.largeIconURL else {
            return
        }
        DataManager.callService(with: url, completion: { [weak self] (data) in
            guard let data = data else {
                return
            }
            self?._largeIcon = data
        })
    }
}

//meant to be implemented by viewcontroller
public protocol ViewModelItemsReceived: class {
    func osrsItemsReceived()
}

public class ViewModel: NSObject {
    weak var delegate: ViewModelItemsReceived?
    var itemCount: Int?
    var osrsItemViewModelList: [OSRSItemViewModel]? {
        didSet {
            delegate?.osrsItemsReceived()
        }
    }
    
    public init(using delegate: ViewModelItemsReceived) {
        super.init()
        self.delegate = delegate
    }
    
    public func searchForItems(searchString: String?) {
        
        guard let searchString = searchString?.lowercased() else {
            return
        }
        
        DataManager.getOSRSItems(searchString: searchString, completion: { [weak self] (model) in
            guard let model = model else {
                return
            }
            self?.itemCount = model.total
            self?.osrsItemViewModelList = model.items.map({ (item) in return OSRSItemViewModel(item: item) })
        })
    }
}
