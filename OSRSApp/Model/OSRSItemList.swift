//
//  OSRSItemList.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/21/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

public class OSRSItemList: NSObject {
    var total: Int = 0
    var items: [OSRSItem] = []
    public init(dataDictionary: [String:Any?]) {
        super.init()
        if let total = dataDictionary["total"] as? Int {
            self.total = total
        }
        if let items = dataDictionary["items"] as? [[String:Any?]] {
            items.forEach({ [weak self] (entry) in self?.items.append(OSRSItem(dataDictionary: entry))})
        }
    }
}
