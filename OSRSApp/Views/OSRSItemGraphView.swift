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
    
    var graphViewModel: OSRSItemGraphViewModel?
    
    func generate(with data: OSRSItemPriceData) {
        self.graphViewModel = OSRSItemGraphViewModel(data)
        guard data.priceDataPoints.count > 0 && data.priceDataPointsAverage.count > 0 else {
            return
        }
        
        guard let maxPrice = self.graphViewModel?.highestAveragePrice?.price,
            let cheapestPrice = self.graphViewModel?.cheapestAveragePrice?.price,
            let itemCount = self.graphViewModel?.averageDataPointsByPrice.count
            else {
                return
        }
        
        self.minPrice.text = "\(cheapestPrice)"
        self.maxPrice.text = "\(maxPrice)"
        

        
        for index in 0..<itemCount {
            guard let xPosition = self.graphViewModel?.getDistanceFromYAxis(at: index),
                let height = self.graphViewModel?.getAveragePriceBarHeight(for: index)
                else {
                    continue
            }
            addBarToGraph(xPosition: xPosition, height: height)
        }
        
        self.layoutSubviews()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func addBarToGraph(xPosition: Int, height: Int) {
        guard let width = self.graphViewModel?.barWidth else {
            return
        }
        let xPosition = CGFloat(xPosition)
        let height = CGFloat(height)
        let barWidth = CGFloat(width)
        let bar = UIView(frame: CGRect.zero)
        bar.backgroundColor = .blue
        self.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: bar, attribute: .bottom, relatedBy: .equal, toItem: self.horizontalAxis, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
        NSLayoutConstraint(item: bar, attribute: .leading, relatedBy: .equal, toItem: self.verticalAxis, attribute: .trailing, multiplier: 1, constant: xPosition).isActive = true
        NSLayoutConstraint(item: bar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: barWidth).isActive = true
    }
    
}
