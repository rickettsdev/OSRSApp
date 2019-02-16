//
//  OSRSItemPriceData.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 2/2/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

public class OSRSItemPriceData {
    
    var priceDataPoints: [OSRSItemPriceDataPoint] = []
    var priceDataPointsAverage: [OSRSItemPriceDataPoint] = []
    
    public init(priceDataDictionary: [String:Any?]) {
        guard let dailyPrice = priceDataDictionary["daily"] as? [String:Int] else {
            return
        }
        guard let average = priceDataDictionary["average"] as? [String:Int] else {
            return
        }
        
        for (key, value) in dailyPrice {
            let dataPoint = OSRSItemPriceDataPoint(epoch: key, price: value)
            priceDataPoints.append(dataPoint)
        }
        // Could optimize to ordered insert
        priceDataPoints.sort()
        
        for (key, value) in average {
            let dataPoint = OSRSItemPriceDataPoint(epoch: key, price: value)
            priceDataPointsAverage.append(dataPoint)
        }
        // Could optimize to ordered insert
        priceDataPointsAverage.sort()
    }
}

public class OSRSItemPriceDataPoint {
    var epoch: String?
    var price: Int?
    
    public init(epoch: String?, price: Int?) {
        self.epoch = epoch
        self.price = price
    }
}

extension OSRSItemPriceDataPoint: Equatable {
    public static func == (lhs: OSRSItemPriceDataPoint, rhs: OSRSItemPriceDataPoint) -> Bool {
        return lhs.epoch == rhs.epoch && lhs.price == rhs.price
    }
}

extension OSRSItemPriceDataPoint: Comparable {
    public static func < (lhs: OSRSItemPriceDataPoint, rhs: OSRSItemPriceDataPoint) -> Bool {
        return lhs.epoch!.compare(rhs.epoch!) == ComparisonResult.orderedAscending
    }
}
