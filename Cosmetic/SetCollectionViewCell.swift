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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        contentView.layer.cornerRadius = 15
        layer.cornerRadius = 15
        layer.shadowColor =  UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
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
