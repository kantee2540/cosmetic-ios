//
//  PickforyouCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 29/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class PickforyouCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
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
