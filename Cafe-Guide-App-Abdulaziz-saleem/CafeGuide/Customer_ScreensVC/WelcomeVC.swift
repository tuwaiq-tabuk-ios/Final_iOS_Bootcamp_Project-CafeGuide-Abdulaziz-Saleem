//
//  mainViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 24/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase


class WelcomeVC: UIViewController {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let email = UserDefaults.standard.string(forKey: "email")
    let password = UserDefaults.standard.string(forKey: "password")
    
    if (email != nil || password != nil) {
      login(emailClear: email!,
            passwordClear: password!)
    }
  }
  
  
  // MARK: - Methods
  
  func login(emailClear:String,
             passwordClear:String ) {
    Auth.auth().signIn(withEmail: emailClear,
                       password: passwordClear,
                       completion:{
                        (authResult,error) in
                        if error != nil {
                          
                          
                          
                          
                        }else{
                          let db = Firestore.firestore()
                          let documentRF = db.collection("users").document((authResult?.user.uid)!)
                          documentRF.getDocument { snapchpot,error in
                            if error != nil{
                              print("error get user data: \(String(describing: error?.localizedDescription))")
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
                                let vc = storybord.instantiateViewController(withIdentifier: Constants.K.OwnerViewController)
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                              }else {
                                let vc = storybord.instantiateViewController(withIdentifier:Constants.K.CafeViewController )
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                              }
                            }
                          }
                          
                          
                          
                          
                          
                          
                          
                        }
                       })
    
  }
}
