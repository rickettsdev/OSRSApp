//
//  OSRSItemCell.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/21/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

class OSRSItemCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    var viewModel: OSRSItemViewModel? {
        didSet {
            guard self.viewModel != nil else {
                return
            }
            self.setup()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.imageView?.image = nil
        self.itemTitle.text = ""
        self.itemDetails.text = ""
    }
    
    func setup() {
        if let smallIcon = DataFormatter.dataToUIImage(data: self.viewModel?.smallIcon) {
            self.imageView?.image = smallIcon
        } else {
            self.imageView?.image = nil
        }
        if let title = self.viewModel?.item?.name {
            self.itemTitle.text = title
        }
        if let desc = self.viewModel?.item?.itemDescription {
            self.itemDetails.text = desc
        }
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
    }
}
