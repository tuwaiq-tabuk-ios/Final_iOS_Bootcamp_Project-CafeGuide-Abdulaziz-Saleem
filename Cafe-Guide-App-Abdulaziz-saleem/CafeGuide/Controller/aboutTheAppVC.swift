//
//  aboutTheAppVC.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 24/05/1443 AH.
//

import UIKit

class aboutTheAppVC: UIViewController {
  //MARK: - Outlet
  @IBOutlet weak var aboutTheApp: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    aboutTheApp.text = "About the Application : \n \n A guide that displays the caffes in the city, the best drinks, their location on the map, a brief description of each cafe, and rate places according to the user's desire, if he wants to sit inside or outside the caffe. User can prefer to drink or shop and see new places."
    // Do any additional setup after loading the view.
  }
  
  
  
}
