//
//  AddressesDataSource.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation
import UIKit

class AddressesDataSource: GenericDataSource<Address> {
    var onDeleteAddress: ((Address) -> Void)?
}

extension AddressesDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = data.value.count
        if numberOfRows == 0 {
            tableView.setEmptyView(title: "You don't have any address.", message: "Use the search control to find and add new addresses.")
        }
        else {
            tableView.restore()
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        
        let address = data.value[indexPath.row]
        cell.address = address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let address = data.value[indexPath.row]
            if let index = data.value.firstIndex(where: { $0 === address }) {
                onDeleteAddress?(address)
                tableView.beginUpdates()
                // delete on datasource
                data.value.remove(at: index)
                tableView.deleteRows(at: [indexPath], with: .left)
                // delete on tableView
                tableView.endUpdates()
            }
        }
    }
}
