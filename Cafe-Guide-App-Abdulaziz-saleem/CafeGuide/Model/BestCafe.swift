//
//  BestCafe.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 09/05/1443 AH.
//

import UIKit

class BestCafe :Equatable {
  let nameDrinks:String
  let imageDrinks:UIImage
  var isFavorite:Bool!
  
  static func == (lhs: BestCafe, rhs: BestCafe) -> Bool {
    return lhs.nameDrinks == rhs.nameDrinks
      && lhs.imageDrinks == rhs.imageDrinks
      && lhs.isFavorite == rhs.isFavorite
  }
  
  
  init(nameDrinks:String,
       imageDrinks:UIImage,
       isFavorite:Bool) {
    self.nameDrinks = nameDrinks
    self.imageDrinks = imageDrinks
    self.isFavorite = isFavorite
  }
}
