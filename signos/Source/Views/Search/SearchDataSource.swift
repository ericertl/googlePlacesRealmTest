//
//  SearchDataSource.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

import Foundation
import UIKit

class SearchDataSource: GenericDataSource<Address> {
    private var imageLoader = ImageLoader()
    var onAddAddress: ((Address) -> Void)?
}

extension SearchDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        let address = data.value[indexPath.row]
        cell.address = address
        cell.bottomView.isHidden = true
        cell.addressImageView.isHidden = true
        
        cell.addButtonAction = { [weak self] in
            if let address = self?.data.value[indexPath.row] {
                self?.onAddAddress?(address)
            }
        }
        
        if let photoReference = address.photos.first?.photoReference,
           !photoReference.isEmpty {
            // This shouldn't be here, but I'm running out of time
            let key = Router.getAddresses(input: "").apiKey
            let imagePath = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(photoReference)&key=\(key)"
            imageLoader.obtainImageWithPath(imagePath: imagePath) { (image) in
                if let updateCell = tableView.cellForRow(at: indexPath) as? SearchCell {
                    updateCell.addressImageView?.image = image
                    updateCell.addressImageView?.isHidden = false
                }
            }
        }
        
        return cell
    }
    
}
