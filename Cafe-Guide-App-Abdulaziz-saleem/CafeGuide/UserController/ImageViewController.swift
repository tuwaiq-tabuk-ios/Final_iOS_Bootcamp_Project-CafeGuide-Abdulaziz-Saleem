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
import SDWebImage


class ImageViewController: UIViewController {
  
  //MARK: - Properties
  
  let synthesizer = AVSpeechSynthesizer()
  var player: AVAudioPlayer?
  var arrPhoto:CafeGuide!
  var timer : Timer?
  var cellindex = 0
  var nameCoffe:String!
  
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var photoCollecction: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var descriptionCafeLabel: UILabel!
  @IBOutlet weak var LocationMap: MKMapView!
  @IBOutlet weak var coffeeDrinksCollecction: UICollectionView!
  
  
  //MARK: - IBAction
  
  @IBAction func reading(_ sender: UIButton) {
    talk("\(arrPhoto.description!)")
    
  }
  
  
  @IBAction func instagramButton(_ sender: UIButton) {
    
    UIApplication.shared.open(URL(string: arrPhoto.instagram)!,
                              completionHandler: nil)
    
    
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LocationMap.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    
    photoCollecction.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    coffeeDrinksCollecction.layer.shadowOpacity = 0.5
    
    // Do any additional setup after loading the view.
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    descriptionCafeLabel.text = arrPhoto.description
    
    LocationMap.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(arrPhoto.locationCafe[0]),
                                                                            longitude: CLLocationDegrees(arrPhoto.locationCafe[1])), latitudinalMeters: CLLocationDistance(100), longitudinalMeters: CLLocationDistance(100)), animated: true)
    let coords = CLLocationCoordinate2DMake(CLLocationDegrees(arrPhoto.locationCafe[0]),
                                            CLLocationDegrees(arrPhoto.locationCafe[1]))
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coords
    LocationMap.addAnnotation(annotation)
    LocationMap.mapType = .standard
    pageControl.numberOfPages = arrPhoto.imageCafe.count
    
    startTimer()
    
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    synthesizer.stopSpeaking(at: .immediate)
    
  }
  
  //MARK: - Functions
  
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
  
  
  
}


//MARK: - UICollectionView

extension  ImageViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  
  
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
      cell.imageDrinks.sd_setImage(with: URL(string: best.imageDrinks),
                                   placeholderImage: UIImage(named: ""))
      cell.nameDrinksILabel.text = best.nameDrinks
      
      
      
      return cell
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == photoCollecction){
      return CGSize(width: self.view.frame.width ,
                    height: self.view.frame.width)
    } else {
      return CGSize(width: coffeeDrinksCollecction.frame.width * 0.48,
                    height: coffeeDrinksCollecction.frame.height * 0.47)
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == photoCollecction){
      return 5
    }else {
      return 20
    }
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.1
  }
}






