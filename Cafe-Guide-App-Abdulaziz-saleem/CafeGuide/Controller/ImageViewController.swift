//
//  ViewController1.swift
//  Cafe-Guide-App-Abdulaziz-saleem
//
//  Created by عبدالعزيز البلوي on 04/05/1443 AH.
//

import UIKit
import MapKit
import AVFoundation
import Firebase

class ImageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
  
  let synthesizer = AVSpeechSynthesizer()
  var player: AVAudioPlayer?
  
  
  @IBOutlet weak var photoCollecction: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var descriptionCafe: UILabel!
  @IBOutlet weak var Location: MKMapView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var coffeeDrinksCollecction: UICollectionView!
  
  var arrPhoto:CafeGuide!
  
  //  var arrCanephora = [UIImage(named: "s5")!,UIImage(named: "s1")!,UIImage(named: "s4")!,UIImage(named: "s2")!,UIImage(named: "s3")!]
  //  var arrDose = [UIImage(named: "d1")!,UIImage(named: "d6")!,UIImage(named: "d3")!,UIImage(named: "d7")!,UIImage(named: "d5")!]
  //  var arrNorth = [UIImage(named: "n1")!,UIImage(named: "n2")!,UIImage(named: "n3")!,UIImage(named: "n4")!,UIImage(named: "n5")!]
  //  var arrRATIO = [UIImage(named: "r1")!,UIImage(named: "r2")!,UIImage(named: "r3")!,UIImage(named: "r4")!,UIImage(named: "r5")!]
  
  var timer : Timer?
  var cellindex = 0
  var nameCoffe:String!
  
  
  @IBOutlet weak var viewDis: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height )
    Location.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    
    photoCollecction.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    
    //    print("~~ \(scrollView.subviews.count)")
    //    photoCollecction.delegate = self
    //    photoCollecction.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func reading(_ sender: UIButton) {
    talk("\(arrPhoto.description!)")
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    descriptionCafe.text = arrPhoto.description
    
    Location.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(arrPhoto.locationCafe[0]),
                                                                         longitude: CLLocationDegrees(arrPhoto.locationCafe[1])), latitudinalMeters: CLLocationDistance(100), longitudinalMeters: CLLocationDistance(100)), animated: true)
    let coords = CLLocationCoordinate2DMake(CLLocationDegrees(arrPhoto.locationCafe[0]),
                                            CLLocationDegrees(arrPhoto.locationCafe[1]))
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coords
    Location.addAnnotation(annotation)
    Location.mapType = .standard
    //    print("~~ \(String(describing: nameCoffe))")
    //    if nameCoffe == "Canephora" {
    //      arrFhoto = arrCanephora
    //    }else if nameCoffe == "Dose"{
    //      arrFhoto = arrDose
    //    }else if nameCoffe == "North"{
    //      arrFhoto = arrNorth
    //    }else if nameCoffe == "RATIO"{
    //      arrFhoto = arrRATIO
    //    }
    pageControl.numberOfPages = arrPhoto.imageCafe.count
    
    startTimer()
    
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    synthesizer.stopSpeaking(at: .immediate)
    
  }
  
  
  func startTimer(){
    timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveIndex), userInfo: nil, repeats: true)
  }
  
  
  @objc func moveIndex(){
    if cellindex < arrPhoto.imageCafe.count - 1{
      cellindex += 1
    }else{
      cellindex = 0
    }
    
    photoCollecction.scrollToItem(at: IndexPath(item: cellindex,
                                                section: 0),
                                  at: .centeredHorizontally,
                                  animated: true)
    pageControl.currentPage = cellindex
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if (collectionView == photoCollecction) {
      return arrPhoto.imageCafe.count
    }else {
      return arrPhoto.bestCafes.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (collectionView == photoCollecction ){
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell",
                                                    for: indexPath) as! PhotoCollectionCell
      cell.imageCafe.sd_setImage(with: URL(string: arrPhoto.imageCafe[indexPath.row]),
                                 placeholderImage: UIImage(named: ""))
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestCafe",
                                                    for: indexPath) as! CoffeeDrinksCollectionViewCell
      
      let best = arrPhoto.bestCafes[indexPath.row]
      cell.coffeeDrinks.sd_setImage(with: URL(string: best.imageDrinks),
                                    placeholderImage: UIImage(named: ""))
      cell.nameDrinks.text = best.nameDrinks
      cell.favoriteDrinke.tag = indexPath.row
      
      if !best.isFavorite {
        cell.favoriteDrinke.tintColor = UIColor(named: "Color-1")
      } else {
        cell.favoriteDrinke.tintColor = UIColor(named: "like")
      }
      
      
      return cell
    }
    
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == photoCollecction){
      return CGSize(width: self.view.frame.width,
                    height: self.view.frame.width )
    } else {
      return CGSize(width: coffeeDrinksCollecction.frame.width * 0.48,
                    height: coffeeDrinksCollecction.frame.height * 0.47)
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == photoCollecction){
      return 0
    }else {
      return 20
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
  
  
  func talk(_ string:String) {
    let utterance = AVSpeechUtterance(string: string)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-ZA")
    
    if synthesizer.isSpeaking {
      synthesizer.stopSpeaking(at: .immediate)
      synthesizer.speak(utterance)
    } else {
      synthesizer.speak(utterance)
    }
  }
  
  @IBAction func favoriteTapped(_ sender: UIButton) {
    let index = sender.tag
    let db = Firestore.firestore()

    
    
    if arrPhoto.bestCafes[index].isFavorite {
      print("~~ \(arrPhoto.bestCafes[index].isFavorite)")


      db.collection("CafeGuide").document(arrPhoto.id).getDocument { snapshot, error in
        if error != nil {

        } else {
          let data = snapshot!.data()!

          var bestCafe:[[String:Any]] = [[String:Any]]()
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
                if name == self.arrPhoto.bestCafes[index].nameDrinks {
                bool = false
                } else {
                  bool = value as? Bool
                }
              }
            }

            bestCafe.append(["nameDrinks": name as String,
                                     "imageDrinks": image as String,
                                     "isFavorite": bool as Bool])

          }

          db.collection("CafeGuide").document(self.arrPhoto.id).setData(["bestCafes":bestCafe],merge: true)

        }



      }

      db.collection("BestCafe").document(arrPhoto.id).delete()


      arrPhoto.bestCafes[index].isFavorite = false
      sender.tintColor = UIColor(named: "Color-1")
      coffeeDrinksCollecction.reloadData()
    } else {

      db.collection("CafeGuide").document(arrPhoto.id).getDocument { snapshot, error in
        if error != nil {

        } else {
          let data = snapshot!.data()!

          var bestCafe:[[String:Any]] = [[String:Any]]()
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
                if name == self.arrPhoto.bestCafes[index].nameDrinks {
                bool = true
                } else {
                  bool = value as? Bool
                }
              }
            }

            bestCafe.append(["nameDrinks": name as String,
                                     "imageDrinks": image as String,
                                     "isFavorite": bool as Bool])
           

          }
          db.collection("CafeGuide").document(self.arrPhoto.id).setData(["bestCafes":bestCafe],merge: true)
          
        }



      }
      let id = db.collection("BestCafe").document(self.arrPhoto.id)
      id.setData([
        "nameDrinks":self.arrPhoto.bestCafes[index].nameDrinks,
        "imageDrinks":self.arrPhoto.bestCafes[index].imageDrinks,
        "id":self.arrPhoto.id as String,
      ],merge: true)





      arrPhoto.bestCafes[index].isFavorite = true
      sender.tintColor = UIColor(named: "like")
      coffeeDrinksCollecction.reloadData()
    }
    
    
  }
  
  
  @IBAction func instagramButton(_ sender: Any) {
    
    UIApplication.shared.open(URL(string: arrPhoto.instagram)!,
                              completionHandler: nil)
    
    
  }
  
}




