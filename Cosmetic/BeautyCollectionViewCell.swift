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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        contentView.layer.cornerRadius = 8
        layer.shadowColor =  UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
    }
    
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
        else if UIDevice().userInterfaceIdiom == .pad{
            setImageWidth.constant = 370
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
