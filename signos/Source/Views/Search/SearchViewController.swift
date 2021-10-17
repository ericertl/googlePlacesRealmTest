//
//  SearchViewController.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

import UIKit

class SearchViewController: UITableViewController {
    var searchText: DynamicValue<String?> = DynamicValue(nil)
    var locationType: String?
    var onAddAddress: ((Address) -> Void)?
    private let dataSource = SearchDataSource()
    private lazy var viewModel : SearchViewModel = {
        let viewModel = SearchViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = dataSource
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        dataSource.onAddAddress = { [weak self] address in
            self?.onAddAddress?(address)
        }
        
        searchText.addAndNotify(observer: self) { [weak self] input in
            guard let self = self else {
                return
            }
            if let input = input, !input.isEmpty {
                self.viewModel.fetchAddresses(input: input, type: self.locationType)
            } else {
                self.viewModel.clearDataSource()
            }
        }
        
        viewModel.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Oops", message: "Something went wrong!", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
                
            UIView.animate(withDuration: 0.3) {
                cell.bottomView.isHidden = !cell.bottomView.isHidden
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
