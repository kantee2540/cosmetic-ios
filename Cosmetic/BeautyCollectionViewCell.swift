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
    @IBOutlet weak var setImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        profileImage.makeRounded()
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                setImageWidth.constant = 280
            case 1334:
                //print("iPhone 6/6S/7/8")
                setImageWidth.constant = 330
            case 1920, 2208:
               //print("iPhone 6+/6S+/7+/8+")
                setImageWidth.constant = 330
            case 2436:
                //print("iPhone X/XS/11 Pro")
                setImageWidth.constant = 330
            case 2688:
                //print("iPhone XS Max/11 Pro Max")
                setImageWidth.constant = 350
            case 1792:
                //print("iPhone XR/ 11 ")
                setImageWidth.constant = 350
            default:
                //print("Unknown")
                setImageWidth.constant = 330
            }
        }
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
