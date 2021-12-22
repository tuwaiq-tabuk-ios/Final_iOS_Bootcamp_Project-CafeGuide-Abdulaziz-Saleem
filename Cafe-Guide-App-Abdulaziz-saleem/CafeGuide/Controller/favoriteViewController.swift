//
//  favoriteViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 15/05/1443 AH.
//

import UIKit

class favoriteViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var arrCafe = cafeArray
  var arrFave:[CafeGuide]!
  
  @IBOutlet weak var collection: UICollectionView!
  
  
  var currentCoffe:CafeGuide!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collection.delegate = self
    collection.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    arrFave = arrCafe.filter{$0.isFavorite}.map{$0}
    
    collection.reloadData()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return arrFave.count
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collection.dequeueReusableCell(withReuseIdentifier: "CafeGuide", for: indexPath) as! CafeCollectionViewCell
      let cafee = arrFave[indexPath.row]
      cell.setupCell(photo: cafee.photo, shopName: cafee.shopName, evaluation: cafee.evaluation)
      cell.backgroundColor = .systemGray6
      cell.favorite.tag = indexPath.row
      
      if !cafee.isFavorite {
        cell.favorite.tintColor = UIColor(named: "Color-1")
        
        


      }else {
        cell.favorite.tintColor = UIColor(named: "like")
      }
      
      return cell
      
      }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      return CGSize(width: self.view.frame.width - 25, height: self.view.frame.width * 0.75)
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {      return 30
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    currentCoffe = arrFave[indexPath.row]
    return true
  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDeatil2"{
    if let vc = segue.destination as? ImageViewController {
      vc.arrFhoto = currentCoffe

    }
    }
  }
  

  @IBAction func favourites(_ sender: UIButton) {
    let index = sender.tag
    let indexe = arrCafe.firstIndex{$0 === arrFave[index]}
    
    if arrCafe[indexe!].isFavorite {
      arrCafe[indexe!].isFavorite = false
      sender.tintColor = UIColor(named: "Color-1")
      arrFave.remove(at: index)
      collection.reloadData()
      
    } else {
      arrCafe[indexe!].isFavorite = true
      sender.tintColor = UIColor(named: "like")
      collection.reloadData()
    }


  }


}


