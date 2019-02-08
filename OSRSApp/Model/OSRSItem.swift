//
//  OSRSItem.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/20/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation

public class OSRSItem: NSObject {
    var id: Int?
    var smallIconURL: URL?
    var largeIconURL: URL?
    var name: String?
    var itemDescription: String?
    var members: Bool?
    var current: ItemPrice?
    var today: ItemPrice?
    var day30: ItemValueChange?
    var day90: ItemValueChange?
    var day180: ItemValueChange?
    
    public init(dataDictionary: [String:Any?]) {
        if let id = dataDictionary["id"] as? Int {
            self.id = id
        }
        if let icon = dataDictionary["icon"] as? String, let iconURL = URL(string: icon) {
            self.smallIconURL = iconURL
        }
        if let iconLarge = dataDictionary["icon_large"] as? String, let iconLargeURL = URL(string: iconLarge)  {
            self.largeIconURL = iconLargeURL
        }
        if let name = dataDictionary["name"] as? String {
            self.name = name
        }
        if let description = dataDictionary["description"] as? String {
            self.itemDescription = description
        }
        if let members = dataDictionary["members"] as? Bool {
            self.members = members
        }
        if let current = dataDictionary["current"] as? [String:Any?] {
            self.current = ItemPrice.init(dataDictionay: current)
        }
        if let today = dataDictionary["today"] as? [String:Any?] {
            self.today = ItemPrice.init(dataDictionay: today)
        }
        if let day30 = dataDictionary["day30"] as? [String:Any?] {
            self.day30 = ItemValueChange.init(dataDictionay: day30)
        }
        if let day90 = dataDictionary["day90"] as? [String:Any?] {
            self.day90 = ItemValueChange.init(dataDictionay: day90)
        }
        if let day180 = dataDictionary["day180"] as? [String:Any?] {
            self.day180 = ItemValueChange.init(dataDictionay: day180)
        }
    }
}

public enum ValueTrend: String {
    case negative
    case neutral
    case positive
    
    init?(value: String){
        switch value {
        case "negative":
            self =  .negative
        case "neutral":
            self = .neutral
        case "positive":
            self = .positive
        default:
            return nil
        }
    }
}

class ItemValue: NSObject {
    var trend: ValueTrend?
    
    public init(dataDictionary: [String:Any?]) {
        if let trend = dataDictionary["trend"] as? String {
            self.trend = ValueTrend.init(value: trend)
        }
    }
}

class ItemPrice: ItemValue {
    var price: String?
    public init(dataDictionay: [String:Any?]){
        super.init(dataDictionary: dataDictionay)
    }
}

class ItemValueChange: ItemValue {
    var valueChange: String?
    public init(dataDictionay: [String:Any?]){
        super.init(dataDictionary: dataDictionay)
    }
}
