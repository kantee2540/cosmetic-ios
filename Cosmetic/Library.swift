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


var spinView: UIView!
extension UIViewController{
    
    //MARK: - Spinner
    func showSpinner(onView :UIView) {
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(named: "spinner-bg")
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
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
    
    //MARK: - Tap any screen to hide keyboard
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dimissKeyboard(){
        view.endEditing(true)
    }
}


extension UIImageView{
    
    //MARK: - DownloadImage
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


extension UITextField{
    
    //MARK: - TextField Underlined
    func setUnderLine(){
        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = UIColor.init(named: "main-font-color")?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
