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
  //MARK: - Outlet
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  
    
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
            self.firstName.text = data["firstName"] as? String
            self.lastName.text = data["lastName"] as? String
          }
        }
      })
      email.text = user.email
    }
    
  }
  //MARK: - Action
  @IBAction func save(_ sender: Any) {
    
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { error in
      if error != nil {
        print("Error Update Email: \(error?.localizedDescription)")
      } else {
        UserDefaults.standard.setValue(self.email.text!, forKey: "email")
        UserDefaults.standard.synchronize()
        
        db.collection("users").document(userID!).setData([
          "firstName":self.firstName.text!,
          "lastName":self.lastName.text!
        ], merge: true)
      }
    })
    
    
    
  }
  
  
}
