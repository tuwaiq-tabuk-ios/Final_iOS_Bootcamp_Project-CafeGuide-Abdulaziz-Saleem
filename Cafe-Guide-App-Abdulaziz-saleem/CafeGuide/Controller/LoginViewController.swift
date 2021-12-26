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
        // Do any additional setup after loading the view.
    }
  
  @IBAction func Login(_ sender: UIButton) {
    
    let emailClear = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordClear = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
   
    Auth.auth().signIn(withEmail: emailClear, password: passwordClear, completion:{
      (authResult,error) in
      if error != nil {
        self.errorlb.alpha = 1
        self.errorlb.text = error?.localizedDescription
    
    
    
  }else{

    let storybord =  UIStoryboard(name: "Main", bundle: nil)
    let vc = storybord.instantiateViewController(identifier: "home")
    vc.modalPresentationStyle = .overFullScreen
    self.present(vc, animated: true)


  }
  })
    }
  
  
  @IBAction func dontHaveAccount(_ sender: UIButton) {
//    let storybord =  UIStoryboard(name: "Main", bundle: nil)
//    let vc = storybord.instantiateViewController(identifier: "signUp")
//    vc.modalPresentationStyle = .overFullScreen
//    present(vc, animated: true)
    
  }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

