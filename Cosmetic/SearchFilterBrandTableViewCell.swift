//
//  SearchFilterBrandTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 6/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class SearchFilterBrandTableViewCell: UITableViewCell {

    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected{
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }

}
