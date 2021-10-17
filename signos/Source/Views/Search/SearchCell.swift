//
//  SearchCell.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var bottomView: UIStackView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addressImageView: UIImageView!{
        didSet {
            addressImageView.isHidden = true
        }
    }
    
    var addButtonAction : (() -> Void)?
    
    var address: Address? {
        didSet {
            guard let address = address else {
                return
            }

            nameLabel?.text = address.name
            addressLabel?.text = address.formattedAddress
            typesLabel?.text = address.types.joined(separator: ", ")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func addButtonTapped(_ sender: UIButton){
        addButtonAction?()
    }
}

