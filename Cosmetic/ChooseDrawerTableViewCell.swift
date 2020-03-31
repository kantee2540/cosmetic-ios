//
//  ChooseDrawerTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 31/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class ChooseDrawerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            accessoryType = .checkmark
        }else{
            accessoryType = .none
        }
        // Configure the view for the selected state
    }

}
