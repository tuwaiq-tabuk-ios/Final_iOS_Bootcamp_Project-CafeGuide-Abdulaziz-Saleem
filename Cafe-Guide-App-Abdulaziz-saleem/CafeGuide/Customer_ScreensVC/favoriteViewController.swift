//
//  favoriteViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 15/05/1443 AH.
//

import UIKit
import Firebase


class favoriteViewController: UIViewController {
  
  //MARK: - Properties
  
  var arrCafe = cafeArray
  var arrFave:[CafeGuide] = [CafeGuide]()
  var currentCoffe:CafeGuide!
  var dataCollection:CollectionReference!
  
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var collection: UICollectionView!
  
  
  
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collection.delegate = self
    collection.dataSource = self
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collection.reloadData()
    getData()
  }
  
  
  
  //MARK: - IBAction
  
  @IBAction func favourites(_ sender: UIButton) {
    let index = sender.tag
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    arrFave[index].isFavorite = false
    db.collection("CafeFavorite").document(auth.uid).setData([arrFave[index].id:FieldValue.arrayRemove([arrFave[index].id!])], merge: true)
    arrFave.remove(at: index)
    collection.reloadData()
  }
  
  
  // MARK: - Methods 
  
  func getData()  {
    
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    dataCollection = db.collection("CafeFavorite")
    
    arrFave.removeAll()
    dataCollection.getDocuments { snapshot, error in
      if error != nil {
        
      } else {
        
        for document in snapshot!.documents {
          if document.documentID == auth.uid {
            let data = document.data()
            
            for (_,values) in data {
              let value = values as! Array<Any>
              
              if value.count == 0 {
                return
              }
              
              db.collection("CafeGuide").document(value[0] as! String).getDocument { snapshotData, error in
                let data = snapshotData!.data()
                
                if data == nil {
                  return
                }
                
                var bestCafe:[BestCafe] = [BestCafe]()
                bestCafe.removeAll()
                for best in data!["bestCafes"] as! [[String:Any]] {
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
                                           isFavorite: false))
                  
                }
                
                let cafe = CafeGuide(id: data!["id"] as! String,
                                     photo: data!["photo"] as! String,
                                     shopName: data!["shopName"] as! String,
                                     evaluation: data!["evaluation"] as! String,
                                     description: data!["description"] as! String,
                                     locationCafe: data!["locationCafe"] as! Array,
                                     bestCafes: bestCafe,
                                     imageCafe: data!["imageCafe"] as! [String],
                                     isFavorite: false,
                                     type: data!["type"] as! String,
                                     instagram: data!["instagram"] as! String)
                
                for document in snapshot!.documents {
                  if document.documentID == auth.uid {
                    let dataFav = document.data()
                    
                    for (_,values) in dataFav {
                      let value = values as! Array<Any>
                      
                      if value.count == 0 {
                        
                      } else {
                        if value[0] as! String == data!["id"] as! String {
                          cafe.isFavorite = true
                          self.collection.reloadData()
                        }
                       
                      }
                      
                    }
                    
                  }
                  
                }
                
                if !self.arrFave.contains(cafe) {
                  self.arrFave.append(cafe)
                 // self.collection.reloadData()
                }
                
              }
             
            }
            
          }
          
        }
        
        
      }
      
    }
    
  }
  
  
  
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "showDeatil2"{
      if let vc = segue.destination as? ImageViewController {
        vc.arrPhoto = currentCoffe
        
      }
    }
  }
  
  
  
  
  
}




extension favoriteViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
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
    cell.favoriteButton.tag = indexPath.row
    
    
    if !cafee.isFavorite {
      cell.favoriteButton.tintColor = UIColor(named: "Color-1")
      
      
    }else {
      cell.favoriteButton.tintColor = UIColor(named: "like")
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
}

