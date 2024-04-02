//
//  CreatePostViewController.swift
//  tiktokClone3
//
//  Created by Mahmut Başcı on 2.04.2024.
//

import UIKit

class CreatePostViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var captureButtonRingView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius =  68/2
        captureButtonRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 0.5).cgColor
        captureButtonRingView.layer.borderWidth = 6
        captureButtonRingView.layer.cornerRadius = 85/2
    }
    

   

}
