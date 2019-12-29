//
//  AccountDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 30/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountDetailTableViewController: UITableViewController {
    
    private var uid: String?
    private var firstname: String?
    private var lastname: String?
    private var nickname: String?
    private var email: String?
    private var gender: String?
    private var birthday: String?
    private var createdUserDate: Date?
    private var lastSigninDate: Date?

    @IBOutlet var accountDetailTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Account Detail"
        accountDetailTable.delegate = self
        
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            let createdDate = Auth.auth().currentUser?.metadata.creationDate
            let lastSigninDate = Auth.auth().currentUser?.metadata.lastSignInDate
            if let user = user{
                uid = user.uid
                email = user.email
                firstname = UserDefaults.standard.string(forKey: ConstantUser.firstName)
                lastname = UserDefaults.standard.string(forKey: ConstantUser.lastName)
                nickname = UserDefaults.standard.string(forKey: ConstantUser.nickName)
                gender = UserDefaults.standard.string(forKey: ConstantUser.gender)
                birthday = UserDefaults.standard.string(forKey: ConstantUser.birthday)
                self.createdUserDate = createdDate
                self.lastSigninDate = lastSigninDate
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 7
        default:
            return 2
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(accountDetailTable, cellForRowAt: indexPath)
        cell.detailTextLabel?.textColor = UIColor.secondaryLabel
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                //uid
                cell.detailTextLabel?.text = uid
            case 1:
                //firstname
                cell.detailTextLabel?.text = firstname
            case 2:
                cell.detailTextLabel?.text = lastname
            case 3:
                cell.detailTextLabel?.text = email
            case 4:
                cell.detailTextLabel?.text = nickname
            case 5:
                cell.detailTextLabel?.text = gender
            case 6:
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                dateFormat.locale = Locale.init(identifier: "en_GB")
                let dateObj = dateFormat.date(from: birthday!)
                dateFormat.dateFormat = "dd MMMM yyyy"
                cell.detailTextLabel?.text = dateFormat.string(from: dateObj!)
            default:
                break
            }
            
        }else if indexPath.section == 1{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd MMMM yyyy HH:MM"
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = dateFormat.string(from: createdUserDate!)
            case 1:
                cell.detailTextLabel?.text = dateFormat.string(from: lastSigninDate!)
            default:
                break
            }
        }

        // Configure the cell...

        return cell
    }

}
