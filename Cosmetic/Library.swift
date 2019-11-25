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
