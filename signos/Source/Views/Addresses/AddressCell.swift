//
//  AddressCell.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var address: Address? {
        didSet {
            guard let address = address else {
                return
            }

            nameLabel?.text = address.name
            addressLabel?.text = address.formattedAddress
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
