//
//  ProfileViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Başcı on 28.03.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func logoutAction(_ sender: Any) {
        Api.user.logOut()
    }
    
}
