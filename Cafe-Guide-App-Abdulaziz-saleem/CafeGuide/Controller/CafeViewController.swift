//
//  ViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit

class CafeViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var arrCafe = cafeArray
  var arrlabel = ["All","Sitting inside","External request"]
  @IBOutlet weak var collection: UICollectionView!
  
  @IBOutlet weak var CategoriesCollection: UICollectionView!
  
  var currentCoffe:CafeGuide!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    collection.delegate = self
    collection.dataSource = self
    CategoriesCollection.delegate = self
    CategoriesCollection.dataSource = self
    
//    arrCafe.append(CafeGuide(photo: UIImage(named: "Canephora")!, shopName: "Canephora", evaluation: "4.0"))
//    arrCafe.append(CafeGuide(photo: UIImage(named: "Dose")!, shopName: "Dose", evaluation: "4.5"))
//    arrCafe.append(CafeGuide(photo: UIImage(named: "North")!, shopName: "North", evaluation: "3.8"))
//    arrCafe.append(CafeGuide(photo: UIImage(named: "RATIO")!, shopName: "RATIO", evaluation: "4.0"))
    
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collection.reloadData()
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if (collectionView == collection){
      return arrCafe.count
    } else {
      return arrlabel.count
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if (collectionView == collection){
      let cell = collection.dequeueReusableCell(withReuseIdentifier: "CafeGuide", for: indexPath) as! CafeCollectionViewCell
      let cafee = arrCafe[indexPath.row]
      cell.setupCell(photo: cafee.photo, shopName: cafee.shopName, evaluation: cafee.evaluation)
      cell.backgroundColor = .systemGray6
      cell.favorite.tag = indexPath.row
      
      if !cafee.isFavorite {
        cell.favorite.tintColor = UIColor(named: "Color-1")
      } else {
        cell.favorite.tintColor = UIColor(named: "like")
      }

      
      return cell
      
    } else {
      let cell = CategoriesCollection.dequeueReusableCell(withReuseIdentifier: "categoriescell", for: indexPath) as! CategoriesLabelCell
      cell.categoriesButton.setTitle(arrlabel[indexPath.row], for: .normal)
      
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    if (collectionView == collection){
      return CGSize(width: self.view.frame.width - 25, height: self.view.frame.width * 0.75)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == collection){
      return 30
    }else{
      return 8
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//    performSegue(withIdentifier: "showDeatil", sender: nil)
    currentCoffe = arrCafe[indexPath.row]
    print("~~ \(String(describing: currentCoffe))")
    return true
  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDeatil"{
    if let vc = segue.destination as? ImageViewController {
      vc.arrFhoto = currentCoffe
      
    }
    }
  }
  
  @IBAction func favourites(_ sender: UIButton) {
    
    let index = sender.tag
    if arrCafe[index].isFavorite {
      arrCafe[index].isFavorite = false
      sender.tintColor = UIColor(named: "Color-1")
      collection.reloadData()
    } else {
      arrCafe[index].isFavorite = true
      sender.tintColor = UIColor(named: "like")
      collection.reloadData()
    }
    

  }
  //  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
  //    return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
  //  }
  
}

