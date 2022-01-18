//
//  CafeCollectionViewCell.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit

class CafeCollectionViewCell: UICollectionViewCell {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var imageCafe: UIImageView!
  @IBOutlet weak var nameCafeLabel: UILabel!
  @IBOutlet weak var evaluationCafeILabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  // MARK: - Methods 
  
  func setupCell(photo:String ,
                 shopName:String ,
                 evaluation:String){
    imageCafe.sd_setImage(with: URL(string: photo),
                          placeholderImage: UIImage(named: ""))
    nameCafeLabel.text = shopName
    evaluationCafeILabel.text = "\(evaluation)☆"
  }
}
