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
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.alpha = 0
    hideKeyboardWhenTappedAround()
    Colors.Design(firstNameTextField)
    Colors.Design(lastNameTextField)
    Colors.Design(emailTextField)
    Colors.Design(passwordTextField)
  }
  
  
  //MARK: - IBAction
  
  @IBAction func signUp(_ sender: UIButton) {
    if emailTextField.text?.isEmpty == true {
      errorLabel.alpha = 1
      errorLabel.text = "Fill in the email"
      return
    }
    
    if passwordTextField.text?.isEmpty == true {
      errorLabel.alpha = 1
      errorLabel.text = "Enter the password"
      return
    }
    if firstNameTextField.text?.isEmpty == true {
      errorLabel.alpha = 1
      errorLabel.text = "Fill in the first name"
      return
    }
    if lastNameTextField.text?.isEmpty == true {
      errorLabel.alpha = 1
      errorLabel.text = "Fill in the Last name"
      return
    }
    
    sigUp()
  }
  
  
  //MARK: - Functions
  
  func sigUp() {
    
    let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    Auth.auth().createUser(withEmail: email,
                           password: password){
      (authResult,error) in
      if error != nil {
        self.errorLabel.alpha = 1
        self.errorLabel.text = error?.localizedDescription
      }else{
        let db = Firestore.firestore()
        db.collection("users").document(authResult!.user.uid).setData( ["firstName":firstName,"lastName":lastName,"type":"user"]){
          (error) in
          if error != nil {
            self.errorLabel.alpha = 1
            self.errorLabel.text = error?.localizedDescription
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
