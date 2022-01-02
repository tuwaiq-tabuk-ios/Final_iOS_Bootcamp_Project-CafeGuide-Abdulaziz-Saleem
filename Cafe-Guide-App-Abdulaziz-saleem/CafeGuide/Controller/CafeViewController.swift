//
//  ViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit
import Firebase

class CafeViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
  var arrCafe = cafeArray
  var specificArray:[CafeGuide] = [CafeGuide]()
  
  var arrlabel = ["All","Sitting inside","External request"]
  @IBOutlet weak var collection: UICollectionView!
  
  @IBOutlet weak var CategoriesCollection: UICollectionView!
  
  var currentCoffe:CafeGuide!
  var collectioRf:CollectionReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    collection.delegate = self
    collection.dataSource = self
    CategoriesCollection.delegate = self
    CategoriesCollection.dataSource = self
    
    
    
    let db = Firestore.firestore()
    
    collectioRf = db.collection("CafeGuide")
    
    
//    getData()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collection.reloadData()
    getData()
  }
  
  
  func getData() {
    cafeArray.removeAll()
    collectioRf.getDocuments(completion: { snapshot, error in
      if error != nil {
        print("Error get collectioRf \(error?.localizedDescription)")
      } else {
        for Document in snapshot!.documents {
          let data = Document.data()
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
        self.collection.reloadData()
      }
    })

  }
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if (collectionView == collection){
      return arrCafe.count
    } else {
      return arrlabel.count
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if (collectionView == collection){
      let cell = collection.dequeueReusableCell(withReuseIdentifier: "CafeGuide",
                                                for: indexPath) as! CafeCollectionViewCell
      let cafee = arrCafe[indexPath.row]
      cell.setupCell(photo: cafee.photo,
                     shopName: cafee.shopName,
                     evaluation: cafee.evaluation)
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
      cell.categories.text = arrlabel[indexPath.row]
      
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == collection){
      return CGSize(width: self.view.frame.width - 25,
                    height: self.view.frame.width * 0.75)
    }else {
      return CGSize(width: self.view.frame.width * 0.5,
                    height: self.view.frame.width * 0.3)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == collection){
      return 30
    }else{
      return 8
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if collectionView == collection {
    currentCoffe = arrCafe[indexPath.row]
    } else {
      let cell = collectionView.cellForItem(at: indexPath) as! CategoriesLabelCell
      print("dd \(cell.categories.text!)")
      arrCafe.removeAll()
      
      if cell.categories.text == "Sitting inside" {
        cafeArray.forEach { CafeGuide in
          if CafeGuide.type == "inside" {
            arrCafe.append(CafeGuide)
          }
        }
      } else if cell.categories.text == "External request" {

        cafeArray.forEach { CafeGuide in
          if CafeGuide.type == "outside" {
            arrCafe.append(CafeGuide)
          }
        }
      } else {
        arrCafe = cafeArray
      }
      
      collection.reloadData()
    }
//    print("~~ \(String(describing: currentCoffe))")
    return true
  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDeatil"{
    if let vc = segue.destination as? ImageViewController {
      vc.arrPhoto = currentCoffe
      
    }
    }
  }
  
  @IBAction func favourites(_ sender: UIButton) {
    
    let index = sender.tag
    let db = Firestore.firestore()

    
    if cafeArray[index].isFavorite {
      cafeArray[index].isFavorite = false
      db.collection("CafeGuide").document(cafeArray[index].id).setData(["isFavorite":false], merge: true)
      db.collection("CafeFavorite").document(cafeArray[index].id).delete()
      collection.reloadData()
    } else {
      cafeArray[index].isFavorite = true
      db.collection("CafeFavorite").document(cafeArray[index].id).setData([
        "id":cafeArray[index].id as String,
      ]) { error in

        if error != nil {

        } else {
          db.collection("CafeGuide").document(cafeArray[index].id).setData(["isFavorite":true], merge: true)
        }

      }
      
      collection.reloadData()
    }
    

  }
  
}

