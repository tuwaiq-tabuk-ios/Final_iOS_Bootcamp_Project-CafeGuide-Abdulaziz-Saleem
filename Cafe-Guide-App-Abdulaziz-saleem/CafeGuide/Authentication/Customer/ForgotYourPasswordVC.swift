//
//  ForgotYourPasswordVC.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 23/05/1443 AH.
//

import UIKit
import FirebaseAuth


class ForgotYourPasswordVC: UIViewController {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var emailTextField: UITextField!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    Colors.Design(emailTextField)
    
  }
  
  
  // MARK: - IBAction
  
  @IBAction func forgotYourPassword(_ sender: UIButton) {
    
    let auth = Auth.auth()
    auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
      if let error = error {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel) { UIAlertAction in
        }
        alert.addAction(action)
        self.present(alert,
                     animated: true,
                     completion: nil)
        return
      }
      let alert = UIAlertController(title: "Succesfully",
                                    message: "A password reset email has been sent!",
                                    preferredStyle: UIAlertController.Style.alert)
      let action = UIAlertAction(title: "OK",
                                 style: .cancel) { UIAlertAction in
        self.navigationController?.popViewController(animated: true)
      }
      alert.addAction(action)
      self.present(alert,
                   animated: true,
                   completion: nil)
      
    }
  }
}



