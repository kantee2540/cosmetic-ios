//
//  BeautySetCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 15/6/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class BeautySetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var topicImage: UIImageView!
    
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
