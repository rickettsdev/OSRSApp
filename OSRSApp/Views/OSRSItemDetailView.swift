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
        
        if let itemImageData = itemViewModel?.priceDataPoints {
            createGraph(using: itemImageData)
        }
        if let title = itemViewModel?.item?.name {
            self.title.text = title
        }
        if let description = itemViewModel?.item?.itemDescription {
            self.itemDescription.text = description
        }
        if let trend = itemViewModel?.item?.current?.trend?.rawValue {
            self.priceTrend.text = trend
        }
    }
    func loadLargeIconImage() {
        if let itemImage = DataFormatter.dataToUIImage(data: self.itemViewModel?.largeIcon) {
            self.itemImageView.image = itemImage
        } else {
            self.itemImageView.image = nil
        }
    }
    
    func createGraph(using data: OSRSItemPriceData?) {
        print("HERE")
    }
    
    @objc func cancelAction(){
        self.removeFromSuperview()
    }
    
}
