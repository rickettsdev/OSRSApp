//
//  ViewController+UISearchBar.swift
//  OSRSApp
//
//  Created by Thomas Ricketts on 1/23/19.
//  Copyright © 2019 Thomas Ricketts. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.searchForItems(searchString: searchBar.text)
        searchBar.resignFirstResponder()
    }
}
