//
//  OSRSItemGraphView.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 2/9/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

private struct GraphConstants {
    static let INITIAL_DISTANCE_FROM_X_AXIS = CGFloat(0)
    static let BAR_WIDTH = CGFloat(1)
    static let MAX_HEIGHT = CGFloat(180)
}

public class OSRSItemGraphView: UIView {
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var maxPrice: UILabel!
    @IBOutlet weak var verticalAxis: UIView!
    
    @IBOutlet weak var horizontalAxis: UIView!
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func generate(with data: OSRSItemPriceData) {
        guard data.priceDataPoints.count > 0 && data.priceDataPointsAverage.count > 0 else {
            return
        }
        let averageDataPointsByDate = data.priceDataPointsAverage
        // TODO: Need to move this to a viewmodel
        let averageDataPointsByPrice = data.priceDataPointsAverage.sorted {
            return $0.price! < $1.price!
        }
        let maxPrice = averageDataPointsByPrice.last!
        let cheapestPrice = averageDataPointsByPrice.first!
        
        if let cheapest = cheapestPrice.price {
            self.minPrice.text = "\(cheapest)"
        }
        if let max = maxPrice.price {
            self.maxPrice.text = "\(max)"
        }
        
        let totalRange = CGFloat((maxPrice.price! - cheapestPrice.price!))
        
        for (index, dataPoint) in averageDataPointsByDate.enumerated() {
            let xPosition = GraphConstants.INITIAL_DISTANCE_FROM_X_AXIS + (CGFloat((index)) * GraphConstants.BAR_WIDTH)
            let priceAboveLowest = dataPoint.price! - cheapestPrice.price!
            let ratio = CGFloat(priceAboveLowest) / totalRange
            let height = ratio * GraphConstants.MAX_HEIGHT
            guard CGFloat(xPosition) < self.bounds.width else {
                break
            }
            addBarToGraph(xPosition: xPosition, height: height)
        }
        
        self.layoutSubviews()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func addBarToGraph(xPosition: CGFloat, height: CGFloat) {
        let bar = UIView(frame: CGRect.zero)
        bar.backgroundColor = .blue
        self.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: bar, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalAxis, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
        NSLayoutConstraint(item: bar, attribute: .leading, relatedBy: .equal, toItem: self.verticalAxis, attribute: .trailing, multiplier: 1, constant: xPosition).isActive = true
        NSLayoutConstraint(item: bar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(GraphConstants.BAR_WIDTH)).isActive = true
    }
    
}
