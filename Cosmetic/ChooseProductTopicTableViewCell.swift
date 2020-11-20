//
//  ChooseProductTopicTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 1/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class ChooseProductTopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
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
    }

}
