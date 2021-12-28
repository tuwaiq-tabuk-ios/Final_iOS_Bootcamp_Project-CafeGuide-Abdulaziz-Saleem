//
//  LoginViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 19/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
  
  
  
  @IBOutlet weak var email: UITextField!
  
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var errorlb: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorlb.alpha = 0
    hideKeyboardWhenTappedAround()
    
  }
  
  @IBAction func Login(_ sender: UIButton) {
    
    let emailClear = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordClear = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    login(emailClear: emailClear, passwordClear: passwordClear)
  }
  
  
  
  func login(emailClear:String,
             passwordClear:String ) {
    Auth.auth().signIn(withEmail: emailClear,
                       password: passwordClear,
                       completion:{
      (authResult,error) in
      if error != nil {
        self.errorlb.alpha = 1
        self.errorlb.text = error?.localizedDescription
        
        
        
      }else{
        UserDefaults.standard.setValue(emailClear,
                                       forKey: "email")
        UserDefaults.standard.setValue(passwordClear,
                                       forKey: "password")
        UserDefaults.standard.synchronize()
        
        let storybord =  UIStoryboard(name: "Main",
                                      bundle: nil)
        let vc = storybord.instantiateViewController(identifier: "home")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
        
      }
    })
    
  }
}

