//
//  CafeCollectionViewCell.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit

class CafeCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageCafe: UIImageView!
  
  @IBOutlet weak var nameCafe: UILabel!
  
  @IBOutlet weak var evaluationCafe: UILabel!
  
  @IBOutlet weak var favorite: UIButton!
  

  func setupCell(photo:UIImage ,shopName:String ,evaluation:String){
    imageCafe.image = photo
    nameCafe.text = shopName
    evaluationCafe.text = "\(evaluation)☆"
  }
}