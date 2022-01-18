//
//  ModificationViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 24/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase


class ModificationViewController: UIViewController {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    let db = Firestore.firestore()
    if let user = Auth.auth().currentUser{
      let id = user.uid
      db.collection("users").document(id).getDocument(completion: { result,
                                                                    error in
        
        if error != nil{
          print("~~ Error:\(String(describing: error?.localizedDescription))")
        }else{
          if let data = result?.data(){
            self.firstNameTextField.text = data["firstName"] as? String
            self.lastNameTextField.text = data["lastName"] as? String
          }
        }
      })
      emailTextField.text = user.email
    }
    
  }
  
  
  //MARK: - IBAction
  
  @IBAction func save(_ sender: Any) {
    
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    Auth.auth().currentUser?.updateEmail(to: emailTextField.text!, completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailTextField.text!, forKey: "email")
        UserDefaults.standard.synchronize()
        
        db.collection("users").document(userID!).setData([
          "firstName":self.firstNameTextField.text!,
          "lastName":self.lastNameTextField.text!
        ], merge: true)
      }
    })
    
    
    
  }
  
  
}
