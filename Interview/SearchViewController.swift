//
//  ViewController.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/15.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

// Note: A very skinny viewController
class SearchViewController: UITableViewController, SearchViewTrait {
    var interactor: SearchInteractorDelegate!
    var activityView: UIVisualEffectView?

    // MARK: - View LifeCyle
    override func awakeFromNib() {
        super.awakeFromNib()
        searchViewAwakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewDidLoad()
    }
    
    // MARK: - UITableView DataSource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewNumberOfRows()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return searchViewCellForRowAt(indexPath)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewSearchButtonClicked(searchBar)
    }
}

