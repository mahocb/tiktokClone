//
//  LoginViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 19.03.2024.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupEmailTextfield()
        setupPasswordTextfield()
        setupView()

       
    }
    
    

    
    @IBAction func loginDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.Login {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd:  SceneDelegate =  (scene?.delegate as? SceneDelegate) {
                sd.configureInitialViewController()
            }
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

    }
    
}

extension LoginViewController {
    func Login(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        ProgressHUD.succeed("Loading...")
        Api.user.Login(email: self.emailTextfield.text!, password: self.passwordTextfield.text!) {
            ProgressHUD.dismiss()
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }


    }
    func validateFields(){
        
        guard let email = self.emailTextfield.text, !email.isEmpty else {
            ProgressHUD.failed("Please enter an email")
            return
        }
        guard let password = self.passwordTextfield.text, !password.isEmpty else {
            ProgressHUD.failed("Please enter an password")
            return
        }
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupEmailTextfield(){
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailContainerView.layer.cornerRadius = 20
        emailContainerView.clipsToBounds = true
        emailTextfield.borderStyle = .none
        
        
    }
    func setupPasswordTextfield(){
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordContainerView.layer.cornerRadius = 20
        passwordContainerView.clipsToBounds = true
        passwordTextfield.borderStyle = .none
        
        
    }
    func setupView(){
        LoginButton.layer.cornerRadius = 18
    }
}
