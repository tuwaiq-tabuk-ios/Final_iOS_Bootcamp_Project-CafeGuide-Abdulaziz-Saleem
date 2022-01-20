//
//  FSUserManager.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 14/06/1443 AH.
//


import Foundation
import Firebase

class FSUserManager {
  static let shared = FSUserManager()
  
  private init() {}
  
  private var email: String = ""
  private var pasword: String = ""
  private var pasword2: String = ""
  private var firstName: String = ""
  private var lastName: String = ""
  
  // MARK: - Register
  
  func signUpUserWith(
    email: String,
    password: String,
    password2: String,
    firstName: String,
    lastName: String,
    completion: @escaping (_ error: Error?) -> Void
  ) {
    self.email = email
    self.pasword = password
    self.pasword2 = password2
    self.firstName = firstName
    self.lastName = lastName
    
    
    Auth
      .auth()
      .createUser(withEmail: email,
                  password: password) { (authDataResult, error) in
        completion(error)
        
        if error != nil {
          print("DEBUG: Error: \(String(describing:error?.localizedDescription))")
          completion(error)
        } else {
          getFSCollectionReference(.users)
            .document(authDataResult!.user.uid)
            .setData( ["firstName":firstName,
                       "lastName":lastName,
                       "type":"user"]) { (error) in
              if error != nil {
                completion(error)
              }
            }
        }
      }
  }
}
