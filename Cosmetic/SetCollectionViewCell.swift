//
//  SetCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 1/2/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class SetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var setImage: UIImageView!
    @IBOutlet weak var setName: UILabel!
    
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
