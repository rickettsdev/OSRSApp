//
//  DataFormatter.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/21/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

public class DataFormatter {
    public class func dataToJSONDictionary(data: Data?) -> ([String:Any?])? {
        var jsonObject: Any?
        guard let data = data else {
            return nil
        }
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any?]
        } catch {
            return nil
        }
        guard let dataDictionary = jsonObject as? [String:Any?] else {
            return nil
        }
        return dataDictionary
    }
    public class func dataToUIImage(data: Data?) -> UIImage? {
        guard let data = data, let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
