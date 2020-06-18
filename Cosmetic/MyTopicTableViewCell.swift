//
//  MyTopicTableViewCell.swift
//  Cosmetic
//
//  Created by Omp on 3/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class MyTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topicCodeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
