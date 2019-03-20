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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var currentDataTableView: UITableView!
    
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
        
        self.currentDataTableView.delegate = self
        self.currentDataTableView.dataSource = self
        
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

        self.createGraphIfPossible()
        
        self.currentDataTableView.reloadData()
    }
    func createGraphIfPossible() {
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
        if let priceData = itemViewModel?.priceDataPoints {
            graphView.generate(with: priceData)
        }
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

extension OSRSItemDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemViewModel?.currentDataContentCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = self.itemViewModel?.getCurrentData(label: .primary, for: indexPath.row)
        cell.detailTextLabel?.text = self.itemViewModel?.getCurrentData(label: .secondary, for: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.itemViewModel?.getCurrentDataHeader()
        return title
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
}
