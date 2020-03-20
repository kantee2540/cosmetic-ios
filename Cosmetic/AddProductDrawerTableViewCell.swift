//
//  AddProductDrawerTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class AddProductDrawerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
    @IBOutlet weak var priceTextView: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
