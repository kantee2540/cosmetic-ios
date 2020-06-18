//
//  SearchDetailTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 2/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
