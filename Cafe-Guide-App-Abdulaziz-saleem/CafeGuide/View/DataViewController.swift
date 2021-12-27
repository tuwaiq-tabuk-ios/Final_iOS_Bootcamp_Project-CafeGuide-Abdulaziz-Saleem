//
//  DataViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 18/05/1443 AH.
//

import UIKit
import Firebase

class DataViewController: UIViewController {

//  var cafeArray:[CafeGuide] = [
////   CafeGuide(photo: UIImage(named: "Canephora")!,
////             shopName: "Canephora",
////             evaluation: "4.0",
////             description: "Canephora description",
////             locationCafe: [28.43023,36.56841],
////             bestCafes: [
////               BestCafe(nameDrinks: "Canephora1", imageDrinks: UIImage(named: "Canephora")!, isFavorite: true),
////               BestCafe(nameDrinks: "Canephora2", imageDrinks: UIImage(named: "Canephora")!, isFavorite: false)
////             ],
////             imageCafe: [
////               UIImage(named: "s5")!,
////               UIImage(named: "s1")!,
////               UIImage(named: "s4")!,
////               UIImage(named: "s2")!,
////               UIImage(named: "s3")!
////             ],
////             isFavorite: true),
////
////
////
////   CafeGuide(photo: UIImage(named: "Dose")!,
////             shopName: "Dose",
////             evaluation: "4.5",
////             description: "Dose Café is one of the finest coffee shops in the Kingdom and other Gulf countries. Their branches are located in Riyadh, Jeddah, Dammam, Khobar, Makkah, Madinah, Al Ahsa, Tabuk. The cafe was established for the first time in mid-August of the year 2016. The Kuwaiti capital, Kuwait.",
////             locationCafe: [28.3789676, 36.5768785],
////             bestCafes: [
////               BestCafe(nameDrinks: "pistachio latte", imageDrinks: UIImage(named: "ds5")!, isFavorite: true),
////               BestCafe(nameDrinks: "caramel micato", imageDrinks: UIImage(named: "ds2")!, isFavorite: true),
////               BestCafe(nameDrinks: "cappuccino", imageDrinks: UIImage(named: "ds3")!, isFavorite: true),
////               BestCafe(nameDrinks: "Spanish latte", imageDrinks: UIImage(named: "ds4")!, isFavorite: true)
////             ],
////             imageCafe: [
////               UIImage(named: "d1")!,
////               UIImage(named: "d6")!,
////              // UIImage(named: "d3")!,
////               UIImage(named: "d7")!,
////               UIImage(named: "d5")!
////             ],
////             isFavorite: false),
//
//
//
//   CafeGuide(photo: UIImage(named: "North")!,
//             shopName: "North",
//             evaluation: "3.8",
//             description: "Specialty coffee coming from Kuwait to Tabuk, which is characterized by the diversity and innovation of different types of coffee, as well as the breadth of the place and the options of sessions\n working hours : 4:30 pm - 2:00 am \n sessions : Indoor sessions | external",
//             locationCafe: [28.42875 , 36.57476],
//             bestCafes: [
//               BestCafe(nameDrinks: "North1", imageDrinks: UIImage(named: "North")!, isFavorite: false),
//               BestCafe(nameDrinks: "North2", imageDrinks: UIImage(named: "North")!, isFavorite: false)
//             ],
//             imageCafe: [
//               UIImage(named: "n1")!,
//               UIImage(named: "n2")!,
//               UIImage(named: "n3")!,
//               UIImage(named: "n4")!,
//               UIImage(named: "n5")!
//             ],
//             isFavorite: true),
//
//
//
//   CafeGuide(photo: UIImage(named: "RATIO")!,
//             shopName: "RATIO",
//             evaluation: "4.0",
//             description: "RATIO description",
//             locationCafe: [41.344,28.34],
//             bestCafes: [
//               BestCafe(nameDrinks: "RATIO1", imageDrinks: UIImage(named: "RATIO")!, isFavorite: false),
//               BestCafe(nameDrinks: "RATIO2", imageDrinks: UIImage(named: "RATIO")!, isFavorite: false)
//             ],
//             imageCafe: [
//               UIImage(named: "r1")!,
//               UIImage(named: "r2")!,
//               UIImage(named: "r3")!,
//               UIImage(named: "r4")!,
//               UIImage(named: "r5")!
//             ],
//             isFavorite: false)
//
//
//
// ]

  @IBOutlet weak var imageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

//      for cafe in cafeArray {
//      saveData(CafeGuide: cafe) { Bool in
//        if Bool {
//          print("~~ Done")
//        } else {
//          print("~~ Error")
//        }
//      }
//      }
      
        // Do any additional setup after loading the view.
    }
  
  
//  func saveData(CafeGuide: CafeGuide , completion: @escaping (Bool) -> ()) {
//
//    let db = Firestore.firestore()
//    let storage = Storage.storage()
//    let documentID = UUID().uuidString
//
//    var documentIDimage = ""
//
//    if documentIDimage == "" {
//      documentIDimage = UUID().uuidString
//    }
//
//
//
//    var imageCafeConverted:[Data] = [Data]()
//
//    for image in CafeGuide.imageCafe {
//      guard let imageCafePhoto = image.jpegData(compressionQuality: 0.5) else {
//        print("Error: could not convert")
//        return completion(false)
//      }
//      imageCafeConverted.append(imageCafePhoto)
//    }
//
//
//    let uploadMetadata = StorageMetadata()
//    uploadMetadata.contentType = "image/jpeg"
//
//
//    var imageCafeConvertedURL = [String]()
//
//    for data in imageCafeConverted {
//        documentIDimage = UUID().uuidString
//
//      let storageRef = storage.reference().child(documentID).child(documentIDimage)
//
//      storageRef.putData(data , metadata: uploadMetadata) { metadata , error in
//        guard error == nil else {
//          print("😡 ERROR: upload for ref \(storageRef) failed. \(error!.localizedDescription)")
//          return
//        }
//
//
//        storageRef.downloadURL { url, error in
//          guard error == nil else {
//            print("😡 ERROR: Get url for ref \(storageRef) failed. \(error!.localizedDescription)")
//            return
//        }
//          imageCafeConvertedURL.append(url!.absoluteString)
//        }
//
//     }
//      }
//
//
//
//    var bestCafesDec = [String:Any]()
//
//    var dic:[String:Any] = [String:Any]()
//
//    var bestCafesConverted:[Any] = [Any]()
//
//
//    for image in CafeGuide.bestCafes {
//      guard let bestCafesPhoto = image.imageDrinks.jpegData(compressionQuality: 0.5) else {
//        print("Error: could not convert")
//        return completion(false)
//      }
//
//      documentIDimage = UUID().uuidString
//
//    let storageRef = storage.reference().child(documentID).child(documentIDimage)
//
//    storageRef.putData(bestCafesPhoto , metadata: uploadMetadata) { metadata , error in
//      guard error == nil else {
//        print("😡 ERROR: upload for ref \(storageRef) failed. \(error!.localizedDescription)")
//        return
//      }
//
//      storageRef.downloadURL { url, error in
//        guard error == nil else {
//          print("😡 ERROR: Get url for ref \(storageRef) failed. \(error!.localizedDescription)")
//          return
//      }
//
//        bestCafesDec["nameDrinks"] = image.nameDrinks
//        bestCafesDec["imageDrinks"] = url!.absoluteString
//        bestCafesDec["isFavorite"] = image.isFavorite
//        bestCafesConverted.append(bestCafesDec)
//
//
//      }
//    }
//    }
//
//
//
//
//    guard let imagePhoto = CafeGuide.photo.jpegData(compressionQuality: 0.5) else {
//      print("Error: could not convert")
//      return completion(false)
//    }
//
//    documentIDimage = UUID().uuidString
//    let storageRefPhoto = storage.reference().child(documentID).child(documentIDimage)
//    var imagePhotoURl:String!
//
//    storageRefPhoto.putData(imagePhoto , metadata: uploadMetadata) { metadata , error in
//      guard error == nil else {
//        print("😡 ERROR: upload for ref \(storageRefPhoto) failed. \(error!.localizedDescription)")
//        return
//      }
//
//      storageRefPhoto.downloadURL { url, error in
//        guard error == nil else {
//          print("😡 ERROR: Get url for ref \(storageRefPhoto) failed. \(error!.localizedDescription)")
//          return
//      }
//        imagePhotoURl = url!.absoluteString
//
//      }
//
//    }
//
//
//
//
//
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
//      db.collection("CafeGuide").document(documentIDimage).setData([
//      "photo":imagePhotoURl as String,
//      "shopName":CafeGuide.shopName as String,
//      "evaluation":CafeGuide.evaluation as String,
//      "description":CafeGuide.description as String,
//      "locationCafe":CafeGuide.locationCafe as Array,
//      "bestCafes": bestCafesConverted as Array,
//      "imageCafe":imageCafeConvertedURL as Array,
//      "isFavorite":CafeGuide.isFavorite as Bool,
//    ]) {
//      (error) in
//
//      if error != nil {
//        print("Error: \(error!.localizedDescription)")
//      } else {
//
//      }
//
//    }
//    }
//
//    
//    completion(true)
//  }
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
