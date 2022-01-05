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
  
  
  //MARK: - Outlet
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var errorlb: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorlb.alpha = 0
    hideKeyboardWhenTappedAround()
    Colors.Design(email)
    Colors.Design(password)
    
  }
  //MARK: - Action
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
        let db = Firestore.firestore()
        let documentRF = db.collection("users").document((authResult?.user.uid)!)
        documentRF.getDocument { snapchpot,error in
          if error != nil{
            print("error get user data: \(error?.localizedDescription)")
          }else {
            
            UserDefaults.standard.setValue(emailClear,
                                           forKey: "email")
            UserDefaults.standard.setValue(passwordClear,
                                           forKey: "password")
            UserDefaults.standard.synchronize()
            
            let data = snapchpot!.data()!
            let type = data["type"] as! String
            let storybord =  UIStoryboard(name: "Main",
                                          bundle: nil)
            if type == "owner"{
              let vc = storybord.instantiateViewController(withIdentifier: "owner")
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true)
              
            }else {
              let vc = storybord.instantiateViewController(identifier: "home")
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true)
              
            }
          }
        }
        
        
       
      
        
        
        
      }
    })
    
  }
}

