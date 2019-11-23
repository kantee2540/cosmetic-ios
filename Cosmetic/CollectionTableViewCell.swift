//
//  CollectionTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 4/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var detailTextView: UILabel!
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
