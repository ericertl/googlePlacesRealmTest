//
//  AddressesViewController.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import UIKit

class AddressesViewController: UITableViewController {
    private let dataSource = AddressesDataSource()
    private lazy var viewModel : AddressesViewModel = {
        AddressesViewModel(dataSource: dataSource)
    }()
    private var searchController: UISearchController!
    private var searchViewController: SearchViewController!
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Addresses"
        
        setupSearchController()
        setupRefreshControl()
        setupDataSource()
        
        startRefreshingAddresses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func startRefreshingAddresses() {
        refreshControl?.beginRefreshing()
        refreshControl?.sendActions(for: .valueChanged)
    }
    
    private func setupSearchController() {
        searchViewController = storyboard!.instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController
        searchViewController.onAddAddress = { [weak self] address in
            guard let self = self else { return }
            self.viewModel.addAddress(address: address)
            self.searchController?.isActive = false
            self.searchBarCancelButtonClicked(self.searchController.searchBar)
            self.startRefreshingAddresses()
        }
        
        searchController = UISearchController(searchResultsController: searchViewController)
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find an address"
        searchController.searchBar.scopeButtonTitles = LocationType.allCases.map { $0.description }
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsScopeBar = false
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(getAddresses(_:)), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Getting Addresses...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    private func setupDataSource() {
        tableView.dataSource = dataSource
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        dataSource.onDeleteAddress = { [weak self] address in
            self?.viewModel.deleteAddress(place_id: address.placeId)
        }
    }
    
    @objc private func getAddresses(_ sender: Any) {
        // Get Address Data
        viewModel.fetchAddresses()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Pin to top") { [weak self] (contextualAction, view, boolValue) in
            guard let self = self else { return }
            let address = self.dataSource.getAddress(indexPath: indexPath)
            self.viewModel.pinAddress(place_id: address.placeId)
            self.startRefreshingAddresses()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

// MARK: Search

extension AddressesViewController {
    func searchFor(_ searchText: String?) {
        guard searchController.isActive else { return }
        guard let searchText = searchText else {
            searchViewController.searchText.value = nil
            return
        }
        let selectedLocationType = selectedScopeLocationType()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.searchViewController.locationType = selectedLocationType
            self.searchViewController.searchText.value = searchText
        })
    }
  
    func selectedScopeLocationType() -> String {
        guard let scopeButtonTitles = searchController.searchBar.scopeButtonTitles else {
            return LocationType.all.description
        }
        return scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
    }
  
    private func showScopeBar(_ show: Bool) {
        guard searchController.searchBar.showsScopeBar != show else { return }
        searchController.searchBar.setShowsScope(show, animated: true)
        view.setNeedsLayout()
    }
}

extension AddressesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchController.searchBar.text else { return }
        searchFor(searchText)
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
        let showScope = !searchText.isEmpty
        showScopeBar(showScope)
    }
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewController.searchText.value = nil
        showScopeBar(false)
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
}

extension AddressesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.searchTextField.isFirstResponder {
            searchController.showsSearchResultsController = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        } else {
            searchController.searchBar.searchTextField.backgroundColor = nil
        }
    }
}
