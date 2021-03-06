//
//  EditViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit
import Firebase
import SDWebImage


class EditViewController: UIViewController  {
  
  //MARK: - Properties
  
  var arrCafe = cafeArray
  var collectioRf: CollectionReference!
  var selectCurrentCoffe:CafeGuide!
  var filterdata:[CafeGuide]!
  
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var collectionCafe: UICollectionView!
  @IBOutlet weak var SearchCafe: UISearchBar!
  var edit = false
  
  
  
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    collectionCafe.delegate = self
    collectionCafe.dataSource = self
    SearchCafe.delegate = self
    let db = Firestore.firestore()
    collectioRf = db.collection("CafeGuide")
    collectionCafe.layer.shadowOpacity = 0.9
    collectionCafe.layer.shadowRadius = 10
    filterdata = arrCafe
    hideKeyboardWhenTappedAround()
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionCafe.reloadData()
    getData()
  }
  
  
  //MARK: - IBAction
  // Show delete button
  @IBAction func editPressed(_ sender: UIButton) {
    edit.toggle()
    collectionCafe.reloadData()
  }
  
  // Remove the cafe from the program and the firebase.
  @IBAction func deleatPressed(_ sender: UIButton) {
    
    let index = sender.tag
    let ind = filterdata.firstIndex(of: filterdata[index])
    let ind2 = arrCafe.firstIndex(of: filterdata[index])
    let db = Firestore.firestore()
    db.collection("CafeGuide").document(filterdata[index].id).delete()
    filterdata.remove(at: ind!)
    arrCafe.remove(at: ind2!)
    collectionCafe.reloadData()
    
  }
  
  //MARK: - Functions
  
  func getData() {
    collectioRf.getDocuments(completion: { snapshot, error in
      if error != nil {
        print("Error get collectioRf \(String(describing: error?.localizedDescription))")
      } else {
        cafeArray.removeAll()
        self.arrCafe.removeAll()
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
                                     isFavorite: false))
            
          }
          
          cafeArray.append(CafeGuide(id: data["id"] as! String,
                                     photo: data["photo"] as! String,
                                     shopName: data["shopName"] as! String,
                                     evaluation: data["evaluation"] as! String,
                                     description: data["description"] as! String,
                                     locationCafe: data["locationCafe"] as! Array,
                                     bestCafes: bestCafe,
                                     imageCafe: data["imageCafe"] as! [String],
                                     isFavorite: false,
                                     type: data["type"] as! String,
                                     instagram: data["instagram"] as! String))
        }
        self.arrCafe = cafeArray
        self.filterdata = self.arrCafe
        self.collectionCafe.reloadData()
        
      }
    })
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showEdit" {
      if let vc = segue.destination as? AddViewController {
        vc.currentCoffe = selectCurrentCoffe
      }
    }
  }
  
}


//MARK: - UICollectionView

extension EditViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filterdata.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionCafe.dequeueReusableCell(withReuseIdentifier: "CafeGuideEdit",
                                                  for: indexPath) as! EditCollectionViewCell
    
    if edit {
      cell.deleteButton.isHidden = false
    } else {
      cell.deleteButton.isHidden = true
    }
    
    if filterdata.count != 0
    {
      let cafee = filterdata[indexPath.row]
      cell.setupCell(photo: cafee.photo,
                     shopName: cafee.shopName,
                     evaluation: cafee.evaluation)
      
      cell.deleteButton.tag = indexPath.row
    }
    else{
      let cafee = arrCafe[indexPath.row]
      cell.setupCell(photo: cafee.photo,
                     shopName: cafee.shopName,
                     evaluation: cafee.evaluation)
      cell.deleteButton.tag = indexPath.row
    }
    return cell
    
    
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width - 25,
                  height: self.view.frame.width * 0.70)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    selectCurrentCoffe = filterdata[indexPath.row]
    
    return true
  }
}


//MARK: - UISearchBar

extension EditViewController : UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    
    filterdata = searchText.isEmpty ? arrCafe : arrCafe.filter {(item : CafeGuide) -> Bool in
      
      return item.shopName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    
    collectionCafe.reloadData()
  }
}
