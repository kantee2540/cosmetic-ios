//
//  DrawerCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class DrawerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var drawerImage: UIImageView!
    @IBOutlet weak var drawerNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    override var isHighlighted: Bool{
        didSet{
            if self.isHighlighted{
                backgroundColor = UIColor.init(named: "cosmetic-color-press")
            }else{
                backgroundColor = UIColor.init(named: "cosmetic-color")
            }
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                backgroundColor = UIColor.init(named: "cosmetic-color-press")
            }else{
                backgroundColor = UIColor.init(named: "cosmetic-color")
            }
        }
    }
}
