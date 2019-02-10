//
//  OSRSItemDetailView.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 2/2/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

class OSRSItemDetailView: UIView {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var priceTrend: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var graphView: UIView!
    
    var itemViewModel: OSRSItemViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setup()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
        self.cancelButton.setTitle("Back", for: .normal)
        self.cancelButton.setTitleColor(.red, for: .normal)
        self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.cancelButton.setNeedsLayout()
        self.cancelButton.layoutIfNeeded()
        
        loadLargeIconImage()
        
        if let title = itemViewModel?.item?.name {
            self.title.text = title
        }
        if let description = itemViewModel?.item?.itemDescription {
            self.itemDescription.text = description
        }
        if let trend = itemViewModel?.item?.current?.trend?.rawValue {
            self.priceTrend.text = trend
        }
        
        DispatchQueue.main.async { [unowned self] in
            if let graphView = Bundle(for: OSRSItemGraphView.self).loadNibNamed("OSRSItemGraphView", owner: self, options: nil)?.first as? OSRSItemGraphView {
                self.createGraph(graphView: graphView)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    func loadLargeIconImage() {
        if let itemImage = DataFormatter.dataToUIImage(data: self.itemViewModel?.largeIcon) {
            self.itemImageView.image = itemImage
        } else {
            self.itemImageView.image = nil
        }
    }
    
    func createGraph(graphView: OSRSItemGraphView) {
        guard let priceData = itemViewModel?.priceDataPoints else {
            return
        }
        graphView.generate(with: priceData)
        self.graphView.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["graph":graphView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[graph]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[graph]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
        
    }
    
    @objc func cancelAction(){
        self.removeFromSuperview()
    }
    
}
