//
//  ViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 18.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
        
    }
    
    func setupView(){
        facebookButton.layer.cornerRadius = 18
        signUpButton.layer.cornerRadius = 18
        googleButton.layer.cornerRadius = 18
        logInButton.layer.cornerRadius = 18
    }
    
    
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func LoginDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
