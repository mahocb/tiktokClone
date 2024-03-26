//
//  Ref.swift
//  tiktokClone3
//
//  Created by Mahmut Can Başcı on 22.03.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let REF_USER = "users"
let STORAGE_PROFİLE = "profile"
let URL_STORAGE_ROOT = "gs://tiktoktutorial-20075.appspot.com"
let UID = "uid"
let EMAIL = "email"
let USERNAME = "username"
let PROFILE_IMAGE_URL = "profileImageUrl"
let STATUS = "status"

class Ref {
    let dataBaseRoot = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return dataBaseRoot.child(REF_USER)
    }
    
    func databaseSpesificUser(uid: String) -> DatabaseReference{
        return databaseUsers.child(uid)
    }
    
    //Storage Ref
    
    let StorageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference{
        return StorageRoot.child(STORAGE_PROFİLE)
    }
    
    func storageSpesificProfile(uid: String) -> StorageReference {
        return  storageProfile.child(uid)
    }
    
    
}
