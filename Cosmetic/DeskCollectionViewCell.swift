//
//  DeskCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DeskCollectionViewCellDelegate {
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath)
}

class DeskCollectionViewCell: UICollectionViewCell {
    
    var productId: String?
    var userId: String?
    var indexPath: IndexPath?
    var delegate: DeskCollectionViewCellDelegate?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func tapAction(_ sender: Any) {
        delegate?.tapAction(userId: userId!, productId: productId!, image: productImage.image!, indexPath: indexPath!)
    }
}