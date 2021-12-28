//
//  mainViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 24/05/1443 AH.
//

import UIKit
import FirebaseAuth


class MainViewController: UIViewController {
  
  @IBOutlet weak var login: UIButton!
  @IBOutlet weak var signUp: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let email = UserDefaults.standard.string(forKey: "email")
    let password = UserDefaults.standard.string(forKey: "password")
    
    if (email != nil || password != nil) {
      login(emailClear: email!,
            passwordClear: password!)
    }
  }
  
  
  
  func login(emailClear:String, passwordClear:String ) {
    Auth.auth().signIn(withEmail: emailClear,
                       password: passwordClear,
                       completion:{
      (authResult,error) in
      if error != nil {
        
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
