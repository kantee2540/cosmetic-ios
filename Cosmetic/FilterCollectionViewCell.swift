//
//  FilterCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 2/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.backgroundColor = UIColor.systemOrange
                filterLabel.textColor = UIColor.white
            }else{
                self.backgroundColor = UIColor.systemGroupedBackground
                filterLabel.textColor = UIColor.label
            }
        }
    }
}
