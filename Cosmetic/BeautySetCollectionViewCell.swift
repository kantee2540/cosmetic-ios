//
//  BeautySetCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 15/6/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol BeautySetCollectionViewCellDelegate {
    func tapBeautysetOption(indexPath: IndexPath, button: UIButton)
}

class BeautySetCollectionViewCell: UICollectionViewCell {
    
    var delegate: BeautySetCollectionViewCellDelegate?
    var indexPath: IndexPath?
    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        if UIDevice().userInterfaceIdiom == .phone
         {
             switch UIScreen.main.nativeBounds.height
             {
             case 1136:
                 //print("iPhone 5 or 5S or 5C")
                 imageWidth.constant = 145
             case 1334:
                 //print("iPhone 6/6S/7/8")
                 imageWidth.constant = 170
             case 1920, 2208:
                //print("iPhone 6+/6S+/7+/8+")
                 imageWidth.constant = 190
             case 2436:
                 //print("iPhone X/XS/11 Pro")
                 imageWidth.constant = 170
             case 2688:
                 //print("iPhone XS Max/11 Pro Max")
                 imageWidth.constant = 190
             case 1792:
                 //print("iPhone XR/ 11 ")
                 imageWidth.constant = 190
             default:
                 //print("Unknown")
                 imageWidth.constant = 170
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
    
    
    @IBAction func tapAction(_ sender: Any) {
        delegate?.tapBeautysetOption(indexPath: indexPath!, button: actionButton)
    }
    
}
