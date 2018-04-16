//
//  SearchViewTrait.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewTrait: UISearchBarDelegate, ActivityIndicatable {
    var interactor: SearchInteractorDelegate! {get set}
    func searchViewAwakeFromNib()
    func searchViewDidLoad()
    func searchViewNumberOfRows() -> Int
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell
    func searchViewDidSelectRowAt(_ indexPath: IndexPath)
}

extension SearchViewTrait where Self: UITableViewController {
    // MARK: - View Life Cycle
    func searchViewAwakeFromNib() {
        // Hook up all components
        let interactor: SearchInteractorDelegate = SearchInteractor()
        interactor.configure()
        self.interactor = interactor
    }
    func searchViewDidLoad() {
        title = NSLocalizedString("Search", comment: "NavigationBar title")
        // Add UISearchController
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = NSLocalizedString("City Name", comment: "A placeholder to search weather" )
        navigationItem.searchController = search
    }
    
    // MARK: - UITableView DataSource & Delegate
    func searchViewNumberOfRows() -> Int {
        return interactor.result == nil ? 0 : 1
    }
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        cell.configure(interactor.result!)
        return cell
    }
    func searchViewDidSelectRowAt(_ indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        /* Basically we will get searchBar text for sure because iOS's Search Button is auto enabled only when there are texts.
         But the safer the better.*/
        guard let text = searchBar.text, !text.isEmpty else {
            print("No String Entered")
            searchBar.resignFirstResponder()
            return
        }
        startSearch(searchBar, text)
    }
    
    private func startSearch(_ searchBar: UISearchBar, _ text: String) {
        searchBar.resignFirstResponder()
        let request = SearchRequest(text: text, successHandler: successHandler, errorHandler: errorHandler)
        interactor.search(request: request)
        startActivityIndicator()
    }
    private func successHandler(searchText: String?) {
        endSearch()
        if let text = searchText {
            interactor.saveSuccessfulQuery(searchText: text)
        } else {
            showNothingFoundError()
        }
    }
    private func errorHandler() {
        endSearch()
        showNetworkError()
    }
    private func endSearch() {
        stopActivityIndicator()
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
    }
}
