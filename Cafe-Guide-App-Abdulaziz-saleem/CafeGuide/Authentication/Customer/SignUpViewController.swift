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
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
    Colors.Design(firstNameTextField)
    Colors.Design(lastNameTextField)
    Colors.Design(emailTextField)
    Colors.Design(passwordTextField)
    Colors.Design(confirmPasswordTextField)
  }
  
  
  //MARK: - IBAction
  
  @IBAction func signUp(_ sender: UIButton) {
    
    sigUp()
  }
  
  
  // MARK: - Methods 
  
  private  func sigUp() {
    
    guard let lastName = lastNameTextField.text,
          lastName.isEmpty == false else {
      errorLabel.isHidden = false
      errorLabel.text = "Fill in the last name"
      return
    }
    
    guard let firstName = firstNameTextField.text,
          firstName.isEmpty == false else {
      errorLabel.isHidden = false
      errorLabel.text = "Fill in the first name"
      return
    }
    
    guard let email = emailTextField.text,
          email.isEmpty == false else {
      errorLabel.isHidden = false
      errorLabel.text = "Fill in the email"
      return
    }
    
    guard let password = passwordTextField.text,
          password.isEmpty == false else {
      errorLabel.isHidden = false
      errorLabel.text = "Enter the password"
      return
    }
    guard let password2 = confirmPasswordTextField.text,
          password2.isEmpty == false else {
      errorLabel.isHidden = false
      errorLabel.text = "Enter the password"
      return
    }
    
    
    
    if password == password2 {
      
      FSUserManager
        .shared
        .signUpUserWith(email: email,
                        password: password,
                        password2: password2,
                        firstName: firstName,
                        lastName: lastName) { error in
          if error == nil {
            // Navigation
            let storybord =  UIStoryboard(name: "Main", bundle: nil)
            let vc = storybord
              .instantiateViewController(identifier: "go-to-CafeVC")
            
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true)
          } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = error?.localizedDescription
          }
        }
      
      
    } else {
      errorLabel.isHidden = false
      errorLabel.text = "Passwords Do Not Match"
    }
    
  }
}
