//
//  File.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 30/05/1443 AH.
//

import UIKit


class Colors {
  
  static func Design(_ textField:UITextField){
    
    // Create the bottom line
    let bottomLine = CALayer()
    
    bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 4)
    
    bottomLine.backgroundColor = UIColor.init(named: "log")?.cgColor
    
    //Remove border on text field
    textField.borderStyle = .none
    
    //Add the line to the text field
    textField.layer.addSublayer(bottomLine)
  }
  
  
  static func styleFilledButton(_ button:UIButton){
    
    // Filled rounded corner style
    button.backgroundColor = UIColor.init(red: 239/255,
                                          green: 88/255,
                                          blue: 34/255,
                                          alpha: 1)
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.white
  }
  
  
  static func styleHollowButton(_ button:UIButton){
    
    // Hollow rounded corner style
    button.layer.borderWidth = 3
    button.layer.borderColor = UIColor.init(named: "log")?.cgColor
    button.layer.shadowOpacity = 9.0
    button.tintColor = UIColor.black
   
  }
  //password?
  
}
