//
//  BeautyCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 16/6/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class BeautyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beautysetImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userlabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        profileImage.makeRounded()
    }
    
    override var isHighlighted: Bool{
        didSet{
            if self.isHighlighted{
                backgroundColor = UIColor.tertiaryLabel
            }else{
                backgroundColor = UIColor.secondarySystemGroupedBackground
            }
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                backgroundColor = UIColor.tertiaryLabel
            }else{
                backgroundColor = UIColor.secondarySystemGroupedBackground
            }
        }
    }
}
