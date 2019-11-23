//
//  CameraResultTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 7/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CameraResultTableViewCell: UITableViewCell {

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
