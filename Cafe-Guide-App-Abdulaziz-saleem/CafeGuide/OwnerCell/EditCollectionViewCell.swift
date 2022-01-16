//
//  EditCollectionViewCell.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit

class EditCollectionViewCell: UICollectionViewCell {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var imageCafe: UIImageView!
  @IBOutlet weak var evaluationILabel: UILabel!
  @IBOutlet weak var nameCafeILabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
  
  func setupCell(photo:String ,
                 shopName:String ,
                 evaluation:String){
    imageCafe.sd_setImage(with: URL(string: photo),
                          placeholderImage: UIImage(named: ""))
    nameCafeILabel.text = shopName
    self.evaluationILabel.text = "\(evaluation)☆"
  }
}
