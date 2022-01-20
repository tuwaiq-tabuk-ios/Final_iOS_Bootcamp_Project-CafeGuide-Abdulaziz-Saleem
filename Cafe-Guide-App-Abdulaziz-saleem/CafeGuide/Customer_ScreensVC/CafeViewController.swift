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
  
  var arrCafe = [CafeGuide]()
  var specificArray:[CafeGuide] = [CafeGuide]()
  var selectCurrentCoffe:CafeGuide!
  var collectioRf:CollectionReference!
  var arrlabel = ["All", "Sitting inside", "External request"]
  var filterdata:[CafeGuide]!
  
  
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var collection: UICollectionView!
  @IBOutlet weak var CategoriesCollection: UICollectionView!
  @IBOutlet weak var searchCafe: UISearchBar!
  
  
  // MARK: - View controller Life Cycle
  
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
    
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
  }
  
  // MARK: - Methods 
  
  func getData() {
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    
    collectioRf.addSnapshotListener { snapshot, error in
      if error != nil {
        print("Error get collectioRf \(String(describing: error?.localizedDescription))")
      } else {
        self.arrCafe.removeAll()
        self.filterdata.removeAll()
        
        for Document in snapshot!.documents {
          let data = Document.data()
          var bestCafe:[BestCafe] = [BestCafe]()
          //          bestCafe.removeAll()
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
          
          let dataCollection = db.collection("users").document(auth.uid).collection("CafeFavorite")
          
          
          dataCollection.getDocuments { snapshot, error in
            guard error == nil else {return}
            
            guard let document = snapshot?.documents else {return}
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
            
            for snapshote in document {
              let data = snapshote.data()
              let id = data["id"] as! String
              
              if cafe.id == id {
                cafe.isFavorite = true
              }
              
            }
            self.arrCafe.append(cafe)
            self.filterdata = self.arrCafe
            self.collection.reloadData()
          }
          
        }
        
        
      }
    }
    
  }
  
  
  
  
  //MARK: - IBAction
  // Cafe Preference
  @IBAction func favourites(_ sender: UIButton) {
    
    let index = sender.tag
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    if filterdata[index].isFavorite {
      filterdata[index].isFavorite = false
      db.collection("users").document(userID!).collection("CafeFavorite").document(filterdata[index].id!).delete()
      collection.reloadData()
    } else {
      filterdata[index].isFavorite = true
      db.collection("users").document(userID!).collection("CafeFavorite").document(filterdata[index].id).setData(
        ["id":filterdata[index].id!], merge: true)
      
      collection.reloadData()
    }
    
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDeatil"{
      if let vc = segue.destination as? ImageViewController {
        vc.arrPhoto = selectCurrentCoffe
        
        
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
      
      print("~~ \(cell.categoriesLabel.text!)")
      if cell.categoriesLabel.text! == "All" {
        filterdata = arrCafe
      } else {
        filterdata = cell.categoriesLabel.text!.isEmpty ? arrCafe : arrCafe.filter {(item : CafeGuide) -> Bool in
          
          return item.type.range(of: cell.categoriesLabel.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
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
      var cafee:CafeGuide!
      if filterdata.count != 0
      {
        cafee = filterdata[indexPath.row]
      } else {
        cafee = arrCafe[indexPath.row]
      }
      
      cell.setupCell(photo: cafee.photo,
                     shopName: cafee.shopName,
                     evaluation: cafee.evaluation)
      
      cell.favoriteButton.tag = indexPath.row
      if !cafee.isFavorite {
        cell.favoriteButton.tintColor = UIColor(named: "Color-1")
      } else {
        cell.favoriteButton.tintColor = UIColor(named: "like")
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

