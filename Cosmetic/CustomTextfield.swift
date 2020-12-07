//
//  CustomTextfield.swift
//  Cosmetic
//
//  Created by Omp on 29/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }

    @IBInspectable var leftPadding: CGFloat = 0{
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0{
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            setcornerRadius()
        }
    }
    
    @IBInspectable var leftImage: UIImage?{
        didSet{
            updateView()
        }
    }
    
    func setcornerRadius(){
        layer.cornerRadius = cornerRadius
    }
    
    func updateView() {
        if let image = leftImage{
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let spacing = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            spacing.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = self.tintColor
            leftView = spacing
        }
    }

}
