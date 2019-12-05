//
//  PackageViewController.swift
//  Cosmetic
//
//  Created by Omp on 4/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController, UITextFieldDelegate, DownloadTopicProtocol {
    func topicDownloaded(item: NSMutableArray) {
        if item.count >= 1{
            let topicVc = storyboard?.instantiateViewController(withIdentifier: "TopTopic") as? TopTopicViewController
            var topicItem :[TopicModel] = []
            topicItem = item as! [TopicModel]
            topicVc?.topicId = topicItem[0].topic_id
            topicVc?.topicName = topicItem[0].topic_name
            topicVc?.topicDescription = topicItem[0].topic_description
            topicVc?.topicImg = topicItem[0].topic_img
            
            self.present(topicVc!, animated: true)
        }
        
        else{
            let alert = UIAlertController(title: "Your code has't package code", message: "Please try another code to get cosmetic package", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    

    @IBOutlet weak var codeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        codeField.delegate = self
        codeField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        codeField.setUnderLine()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Package"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count == 6{
            let downloadTopic = DownloadTopic()
            downloadTopic.delegate = self
            downloadTopic.getTopicId(code: textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
