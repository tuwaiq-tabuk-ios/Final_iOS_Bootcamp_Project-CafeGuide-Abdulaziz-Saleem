//
//  SignUpViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 19/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstName: UITextField!
  
  @IBOutlet weak var lastName: UITextField!
  
  @IBOutlet weak var email: UITextField!
  
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var errorlb: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorlb.alpha = 0
    hideKeyboardWhenTappedAround()
  }
  
  @IBAction func signUp(_ sender: UIButton) {
    if email.text?.isEmpty == true {
      errorlb.alpha = 1
      errorlb.text = "Fill in the email"
      return
    }
    
    if password.text?.isEmpty == true {
      errorlb.alpha = 1
      errorlb.text = "Enter the password"
      return
    }
    if firstName.text?.isEmpty == true {
      errorlb.alpha = 1
      errorlb.text = "Fill in the first name"
      return
    }
    if lastName.text?.isEmpty == true {
      errorlb.alpha = 1
      errorlb.text = "Fill in the Last name"
      return
    }
    
    sigUp()
  }
  
  
  
  
  func sigUp() {
    let firstName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    Auth.auth().createUser(withEmail: email,
                           password: password){
      (authResult,error) in
      if error != nil {
        self.errorlb.alpha = 1
        self.errorlb.text = error?.localizedDescription
      }else{
        let db = Firestore.firestore()
        db.collection("users").document(authResult!.user.uid).setData( ["firstName":firstName,
                                                                        "lastName":lastName]){
          (error) in
          if error != nil {
            self.errorlb.alpha = 1
            self.errorlb.text = error?.localizedDescription
          }else{
            let storybord =  UIStoryboard(name: "Main", bundle: nil)
            let vc = storybord.instantiateViewController(identifier: "home")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
          }
        }
      }
    }
  }
  
}
