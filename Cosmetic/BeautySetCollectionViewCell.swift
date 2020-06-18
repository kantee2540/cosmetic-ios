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
