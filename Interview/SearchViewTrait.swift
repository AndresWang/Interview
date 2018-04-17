//
//  SearchViewTrait.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Note: SearchViewTrait and its extension not noly make our SearchViewController extremely light, but also make its code shareable for all UITableViewControllers. This is protocol oriented programming's composition. I prefer composition over inheritance, because it is much more flexible. I used this technique in my own project because I have four UITableViewControllers which need the same essential funtionality, but each view still can has its own specialties.
protocol SearchViewTrait: UISearchBarDelegate, ActivityIndicatable {
    var interactor: SearchInteractorDelegate! {get set}
    func searchViewAwakeFromNib()
    func searchViewDidLoad()
    func searchViewNumberOfRows() -> Int
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar)
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
        tableView.rowHeight = 120
        title = NSLocalizedString("Search", comment: "NavigationBar title")
        addSearchController()
        startLocationService()
    }
    
    // MARK: - UITableView DataSource & Delegate
    func searchViewNumberOfRows() -> Int {
        var numberOfRows = 0
        if interactor.result != nil {numberOfRows += 1}
        if interactor.currentWeather != nil {numberOfRows += 1}
        return numberOfRows
    }
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        let data: Weather
        if let currentWeather = interactor.currentWeather, indexPath.row == 0 {
            data = currentWeather
        } else {
            data = interactor.result!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        cell.configure(data)
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
    
    // MARK: - Private Methods
    private func addSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = NSLocalizedString("City Name", comment: "A placeholder to search weather" )
        navigationItem.searchController = search
    }
    private func startLocationService() {
        let request = LocationRequest(successHandler: locationSuccessHandler, errorHandler: locationErrorHandler)
        let shouldShowDeniedAlert = interactor.startLocationService(request: request)
        if shouldShowDeniedAlert {showLocationServicesDeniedAlert()}
    }
    private func startSearch(_ searchBar: UISearchBar, _ text: String) {
        searchBar.resignFirstResponder()
        let request = SearchRequest(text: text, successHandler: searchSuccessHandler, errorHandler: searchErrorHandler)
        interactor.search(request: request)
        startActivityIndicator()
    }
    private func searchSuccessHandler(searchText: String?) {
        endSearch()
        if let text = searchText {
            interactor.saveSuccessfulQuery(searchText: text)
        } else {
            showNothingFoundError()
        }
    }
    private func searchErrorHandler() {
        endSearch()
        showNetworkError()
    }
    private func endSearch() {
        stopActivityIndicator()
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
    }
    private func locationSuccessHandler() {
        tableView.reloadData()
    }
    private func locationErrorHandler() {
        print("Failed to get location...")
    }
}
