//
//  favoriteDrinkViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 15/05/1443 AH.
//

import UIKit

class favoriteDrinkViewController: UIViewController ,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var  arrDrink = cafeArray
  var arrDrinkFave : [BestCafe] = [BestCafe]()
  var currentDrink:CafeGuide!
  var arrDrinkTow : [CafeGuide] = [CafeGuide]()
  
  
  @IBOutlet weak var favoriteCollection: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    favoriteCollection.delegate = self
    favoriteCollection.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    arrDrink.enumerated().forEach { (index,item) in
      item.bestCafes.enumerated().forEach { (index1,item1) in
        if item1.isFavorite {
          if !arrDrinkTow.contains(item){
            arrDrinkTow.append(item)
          }
          
          if !arrayFaverote.contains(item.shopName){
            arrayFaverote.append(item.shopName)
          }
          
          if !arrDrinkFave.contains(item1){
            arrDrinkFave.append(item1)
          }
          
        } else {
          
          if arrDrinkFave.contains(item1){
            let indexe = arrDrinkFave.firstIndex{$0.nameDrinks == item1.nameDrinks}
            arrDrinkFave.remove(at: indexe!)
          }
          
        }
      }
    }
    
//    for shop in arrDrinkTow {
//      for best in shop.bestCafes {
//        if !best.isFavorite {
//          let indexe = shop.bestCafes.firstIndex{$0.nameDrinks == best.nameDrinks}!
//          shop.bestCafes.remove(at: indexe)
//        }
//      }
//    }
    
    
    favoriteCollection.reloadData()
  }
  
  
  @IBAction func favoriteButton(_ sender: UIButton) {
    
    let index = sender.tag
    
    
    if arrDrinkFave[index].isFavorite {
      arrDrinkFave[index].isFavorite = false
      sender.tintColor = UIColor(named: "Color-1")
      arrDrinkFave.remove(at: index)
      favoriteCollection.reloadData()
      
    } else {
      arrDrinkFave[index].isFavorite = true
      sender.tintColor = UIColor(named: "like")
      favoriteCollection.reloadData()
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    arrDrinkTow.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrDrinkTow[section].bestCafes.count
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = favoriteCollection.dequeueReusableCell(withReuseIdentifier: "bestCafe", for: indexPath) as! favoriteDrinkCollectionViewCell
    let cafee = arrDrinkTow[indexPath.section].bestCafes[indexPath.row]
    
    cell.backgroundColor = .systemGray6
    cell.favoriteDrink.image = cafee.imageDrinks
    cell.favoriteButten.tag = indexPath.row
    cell.favoriteName.text = cafee.nameDrinks

      cell.favoriteButten.tintColor = UIColor(named: "like")
    
   
    return cell
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //if (collectionView == favoriteCollection){
//      return CGSize(width: self.view.frame.width, height: self.view.frame.width )
//    } else {
      return CGSize(width: favoriteCollection.frame.width * 0.48, height: favoriteCollection.frame.height * 0.25)
    }
 // }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    if (collectionView == favoriteCollection){
//      return 0
//    }else {
      return 15
    //}
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.2
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    for shop in arrDrinkTow {
      for best in shop.bestCafes {
        if best == arrDrinkFave[indexPath.row] {
          currentDrink = shop

        }
      }
    }
    
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! CollectionReusableView
    
    
    header.labelHeder.text = arrDrinkTow[indexPath.section].shopName
    
    
    
    return header
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ImageViewController {
      vc.arrFhoto = currentDrink
    }
  }
  
  
}
