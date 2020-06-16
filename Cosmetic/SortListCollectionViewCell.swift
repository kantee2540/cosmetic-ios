//
//  SortListCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 16/6/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class SortListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sortLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                sortLabel.textColor = UIColor.label
            }else{
                sortLabel.textColor = UIColor.secondaryLabel
            }
        }
    }
}
