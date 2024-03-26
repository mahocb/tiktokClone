//
//  UserApi.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 20.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD
import UIKit

class UserApi {
    
    func Login(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { authdata, error in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            print(authdata?.user.uid)
            onSuccess()
        }
    }
    
    
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard let imageSelected = image else {
            ProgressHUD.failed("Please enter a profile image")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { AuthDataResult, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            if let authData = AuthDataResult {
                var dict: [String: Any] = [
                    UID: authData.user.uid,
                    EMAIL: authData.user.email ?? "",
                    USERNAME: username,
                    PROFILE_IMAGE_URL: "",
                    STATUS: ""
                ]
               
                
                let storageProfileRef = Ref().storageSpesificProfile(uid: authData.user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metadata, StorageProfileRef: storageProfileRef, dict: dict) { onSuccess ()}  onError: {errorMessage in onError(errorMessage)}
                
            }
        }
    }
}


