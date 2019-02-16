//
//  DataManager.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/20/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

public class DataManager {
    class func callService(with url: URL, completion: @escaping (Data?)->()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data)
        }).resume()
    }
    
    class func getOSRSItems(searchString: String, page: Int ,completion: @escaping (OSRSItemList?)->()) {
        let urlString = "http://services.runescape.com/m=itemdb_oldschool/api/catalogue/items.json?category=1&alpha=\(searchString)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        print("\(urlString)")
        
        DataManager.callService(with: url, completion: { (data) in
            guard let dataDictionary = DataFormatter.dataToJSONDictionary(data: data) else {
                completion(nil)
                return
            }
            let itemModelList = OSRSItemList(dataDictionary: dataDictionary)
            
            completion(itemModelList)
        })
    }
    
    class func getGraphData(for itemID: Int, completion: @escaping (OSRSItemPriceData?)->()) {
        let urlString = "http://services.runescape.com/m=itemdb_oldschool/api/graph/\(itemID).json"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        DataManager.callService(with: url, completion: { (data) in
            guard let dataDictionary = DataFormatter.dataToJSONDictionary(data: data) else {
                completion(nil)
                return
            }
            let dataPointsModel = OSRSItemPriceData(priceDataDictionary: dataDictionary)
            completion(dataPointsModel)
        })
    }
    class func updateMoreDetails(for item: inout OSRSItem, completion: @escaping (Bool)->()) {
        guard let itemID = item.id else {
            completion(false)
            return
        }
        let urlString = "http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=\(itemID)"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        DataManager.callService(with: url, completion: { [weak item] (data) in
            guard let dataDictionary = DataFormatter.dataToJSONDictionary(data: data) else {
                completion(false)
                return
            }
            let newModel = OSRSItem(dataDictionary: dataDictionary)
            item?.update(with: newModel)
            completion(true)
        })
    }
}
