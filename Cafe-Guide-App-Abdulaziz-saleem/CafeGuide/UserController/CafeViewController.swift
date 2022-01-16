//
//  ViewController.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 03/05/1443 AH.
//

import UIKit
import Firebase


class CafeViewController: UIViewController {
  
  //MARK: - Properties
  
  var arrCafe = cafeArray
  var specificArray:[CafeGuide] = [CafeGuide]()
  var selectCurrentCoffe:CafeGuide!
  var collectioRf:CollectionReference!
  var arrlabel = ["All", "Sitting inside", "External request"]
  var filterdata:[CafeGuide]!
  
  
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var collection: UICollectionView!
  @IBOutlet weak var CategoriesCollection: UICollectionView!
  @IBOutlet weak var searchCafe: UISearchBar!
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    collection.delegate = self
    collection.dataSource = self
    CategoriesCollection.delegate = self
    CategoriesCollection.dataSource = self
    searchCafe.delegate = self
    
    filterdata = arrCafe
    let db = Firestore.firestore()
    
    collectioRf = db.collection("CafeGuide")
    collection.layer.shadowOpacity = 0.9
    collection.layer.shadowRadius = 10
    CategoriesCollection.layer.shadowOpacity = 0.9
    CategoriesCollection.layer.shadowRadius = 4
    //   getData()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collection.reloadData()
    getData()
  }
  
  
  //MARK: - Functions
  
  func getData() {
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    cafeArray.removeAll()
    collectioRf.getDocuments(completion: { snapshot, error in
      if error != nil {
        print("Error get collectioRf \(String(describing: error?.localizedDescription))")
      } else {
        for Document in snapshot!.documents {
          let data = Document.data()
          var bestCafe:[BestCafe] = [BestCafe]()
          bestCafe.removeAll()
          for best in data["bestCafes"] as! [[String:Any]] {
            var name:String!
            var image:String!
            best.forEach { (key: String, value: Any) in
              if key == "nameDrinks" {
                name = value as? String
              } else if key == "imageDrinks" {
                image = value as? String
              }
              
            }
            bestCafe.append(BestCafe(nameDrinks: name,
                                     imageDrinks: image,
                                     isFavorite: false))
            
          }
          
          let dataCollection = db.collection("CafeFavorite")
          
          dataCollection.getDocuments { snapshot, error in
            if error != nil {
              
            } else {
              
              let cafe = CafeGuide(id: data["id"] as! String,
                                   photo: data["photo"] as! String,
                                   shopName: data["shopName"] as! String,
                                   evaluation: data["evaluation"] as! String,
                                   description: data["description"] as! String,
                                   locationCafe: data["locationCafe"] as! Array,
                                   bestCafes: bestCafe,
                                   imageCafe: data["imageCafe"] as! [String],
                                   isFavorite: false,
                                   type: data["type"] as! String,
                                   instagram: data["instagram"] as! String)
              
              print("~~ \(String(describing: cafe.id))")
              for document in snapshot!.documents {
                if document.documentID == auth.uid {
                  let dataFav = document.data()
                  
                  for (_,values) in dataFav {
                    let value = values as! Array<Any>
                    
                    if value.count == 0 {
                      
                    } else {
                      if value[0] as! String == data["id"] as! String {
                        cafe.isFavorite = true
                      }
                    }
                  }
                  
                }
                
              }
              
              cafeArray.append(cafe)
            }
            self.arrCafe = cafeArray
            self.filterdata = self.arrCafe
            self.collection.reloadData()
          }
        }
      }
    })
    
  }
  
  
  
  
  //MARK: - IBAction
  
  @IBAction func favourites(_ sender: UIButton) {
    
    let index = sender.tag
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    if cafeArray[index].isFavorite {
      cafeArray[index].isFavorite = false
      
      db.collection("CafeFavorite").document(auth.uid).setData([cafeArray[index].id:FieldValue.arrayRemove([cafeArray[index].id!])], merge: true)
      collection.reloadData()
    } else {
      cafeArray[index].isFavorite = true
      db.collection("CafeFavorite").document(auth.uid).setData([
        cafeArray[index].id:FieldValue.arrayUnion([cafeArray[index].id!]),
      ],merge: true) { error in
        
        if error != nil {
          
        } else {
          db.collection("CafeGuide").document(cafeArray[index].id).setData(["isFavorite":true], merge: true)
        }
        
      }
      
      collection.reloadData()
    }
    
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDeatil"{
      if let vc = segue.destination as? ImageViewController {
        vc.arrPhoto = selectCurrentCoffe
        //  vc.selectCurrentCoffe = selectCurrentCoffe
        
      }
    }
  }
  
  
  
  
}


//MARK: - UICollectionView

extension CafeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if (collectionView == collection){
      return filterdata.count
    } else {
      return arrlabel.count
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == collection){
      return CGSize(width: self.view.frame.width - 25,
                    height: self.view.frame.width * 0.70)
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
      return 10
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if collectionView == collection {
      selectCurrentCoffe = filterdata[indexPath.row]
    } else {
      let cell = collectionView.cellForItem(at: indexPath) as! CategoriesLabelCell
      print("dd \(cell.categoriesLabel.text!)")
      filterdata.removeAll()
      
      if cell.categoriesLabel.text == "Sitting inside" {
        cafeArray.forEach { CafeGuide in
          if CafeGuide.type == "inside" {
            filterdata.append(CafeGuide)
          }
        }
      } else if cell.categoriesLabel.text == "External request" {
        
        cafeArray.forEach { CafeGuide in
          if CafeGuide.type == "outside" {
            filterdata.append(CafeGuide)
          }
        }
      } else {
        arrCafe = cafeArray
        filterdata = arrCafe
        
      }
      
      collection.reloadData()
    }
    return true
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if (collectionView == collection){
      let cell = collection.dequeueReusableCell(withReuseIdentifier: "CafeGuide",
                                                for: indexPath) as! CafeCollectionViewCell
      if filterdata.count != 0
      {
        let cafee = filterdata[indexPath.row]
        cell.setupCell(photo: cafee.photo,
                       shopName: cafee.shopName,
                       evaluation: cafee.evaluation)
        
        cell.favoriteButton.tag = indexPath.row
        if !cafee.isFavorite {
          cell.favoriteButton.tintColor = UIColor(named: "Color-1")
        } else {
          cell.favoriteButton.tintColor = UIColor(named: "like")
        }
        
      }
      else{
        let cafee = arrCafe[indexPath.row]
        cell.setupCell(photo: cafee.photo,
                       shopName: cafee.shopName,
                       evaluation: cafee.evaluation)
        
        cell.favoriteButton.tag = indexPath.row
        if !cafee.isFavorite {
          cell.favoriteButton.tintColor = UIColor(named: "Color-1")
        } else {
          cell.favoriteButton.tintColor = UIColor(named: "like")
        }
        
      }
      
      return cell
      
    } else {
      let cell = CategoriesCollection.dequeueReusableCell(withReuseIdentifier: "categoriescell", for: indexPath) as! CategoriesLabelCell
      cell.categoriesLabel.text = arrlabel[indexPath.row]
      
      return cell
    }
  }
}


//MARK: - UISearchBar

extension CafeViewController : UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    filterdata = searchText.isEmpty ? arrCafe : arrCafe.filter {(item : CafeGuide) -> Bool in
      
      return item.shopName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    
    collection.reloadData()
  }
  
}

