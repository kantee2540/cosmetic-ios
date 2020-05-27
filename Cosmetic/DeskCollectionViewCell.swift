//
//  DeskCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DeskCollectionViewCellDelegate {
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath, button: UIButton)
}

class DeskCollectionViewCell: UICollectionViewCell {
    
    var deskId: String?
    var productId: String?
    var userId: String?
    var favoriteStatus: Bool = false
    var indexPath: IndexPath?
    var delegate: DeskCollectionViewCellDelegate?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func tapAction(_ sender: Any) {
        delegate?.tapAction(userId: userId!, productId: productId!, image: productImage.image!, indexPath: indexPath!, button: actionButton)
    }
    
    @IBAction func tapHeart(_ sender: Any) {
        
        let updateFavorite = UpdateFavorite()
        updateFavorite.delegate = self
        
        if favoriteStatus{
            //Remove
            updateFavorite.setFavorite(setFavorite: false, desk_id: deskId!)
        }else{
            //Update
            updateFavorite.setFavorite(setFavorite: true, desk_id: deskId!)
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

extension DeskCollectionViewCell: UpdateFavoriteDelegate{
    func updateFavoriteSuccess() {
        if favoriteStatus{
            setHeartOutlined()
            favoriteStatus = false
        }else{
            
            setHeartFill()
            favoriteStatus = true
        }
    }
    
    func updateFavoriteFailed(error: String) {
        
    }
    
    func setHeartFill(){
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = UIColor.red
    }
    
     func setHeartOutlined(){
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = UIColor.systemGray
    }
}
