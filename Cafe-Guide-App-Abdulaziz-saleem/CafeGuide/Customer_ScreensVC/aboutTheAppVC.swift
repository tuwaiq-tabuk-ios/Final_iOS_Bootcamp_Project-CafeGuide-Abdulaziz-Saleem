//
//  aboutTheAppVC.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 24/05/1443 AH.
//

import UIKit


class aboutTheAppVC: UIViewController {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var aboutTheAppTextView: UITextView!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    aboutTheAppTextView.text = "About the Application : \n \n A guide showing the city's cafes, the best drinks, their location on the map, a brief description of each cafe, and a rating of places according to the user's desire if he wants to sit inside or outside the cafe. "
    
  }
  
  
  
}
