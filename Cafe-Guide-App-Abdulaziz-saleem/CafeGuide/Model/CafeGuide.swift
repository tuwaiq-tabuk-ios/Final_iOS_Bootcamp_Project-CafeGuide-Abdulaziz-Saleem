//
//  structCafe.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit

//MARK: - Properties

var arrayShopFaverote:[String] = [String]()
var arrayBestCafeFaverote:[String] = [String]()
var arrDrinkTow : [CafeGuide] = [CafeGuide]()
var cafeArray:[CafeGuide] = [CafeGuide]()



class CafeGuide :Equatable {
  
  //MARK: - Properties
  
  let id:String!
  let photo:String!
  let shopName:String!
  let evaluation:String!
  let description:String!
  let locationCafe:[CGFloat]!
  var bestCafes:[BestCafe]!
  let imageCafe:[String]!
  var isFavorite:Bool!
  let type:String!
  let instagram:String!
  
  
 static func getArray() -> [CafeGuide] {
    return cafeArray
  }
  

  
  init(id:String,
       photo:String,
       shopName:String,
       evaluation:String,
       description:String,
       locationCafe:[CGFloat],
       bestCafes:[BestCafe],
       imageCafe:[String],
       isFavorite:Bool,
       type:String,
       instagram:String) {
    self.id = id
    self.photo = photo
    self.shopName = shopName
    self.evaluation = evaluation
    self.description = description
    self.locationCafe = locationCafe
    self.bestCafes = bestCafes
    self.imageCafe = imageCafe
    self.isFavorite = isFavorite
    self.type = type
    self.instagram = instagram
  }
  
  
  static func == (lhs: CafeGuide, rhs: CafeGuide) -> Bool {
    return lhs.photo == rhs.photo
      && lhs.shopName == rhs.shopName
      && lhs.evaluation == rhs.evaluation
      && lhs.description == rhs.description
      && lhs.locationCafe == rhs.locationCafe
//     && lhs.bestCafes == rhs.bestCafes
      && lhs.imageCafe == rhs.imageCafe
      && lhs.isFavorite == rhs.isFavorite
  }
}

