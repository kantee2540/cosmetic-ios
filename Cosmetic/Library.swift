//
//  Util.swift
//  Cosmetic
//
//  Created by Omp on 23/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class Library {
    static func displayAlert(targetVC: UIViewController, title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in}))
        targetVC.present(alert, animated: true, completion: nil)
    }
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
    
    func add(_ child: UIViewController){
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
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
                DispatchQueue.main.async {
                    self.image = UIImage.init(named: "bg4")
                }
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
    
    //MARK: - Make round corners
    func makeRounded(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UITextField{
    
    //MARK: - TextField Underlined
    func setUnderLine(){
        let border = CALayer()
        let width = CGFloat(2)
        if self.isEditing{
            border.borderColor = UIColor.init(named: "main-font-color")?.cgColor
        }else{
            border.borderColor = UIColor.lightGray.cgColor
        }
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setGreenUnderline(){
        let border = CALayer()
        let width = CGFloat(2)
        border.borderColor = UIColor.green.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIButton{
    func roundedCorner(){
        self.layer.cornerRadius = 5
    }
    
}

extension UIView{
    
    func makeRoundedView(){
        self.layer.cornerRadius = 8
    }
}
