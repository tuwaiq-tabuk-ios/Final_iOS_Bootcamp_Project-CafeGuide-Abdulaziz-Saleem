//
//  BestCafe.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 09/05/1443 AH.
//

import UIKit


class BestCafe :Equatable {
  
  //MARK: - Properties
  
  let nameDrinks:String
  let imageDrinks:String
  var isFavorite:Bool!
  

  init(nameDrinks:String,
       imageDrinks:String,
       isFavorite:Bool) {
    self.nameDrinks = nameDrinks
    self.imageDrinks = imageDrinks
    self.isFavorite = isFavorite
  }
  
  static func == (lhs: BestCafe, rhs: BestCafe) -> Bool {
    return lhs.nameDrinks == rhs.nameDrinks
      && lhs.imageDrinks == rhs.imageDrinks
      && lhs.isFavorite == rhs.isFavorite
  }
}
