//
//  favoriteViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 15/05/1443 AH.
//

import UIKit
import Firebase

class favoriteViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var arrCafe = cafeArray
  var arrFave:[CafeGuide] = [CafeGuide]()
  
  @IBOutlet weak var collection: UICollectionView!
  
  
  var currentCoffe:CafeGuide!
  var dataCollection:CollectionReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collection.delegate = self
    collection.dataSource = self
    let db = Firestore.firestore()
    dataCollection = db.collection("CafeFavorite")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collection.reloadData()
    getData()
  }
  
  
  func getData()  {
    let db = Firestore.firestore()
    arrFave.removeAll()
    dataCollection.getDocuments { snapshot, error in
      if error != nil {
        
      } else {

        for document in snapshot!.documents {
          let data = document.data()
          
          db.collection("CafeGuide").document(data["id"] as! String).getDocument { snapshotData, error in
            let data = snapshotData!.data()!
            
            var bestCafe:[BestCafe] = [BestCafe]()
            bestCafe.removeAll()
            for best in data["bestCafes"] as! [[String:Any]] {
              var name:String!
              var bool:Bool!
              var image:String!
              best.forEach { (key: String, value: Any) in
                if key == "nameDrinks" {
                  name = value as? String
                } else if key == "imageDrinks" {
                  image = value as? String
                } else {
                  bool = value as? Bool
                }
                
              }
              bestCafe.append(BestCafe(nameDrinks: name,
                                       imageDrinks: image,
                                       isFavorite: bool))

            }
            
            let cafeGuide = CafeGuide(id: data["id"] as! String,
                                      photo: data["photo"] as! String,
                                      shopName: data["shopName"] as! String,
                                      evaluation: data["evaluation"] as! String,
                                      description: data["description"] as! String,
                                 locationCafe: data["locationCafe"] as! Array,
                                 bestCafes: bestCafe,
                                 imageCafe: data["imageCafe"] as! [String],
                                 isFavorite: data["isFavorite"] as! Bool,
                                 type: data["type"] as! String,
                                 instagram: data["instagram"] as! String)
            if !self.arrFave.contains(cafeGuide) {
            self.arrFave.append(cafeGuide)
            }
            self.collection.reloadData()
          }


        }
      
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return arrFave.count
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collection.dequeueReusableCell(withReuseIdentifier: "CafeGuide",
                                              for: indexPath) as! CafeCollectionViewCell
    let cafee = arrFave[indexPath.row]
    cell.setupCell(photo: cafee.photo,
                   shopName: cafee.shopName,
                   evaluation: cafee.evaluation)
    cell.backgroundColor = .systemGray6
    cell.favorite.tag = indexPath.row
    
    
    if !cafee.isFavorite {
      cell.favorite.tintColor = UIColor(named: "Color-1")
      
      
    }else {
      cell.favorite.tintColor = UIColor(named: "like")
    }
    
    
    return cell
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: self.view.frame.width - 25,
                  height: self.view.frame.width * 0.75)
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    currentCoffe = arrFave[indexPath.row]
    return true
  }
  
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "showDeatil2"{
      if let vc = segue.destination as? ImageViewController {
        vc.arrPhoto = currentCoffe
        
      }
    }
  }
  
  
  @IBAction func favourites(_ sender: UIButton) {
        let index = sender.tag
        let db = Firestore.firestore()

    arrFave[index].isFavorite = false
    db.collection("CafeGuide").document(arrFave[index].id).setData(["isFavorite":false], merge: true)
    db.collection("CafeFavorite").document(arrFave[index].id).delete()
    arrFave.remove(at: index)
    collection.reloadData()
        }
    
    
  
  
  
}


