//
//  OwnerViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 01/06/1443 AH.
//

import UIKit
import FirebaseAuth


class OwnerViewController: UIViewController {
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  
  //MARK: - IBAction
  //Move to user page
  @IBAction func appPressed(_ sender: UIButton) {
    let storybord =  UIStoryboard(name: "Main", bundle: nil)
    let vc = storybord.instantiateViewController(identifier: Constants.K.CafeViewController)
    // vc.modalPresentationStyle = .overFullScreen
    self.present(vc, animated: true)
  }
  
  
  @IBAction func logOutPressed(_ sender: UIButton) {
    let auth = Auth.auth()
    
    do {
      try auth.signOut()
      UserDefaults.standard.removeObject(forKey: "email")
      UserDefaults.standard.removeObject(forKey: "password")
      UserDefaults.standard.synchronize()
      let storybord =  UIStoryboard(name: "Main", bundle: nil)
      let vc = storybord.instantiateViewController(identifier: Constants.K.WelcomeVC)
      vc.modalPresentationStyle = .overFullScreen
      self.present(vc, animated: true)
    } catch let signOutError {
      let alert = UIAlertController(title: "Error",
                                    message: signOutError.localizedDescription,
                                    preferredStyle: UIAlertController.Style.alert)
      self.present(alert,
                   animated: true,
                   completion: nil)
    }
    
  }
  
}



