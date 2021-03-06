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
    
    static func setUserDefault(user: UserModel){
        UserDefaults.standard.set(user.userId ?? nil, forKey: ConstantUser.userId)
        UserDefaults.standard.set(user.firstName ?? nil, forKey: ConstantUser.firstName)
        UserDefaults.standard.set(user.lastName ?? nil, forKey: ConstantUser.lastName)
        UserDefaults.standard.set(user.nickname ?? nil, forKey: ConstantUser.nickName)
        UserDefaults.standard.set(user.email ?? nil, forKey: ConstantUser.email)
        UserDefaults.standard.set(user.profilepic ?? nil, forKey: ConstantUser.profilepic)
    }
    
    static func removeUserDefault(){
        UserDefaults.standard.removeObject(forKey: ConstantUser.userId)
        UserDefaults.standard.removeObject(forKey: ConstantUser.firstName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.lastName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.nickName)
        UserDefaults.standard.removeObject(forKey: ConstantUser.email)
        UserDefaults.standard.removeObject(forKey: ConstantUser.profilepic)
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
    
    // MARK: visibility methods

    public enum Visibility : Int {
        case visible = 0
        case invisible = 1
        case gone = 2
        case goneY = 3
        case goneX = 4
    }

    public var visibility: Visibility {
        set {
            switch newValue {
                case .visible:
                    isHidden = false
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .invisible:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .gone:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(true)?.isActive = true
                case .goneY:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(false)?.isActive = false
                case .goneX:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(true)?.isActive = true
            }
        }
        get {
            if isHidden == false {
                return .visible
            }
            if getConstraintY(false)?.isActive == true && getConstraintX(false)?.isActive == true {
                return .gone
            }
            if getConstraintY(false)?.isActive == true {
                return .goneY
            }
            if getConstraintX(false)?.isActive == true {
                return .goneX
            }
            return .invisible
        }
    }

    fileprivate func getConstraintY(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.height, createIfNotExists)
    }

    fileprivate func getConstraintX(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.width, createIfNotExists)
    }

    fileprivate func getConstraint(_ attribute: NSLayoutConstraint.Attribute, _ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        var result: NSLayoutConstraint? = nil
        for constraint in constraints {
            if constraint.firstAttribute == attribute && constraint.constant == 0 && constraint.relation == .equal {
                result = constraint
                break
            }
        }
        if result == nil && createIfNotExists {
            // create and add the constraint
            result = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            addConstraint(result!)
        }
        return result
    }
}
