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
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.isHidden = true
    hideKeyboardWhenTappedAround()
    Colors.Design(emailTextField)
    Colors.Design(passwordTextField)
    
  }
  
  
  //MARK: - IBAction
  
  @IBAction func Login(_ sender: UIButton) {
    
    let emailClear = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordClear = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    login(emailClear: emailClear, passwordClear: passwordClear)
  }
  
  
  // MARK: - Methods 
  
  func login(emailClear:String,
             passwordClear:String ) {
    Auth.auth().signIn(withEmail: emailClear,
                       password: passwordClear,
                       completion:{
                        (authResult,error) in
                        if error != nil {
                          self.errorLabel.isHidden = false
                          self.errorLabel.text = error?.localizedDescription
                          
                          
                          
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
                                let vc = storybord.instantiateViewController(withIdentifier: "go-to-EditOwnerVC")
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                              }else {
                                let vc = storybord.instantiateViewController(identifier: "go-to-CafeVC")
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                                
                              }
                            }
                          }
                          
                          
                          
                          
                          
                          
                          
                        }
                       })
    
  }
}

