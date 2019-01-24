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
    
    class func getOSRSItems(searchString: String, completion: @escaping (OSRSItemList?)->()) {
        let urlString = "http://services.runescape.com/m=itemdb_oldschool/api/catalogue/items.json?category=1&alpha=\(searchString)&page=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        DataManager.callService(with: url, completion: { (data) in
            guard let dataDictionary = DataFormatter.dataToJSONDictionary(data: data) else {
                completion(nil)
                return
            }
            let itemModelList = OSRSItemList(dataDictionary: dataDictionary)
            
            completion(itemModelList)
        })
    }
}
