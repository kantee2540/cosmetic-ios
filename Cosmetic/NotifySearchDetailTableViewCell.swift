//
//  NotifySearchDetailTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 30/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class NotifySearchDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var notifyDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
