//
//  DeskCollectionViewCell.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DeskCollectionViewCellDelegate {
    func tapAction(userId: Int, productId: Int, image: UIImage, indexPath: IndexPath, button: UIButton)
}

class DeskCollectionViewCell: UICollectionViewCell {
    
    var deskId: Int?
    var productId: Int?
    var userId: Int?
    var favoriteStatus: Bool = false
    var indexPath: IndexPath?
    var delegate: DeskCollectionViewCellDelegate?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    @IBAction func tapAction(_ sender: Any) {
        delegate?.tapAction(userId: userId!, productId: productId!, image: productImage.image!, indexPath: indexPath!, button: actionButton)
    }
    
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
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        contentView.layer.masksToBounds = true
    }
    
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
