//
//  StorageService.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 20.03.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import ProgressHUD

class StorageService {
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, StorageProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        
        StorageProfileRef.putData(data, metadata: metadata) { storageMetadata, error in
            if  error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            StorageProfileRef.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString{
                    print(metaImageUrl)
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                            if let error = error {
                                ProgressHUD.failed(error.localizedDescription)
                            }
                        }
                    }
                    var dictTemp = dict
                    dictTemp["profileImageUrl"] = metaImageUrl
                    Ref().databaseSpesificUser(uid: uid ).updateChildValues(dictTemp) { error, ref in
                        if let error = error {
                            onError(error.localizedDescription)
                        } else {
                            onSuccess()
                        }
                    }
                }
            }
        }
    }
}
