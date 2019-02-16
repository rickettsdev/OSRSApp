//
//  OSRSItemGraphViewModel.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 2/10/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

private struct GraphConstants {
    static let INITIAL_DISTANCE_FROM_X_AXIS = 0
    static let BAR_WIDTH = 1
    static let MAX_HEIGHT: Double = 180.0
}

public class OSRSItemGraphViewModel: NSObject {
    private var itemPriceData: OSRSItemPriceData
    
    lazy var averageDataPointsByPrice = {
        return itemPriceData.priceDataPointsAverage.sorted { $0.price! < $1.price! }
    }()
    
    lazy var averageDataPointByDate = {
        return self.itemPriceData.priceDataPointsAverage
    }()
    
    lazy var cheapestAveragePrice: OSRSItemPriceDataPoint? = {
        guard let cheapest = self.averageDataPointsByPrice.first else {
            return nil
        }
        return cheapest
    }()
    
    lazy var highestAveragePrice: OSRSItemPriceDataPoint? = {
        guard let highest = self.averageDataPointsByPrice.last else {
            return nil
        }
        return highest
    }()
    
    lazy var differenceInRange: Int? = {
        guard let highest = self.highestAveragePrice?.price, let lowest = self.cheapestAveragePrice?.price else {
            return nil
        }
       return (highest - lowest)
    }()
    
    lazy var barWidth: Int = {
        return GraphConstants.BAR_WIDTH
    }()
    
    
    lazy var dateRange: String = {
        guard let earliest = self.averageDataPointByDate.first?.epoch, let latest = self.averageDataPointByDate.last?.epoch else {
            return ""
        }
        guard let earliestTime = Double(earliest), let latestTime = Double(latest) else {
            return ""
        }
        let earliestDate = Date(timeIntervalSince1970: earliestTime/1000.0)
        let latestDate = Date(timeIntervalSince1970: latestTime/1000.0)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyy"
        let earliestDateString = dateFormatter.string(from: earliestDate)
        let latestDateString = dateFormatter.string(from: latestDate)
        return "\(earliestDateString) - \(latestDateString)"
    }()
    
    func getAveragePriceBarHeight(for index: Int) -> Int? {
        
        guard index < self.averageDataPointByDate.count,
            let elementPrice = self.averageDataPointByDate[index].price,
            let cheapest = self.cheapestAveragePrice?.price,
            let differenceInRange = self.differenceInRange
            else {
            return nil
        }
        let priceAboveLowest = elementPrice - cheapest
        
        guard differenceInRange != 0 else {
            return Int(GraphConstants.MAX_HEIGHT)
        }
        
        guard priceAboveLowest != 0 else {
            return 0
        }
        
        let ratio: Double = Double(priceAboveLowest) / Double(differenceInRange)
        
        let height = Int(ratio * GraphConstants.MAX_HEIGHT)
        
        
        return height
    }
    
    func getHighestPricePoint() -> String {
        let highest = priceAbbreviated(priceDataPoint: self.highestAveragePrice)
        return highest
    }
    func getCheapestPricePoint() -> String {
        let cheapest = priceAbbreviated(priceDataPoint: self.cheapestAveragePrice)
        return cheapest
    }
    
    func priceAbbreviated(priceDataPoint: OSRSItemPriceDataPoint?) -> String {
        guard let price = priceDataPoint?.price else {
            return ""
        }
        let wholePrice = price / 1000000
        guard wholePrice >= 1 else {
            return "\(price)gp"
        }
        let decimalPrice = (price % 1000000) / 100000
        return "\(wholePrice).\(decimalPrice)M"
    }
    
    func getDistanceFromYAxis(at index: Int) -> Int {
        return GraphConstants.INITIAL_DISTANCE_FROM_X_AXIS + index * GraphConstants.BAR_WIDTH
    }
    // TODO: Implement this function.
    func dataPointRunsOffGraph(at index: Int) -> Bool {
        return false
    }
    
    public init(_ itemPriceData: OSRSItemPriceData) {
        self.itemPriceData = itemPriceData
    }
}
