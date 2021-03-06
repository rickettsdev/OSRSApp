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
    func presentedViewImageUpdated()
    func itemPriceDataReceived(for id: Int?)
}

enum ReloadCellState: Int {
    case active
    case inactive
}

enum CurrentDataContent {
    case primary
    case secondary
}

public class OSRSItemViewModel: NSObject {
    var item: OSRSItem?
    weak var delegate: OSRSViewModelUpdated?
    
    var priceDataNeedsUpdate: Bool = true
    
    private var _priceDataPoints: OSRSItemPriceData? {
        didSet {
            self.delegate?.itemPriceDataReceived(for: self.item?.id)
        }
    }
    
    var priceDataPoints: OSRSItemPriceData? {
        get {
            guard _priceDataPoints != nil && self.priceDataNeedsUpdate == false else {
                self.priceDataNeedsUpdate = false
                getPriceDataPoints()
                return nil
            }
            return _priceDataPoints
        }
    }
    
    var smallIcon: Data?
    
    var largeIconNeedsUpdate: Bool = true
    private var _largeIcon: Data? {
        didSet {
            self.delegate?.presentedViewImageUpdated()
        }
    }
    
    var largeIcon: Data? {
        get {
            guard _largeIcon != nil && self.largeIconNeedsUpdate == false else {
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
    
    func getCurrentDataHeader() -> String {
        return "Current Statistics"
    }

    func getCurrentData(label type: CurrentDataContent ,for row: Int) -> String {
        switch row {
        case 0:
            guard type == .secondary else {
                return "Price"
            }
            let currentPrice = item?.current?.price ?? ""
            return "\(currentPrice)"
        case 1:
            guard type == .secondary else {
                return "Trend"
            }
            let currentTrend = item?.current?.trend?.rawValue ?? ""
            return currentTrend
        case 2:
            return ""
        case 3:
            return ""
        case 4:
            return ""
        case 5:
            return ""
        default:()
        }
        return ""
    }
    
    func currentDataContentCount() -> Int {
        return 2
    }
    
    private func getLargeIconData() {
        guard let url = item?.largeIconURL else {
            return
        }
        DataManager.callService(with: url, completion: { [weak self] (data) in
            guard let data = data else {
                self?.largeIconNeedsUpdate = true
                return
            }
            self?._largeIcon = data
        })
    }
    private func getPriceDataPoints() {
        guard let id = self.item?.id else {
            return
        }
        DataManager.getGraphData(for: id, completion: { [weak self] (dataPointModel) in
            guard let dataPointModel = dataPointModel else {
                self?.priceDataNeedsUpdate = true
                return
            }
            self?._priceDataPoints = dataPointModel
        })
    }
}

//meant to be implemented by viewcontroller
public protocol ViewModelItemsReceived: class {
    func osrsItemsReceived()
    func newDataReceived(at indexPath: IndexPath, with data: Data?)
    func prepareForNewSearchString()
    func prepareForAdditionalItems()
    func itemsWereNotReceived()
}

public class ViewModel: NSObject {
    weak var delegate: ViewModelItemsReceived?
    var previousSearchString: String?
    
    private var _pageNumber: Int = 1
    var pageNumber: Int {
        get {
            _pageNumber = _pageNumber + 1
            return _pageNumber - 1
        }
    }
    
    var itemCount: Int {
        get {
            guard let modeListCount = self.osrsItemViewModelList?.count else {
                return 0
            }
            
            let itemCount = self.reloadCellState == .active ? modeListCount + 1 : modeListCount
            
            return itemCount
        }
    }
    
    var reloadCellState: ReloadCellState = .inactive {
        didSet {
            
            guard let searchString = self.previousSearchString else {
                return
            }
            
            if reloadCellState == .active && oldValue == .inactive {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.prepareForAdditionalItems()
                    self?.searchForItems(searchString: searchString)
                }
            }
        }
    }
    
    var osrsItemViewModelList: [OSRSItemViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCellState = .inactive
                self?.delegate?.osrsItemsReceived()
            }
        }
    }
    
    public init(using delegate: ViewModelItemsReceived) {
        super.init()
        self.delegate = delegate
    }
    
    public func fetchSmallIconData(indexPath: IndexPath, smallIconURL: URL?) {
        DataManager.getSmallIconData(url: smallIconURL, onCompletion: { [weak self, indexPath] (data) in
            DispatchQueue.main.async {
                //TODO: Should add check to see if same query string
                guard indexPath.row < self?.itemCount ?? 0 else {
                    return
                }
                self?.osrsItemViewModelList?[indexPath.row].smallIcon = data
                self?.delegate?.newDataReceived(at: indexPath, with: data)
            }
        })
    }
    
    public func searchForItems(searchString: String?) {
        
        guard let searchString = searchString?.lowercased() else {
            return
        }
        
        self.previousSearchString = searchString
        
        if self.reloadCellState == .inactive {
            self.resetPageNumber()
        }
        
        if self.itemCount > 0 && self.onlyShowingFirstPage(){
            self.delegate?.prepareForNewSearchString()
            // Need to make sure this is executed before getOSRSItems is called below.
        }
        
        DataManager.getOSRSItems(searchString: searchString, page: self.pageNumber, completion: { [weak self] (model) in
            guard let model = model, model.items.count > 0 else {
                self?.reloadCellState = .inactive
                self?.delegate?.itemsWereNotReceived()
                return
            }
            
            let newViewModels = model.items.map({ (item) in return OSRSItemViewModel(item: item) })
            
            guard let currentItemViewModelListCopy = self?.osrsItemViewModelList else {
                self?.osrsItemViewModelList = newViewModels
                return
            }
            
            var itemViewModelList = (self?.reloadCellState == ReloadCellState.active ? currentItemViewModelListCopy : [])
            
            itemViewModelList.append(contentsOf: newViewModels)
        
            self?.osrsItemViewModelList = itemViewModelList
        })
    }
    func resetPageNumber() {
        self._pageNumber = 1
    }
    func onlyShowingFirstPage() -> Bool {
        return self._pageNumber == 1
    }
}
