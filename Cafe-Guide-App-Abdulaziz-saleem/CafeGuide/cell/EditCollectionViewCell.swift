//
//  EditCollectionViewCell.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit

class EditCollectionViewCell: UICollectionViewCell {
  //MARK: - Outlet
  @IBOutlet weak var imgCafe: UIImageView!
  @IBOutlet weak var evaluation: UILabel!
  @IBOutlet weak var nameCafe: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
  
  func setupCell(photo:String ,
                 shopName:String ,
                 evaluation:String){
    imgCafe.sd_setImage(with: URL(string: photo),
                          placeholderImage: UIImage(named: ""))
    nameCafe.text = shopName
    self.evaluation.text = "\(evaluation)☆"
  }
}
