//
//  favoriteDrinkViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 15/05/1443 AH.
//

import UIKit
import SDWebImage

class favoriteDrinkViewController: UIViewController ,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var  arrDrink = cafeArray
  var arrDrinkFave : [BestCafe] = [BestCafe]()
  var currentDrink:CafeGuide!
  var section:Int!
  var index:Int!
  
  @IBOutlet weak var favoriteCollection: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    favoriteCollection.delegate = self
    favoriteCollection.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    arrDrinkTow.enumerated().forEach { (index,item) in
      item.bestCafes.enumerated().forEach { (index2,item2) in
        
        if  !arrayBestCafeFaverote.contains(item2.nameDrinks) {
          arrDrinkTow[index].bestCafes.remove(at: index2)
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
    let section = sender.superview!.tag
    
    if arrDrinkTow[section].bestCafes[index].isFavorite {
      arrDrinkTow[section].bestCafes[index].isFavorite = false
      sender.tintColor = UIColor(named: "Color-1")
      
      if let index1 = arrayBestCafeFaverote.firstIndex(of: arrDrinkTow[section].bestCafes[index].nameDrinks) {
        arrayBestCafeFaverote.remove(at: index1)
      }
      
      arrDrinkTow[section].bestCafes.remove(at: index)
      
      print("~~ \(section) \(index)")
      if arrDrinkTow[section].bestCafes.count == 0 {
        arrDrinkTow.remove(at: section)
      }
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
    cell.favoriteDrink.sd_setImage(with: URL(string: cafee.imageDrinks), placeholderImage: UIImage(named: ""))
    cell.favoriteButten.superview!.tag = indexPath.section
    cell.favoriteButten.tag = indexPath.row
    cell.favoriteName.text = cafee.nameDrinks
    
    cell.favoriteButten.tintColor = UIColor(named: "like")
    
    
    return cell
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //if (collectionView == favoriteCollection){
    //      return CGSize(width: self.view.frame.width, height: self.view.frame.width )
    //    } else {
    return CGSize(width: favoriteCollection.frame.width * 0.48, height: favoriteCollection.frame.height * 0.25)
  }
  // }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //    if (collectionView == favoriteCollection){
    //      return 0
    //    }else {
    return 15
    //}
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.2
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    for shop in arrDrinkTow {
      for best in shop.bestCafes {
        if best == arrDrinkFave[indexPath.row] {
          section = indexPath.section
          index = indexPath.row
          currentDrink = shop
          
        }
      }
    }
    
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! CollectionReusableView
    
    
    header.labelHeder.text = arrDrinkTow[indexPath.section].shopName
    
    
    
    return header
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if let vc = segue.destination as? ImageViewController {
      vc.arrPhoto = currentDrink
    }
  }
  
  
}
