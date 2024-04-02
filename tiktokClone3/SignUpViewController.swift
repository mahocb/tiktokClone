//
//  SignUpViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 18.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import ProgressHUD


class SignUpViewController: UIViewController {

    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUsernameTextfield()
        setupEmailTextfield()
        setupPasswordTextfield()
        setupView()

        
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Create new account"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupUsernameTextfield(){
        usernameContainerView.layer.borderWidth = 1
        usernameContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        usernameContainerView.layer.cornerRadius = 20
        usernameContainerView.clipsToBounds = true
        usernameTextfield.borderStyle = .none
        
        
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
        avatar.layer.cornerRadius = 60
        signUpButton.layer.cornerRadius = 18
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    func validateFields(){
        guard let username = self.usernameTextfield.text, !username.isEmpty else {
            ProgressHUD.failed("Please enter an username")
            return
        }
        guard let email = self.emailTextfield.text, !email.isEmpty else {
            ProgressHUD.failed("Please enter an email")
            return
        }
        guard let password = self.passwordTextfield.text, !password.isEmpty else {
            ProgressHUD.failed("Please enter an password")
            return
        }
    }
    
    
    

    @IBAction func signUpDidTapped(_ sender: Any) {
        
        self.validateFields()
        
        self.signUp {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd:  SceneDelegate =  (scene?.delegate as? SceneDelegate) {
                sd.configureInitialViewController()
            }
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

        
        
      }
    
    }
extension SignUpViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for  item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let imageSelected = image as?  UIImage {
                    DispatchQueue.main.sync {
                        self.avatar.image = imageSelected
                        self.image = imageSelected
                    }
                    
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func presentPicker(){
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let picker: PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
}
extension SignUpViewController {
    func signUp(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        ProgressHUD.succeed("Loading...")
        Api.user.signUp(withUsername: self.usernameTextfield.text!, email: self.emailTextfield.text!, password: self.passwordTextfield.text!, image: self.image) {
            ProgressHUD.dismiss()
            onSuccess()
        }
            onError: {
                errorMessage in
            onError(errorMessage)
        }

    }
}
   


