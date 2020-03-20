//
//  DrawerCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DrawerCollectionViewCellDelegate {
    func tapActionDrawer(userId: String, drawerId: String, drawerName: String)
}

class DrawerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var drawerImage: UIImageView!
    @IBOutlet weak var drawerNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    var drawerId: String?
    var drawerName: String?
    var userId: String?
    var delegate: DrawerCollectionViewCellDelegate?
    
    override var isHighlighted: Bool{
        didSet{
            if self.isHighlighted{
                backgroundColor = UIColor.init(named: "cosmetic-color-press")
            }else{
                backgroundColor = UIColor.init(named: "cosmetic-color")
            }
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        delegate?.tapActionDrawer(userId: userId!, drawerId: drawerId!, drawerName: drawerName!)
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
