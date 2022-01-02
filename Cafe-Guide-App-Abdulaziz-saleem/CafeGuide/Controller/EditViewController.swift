//
//  EditViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit
import Firebase

class EditViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate{
 
  var arrCafe = cafeArray
  var collectioRf: CollectionReference!
  var currentCoffe:CafeGuide!
 
  @IBOutlet weak var collectionCafe: UICollectionView!
  
  @IBOutlet weak var SearchCafe: UISearchBar!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionCafe.delegate = self
      collectionCafe.dataSource = self
      
      let db = Firestore.firestore()
      
      collectioRf = db.collection("CafeGuide")
      getData()
      
      
      // Do any additional setup after loading the view.
    }
    
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrCafe.count
  }

  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionCafe.dequeueReusableCell(withReuseIdentifier: "CafeGuideEdit",
                                              for: indexPath) as! EditCollectionViewCell
    let cafee = arrCafe[indexPath.row]
    cell.setupCell(photo: cafee.photo,
                   shopName: cafee.shopName,
                   evaluation: cafee.evaluation)
  
    
    return cell
}
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width - 25,
                  height: self.view.frame.width * 0.75)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionCafe.reloadData()
  }
  
  
  func getData() {
    collectioRf.getDocuments(completion: { snapshot, error in
      if error != nil {
        print("Error get collectioRf \(error?.localizedDescription)")
      } else {
        for Document in snapshot!.documents {
          let data = Document.data()
          
//    let data1:Dictionary = data["bestCafes"] as! Dictionary<String, Any>
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
          
          cafeArray.append(CafeGuide(id: data["id"] as! String,
                                     photo: data["photo"] as! String,
                                     shopName: data["shopName"] as! String,
                                     evaluation: data["evaluation"] as! String,
                                     description: data["description"] as! String,
                                     locationCafe: data["locationCafe"] as! Array,
                                     bestCafes: bestCafe,
                                     imageCafe: data["imageCafe"] as! [String],
                                     isFavorite: data["isFavorite"] as! Bool,
                                     type: data["type"] as! String,
                                     instagram: data["instagram"] as! String))
        }
        self.arrCafe = cafeArray
        self.collectionCafe.reloadData()
        print("~~ \(cafeArray.count)")
      }
    })

  }
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      if(!(searchBar.text?.isEmpty)!){
          //reload your data source if necessary
          self.collectionCafe?.reloadData()
      }
  }

  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if(searchText.isEmpty){
          //reload your data source if necessary
          self.collectionCafe?.reloadData()
      }
  
}
}
