//
//  Util.swift
//  Cosmetic
//
//  Created by Omp on 23/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class Library {
    
}

//MARK: - Spinner
var spinView: UIView!
extension UIViewController{
    
    func showSpinner(onView :UIView) {
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(named: "spinner-bg")
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        spinView = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            spinView?.removeFromSuperview()
            spinView = nil
        }
    }
}

//MARK: - DownloadImage
extension UIImageView{
    func getData(from url:URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL){
        getData(from: url){
            data, response, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}

//MARK: - TextField
extension UITextField{
    func setUnderLine(){
        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = UIColor.init(named: "main-font-color")?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
