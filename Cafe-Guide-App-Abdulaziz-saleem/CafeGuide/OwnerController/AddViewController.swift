//
//  AddViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit
import PhotosUI
import Firebase
import FirebaseAuth
import SDWebImage


class AddViewController: UIViewController ,
                         UITextFieldDelegate     {
  
  
  //MARK: - Properties
  
  var arrimg:[UIImage] = []
  var arrDrinkImage:[UIImage] = []
  var arrDrinkName:[String] = []
  var dicDrink: [[String:Any]] = []
  var currIndex = 0
  var arrText = ["Sitting inside","External request"]
  var pickerType = UIPickerView()
  var image:UIImage!
  var name:String!
  var bestCafe = false
  var collectioRf:CollectionReference!
  var currentCoffe:CafeGuide!
  var toolbar: UIToolbar!
  
  
  //MARK: - IBOutlet
  @IBOutlet weak var imagecafe: UIImageView!
  @IBOutlet weak var cafeNameTextField: UITextField!
  @IBOutlet weak var hisRatingTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var location2TextField: UITextField!
  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var instagramTextField: UITextField!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var bestCafeCollection: UICollectionView!
  @IBOutlet weak var addPhotoButton: UIButton!
  
  
  // MARK: - View controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    pickerType.delegate = self
    pickerType.dataSource = self
    imageCollection.delegate = self
    imageCollection.dataSource = self
    bestCafeCollection.delegate = self
    bestCafeCollection.dataSource = self
    
    typeTextField.inputView = pickerType
    
    toolbar = UIToolbar()
    toolbar.barStyle = UIBarStyle.default
    toolbar.isTranslucent = true
    toolbar.sizeToFit()
    bestCafeCollection.layer.shadowOpacity = 0.5
    Colors.Design(cafeNameTextField)
    Colors.Design(hisRatingTextField)
    Colors.Design(descriptionTextField)
    Colors.Design(locationTextField)
    Colors.Design(typeTextField)
    Colors.Design(location2TextField)
    Colors.Design(instagramTextField)
    Colors.styleHollowButton(addPhotoButton)
    hideKeyboardWhenTappedAround()
    imageCollection.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    
    let bttDone = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePicker) )
    typeTextField.inputAccessoryView = toolbar
    typeTextField.inputView = pickerType
    toolbar.setItems([bttDone], animated: false)
    toolbar.isUserInteractionEnabled = true
    
    
    if currentCoffe != nil {
      imagecafe.sd_setImage(with: URL(string: currentCoffe.photo))
      cafeNameTextField.text = currentCoffe.shopName
      hisRatingTextField.text = currentCoffe.evaluation
      descriptionTextField.text = currentCoffe.description
      locationTextField.text = "\(currentCoffe.locationCafe[0])"
      location2TextField.text = "\(currentCoffe.locationCafe[1])"
      typeTextField.text = currentCoffe.type
      instagramTextField.text = currentCoffe.instagram
      getImages()
    }
    
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    currentCoffe = nil
    arrimg.removeAll()
    dicDrink.removeAll()
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if currentCoffe != nil {
      getImages()
      print("\(currentCoffe.imageCafe.count)")
    }
    
  }
  
  
  //MARK: - IBAction
  // Add an external image of the coffee.
  @IBAction func addimageCafePressed(_ sender: UIButton) {
    bestCafe = false
    addFoto()
    
  }
  
  // Add photos of cafe interior designs
  @IBAction func addPressed(_ sender: UIButton) {
    getPhotos()
    
  }
  
  // Add the best drinks.
  @IBAction func addBestCafePressed(_ sender: UIButton) {
    bestCafe = true
    addFoto()
    
  }
  
  // Save changes and send them to FireBase.
  @IBAction func saveCafePressed(_ sender: UIButton) {
    sendData()
  }
  
  // Delete from photos of cafe interiors
  @IBAction func deleteImagePressed(_ sender:UIButton) {
    let index = sender.tag
    arrimg.remove(at: index)
    imageCollection.reloadData()
  }
  
  // Delete the best drinks.
  @IBAction func DeleteBestDrinkPressed(_ sender:UIButton) {
    
    let index = sender.tag
    
    dicDrink.remove(at: index)
    bestCafeCollection.reloadData()
  }
  
  
  // MARK: - Methods
  
  func getImages() {
    
    arrimg.removeAll()
    dicDrink.removeAll()
    var i = 0
    for image in currentCoffe.imageCafe {
      
      let imageView = UIImageView()
      imageView.sd_setImage(with: URL(string: image)) { image, error, _, _ in
        self.arrimg.append(image!)
        self.imageCollection.reloadData()
        
      }
      
    }
    
    for bestCafe in currentCoffe.bestCafes {
      
      
      
      let imageView = UIImageView()
      imageView.sd_setImage(with: URL(string: bestCafe.imageDrinks)) { image, error, _, _ in
        
        let dic = ["nameDrinks":bestCafe.nameDrinks,"imageDrinks":image!] as [String : Any]
        self.dicDrink.append(dic)
        self.bestCafeCollection.reloadData()
        
      }
      
    }
    
  }
  
  
  
  
  @objc func closePicker(){
    typeTextField.text = arrText[currIndex]
    view.endEditing(true)
  }
  
  
  func sendData()  {
    
    let db = Firestore.firestore()
    var documentID = ""
    if currentCoffe != nil {
      documentID = currentCoffe.id!
    } else {
      documentID = UUID().uuidString
    }
    
    
    db.collection("CafeGuide").document(documentID).setData(
      ["id":documentID,
       "photo":"",
       "shopName" :self.cafeNameTextField.text!,
       "evaluation":self.hisRatingTextField.text!,
       "description":self.descriptionTextField.text!,
       "locationCafe":[Double(self.locationTextField.text!),Double(self.location2TextField.text!)],
       "type":self.typeTextField.text!,
       "imageCafe":[""],
       "instagram":self.instagramTextField.text!,
       "bestCafes":[] as! [[String:Any]]
      ],merge: true) { error in
      
      if let error = error {
        print("Error adding document:\(error)")
      }else{
        
        var imageID = UUID().uuidString
        let storage = Storage.storage()
        let storageRF = storage.reference().child(documentID).child(imageID)
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        let photoData = self.imagecafe.image?.jpegData(compressionQuality: 0.5)
        
        storageRF.putData(photoData!, metadata: uploadMetadata) { metadata, error in
          if error != nil {
            print("~~ error upload: \(String(describing: error?.localizedDescription))")
          } else {
            storageRF.downloadURL { url, error in
              if error != nil {
                print("~~ error get url image: \(String(describing: error?.localizedDescription))")
              } else {
                db.collection("CafeGuide").document(documentID).setData(
                  ["photo":url?.absoluteString,
                  ],merge: true)
              }
            }
            
          }
        }
        
        var imagesData = [Data]()
        for image in self.arrimg {
          let data = image.jpegData(compressionQuality: 0.5)
          imagesData.append(data!)
        }
        
        var imageURL = [String]()
        for data in imagesData {
          imageID = UUID().uuidString
          let storageRFe = storage.reference().child(documentID).child(imageID)
          
          storageRFe.putData(data, metadata: uploadMetadata) { metadata, error in
            if error != nil {
              print("~~ error upload: \(String(describing: error?.localizedDescription))")
            } else {
              storageRFe.downloadURL { url, error in
                if error != nil {
                  print("~~ error get url image: \(String(describing: error?.localizedDescription))")
                } else {
                  imageURL.append(url!.absoluteString)
                  db.collection("CafeGuide").document(documentID).setData(
                    ["imageCafe":imageURL,
                    ],merge: true)
                }
              }
              
            }
          }
          
        }
        
        
        
        var array = [[String:Any]]()
        var i = 0
        for image in self.dicDrink {
          
          let dic = self.dicDrink[i]
          i += 1
          let image = dic["imageDrinks"] as! UIImage
          let name = dic["nameDrinks"] as! String
          let imageData = image.jpegData(compressionQuality: 0.5)
          
          imageID = UUID().uuidString
          let storageRF2 = storage.reference().child(documentID).child(imageID)
          
          storageRF2.putData(imageData!, metadata: uploadMetadata) { metadata, error in
            if error != nil {
              
            } else {
              
              storageRF2.downloadURL { url, error in
                if error != nil {
                  
                } else {
                  
                  array.append(["nameDrinks":name,"imageDrinks":url!.absoluteString])
                  db.collection("CafeGuide").document(documentID).setData(
                    ["bestCafes":array
                    ],merge: true)
                  self.navigationController?.popViewController(animated: true)
                  
                }
              }
            }
          }
          
          
          
          
        }
        
      }
    }
    
  }
  
  
  
  
}



//MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension AddViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
  
  func addFoto() {
    let alert = UIAlertController(title: "Take Poto From", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default,handler: { action in self.getimage(type: .camera)
      
      
    }))
    alert.addAction(UIAlertAction(title: "photo Library", style: .default,handler: { action in self.getimage(type: .photoLibrary)
      
      
    }))
    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  
  func getimage(type:UIImagePickerController.SourceType){
    let pickerCount = UIImagePickerController()
    pickerCount.sourceType = type
    pickerCount.allowsEditing = false
    pickerCount.delegate = self
    present(pickerCount, animated: true, completion: nil)
    
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage
    else{
      print("Image Not Found")
      return
    }
    if bestCafe {
      let alert = UIAlertController(title: "Enter", message: "Drink name", preferredStyle: .alert)
      
      alert.addTextField { (textField) in
        textField.text = "Some default text"
      }
      
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        let textField = alert?.textFields![0]
        let dic = ["nameDrinks":textField!.text!,"imageDrinks":image] as [String : Any]
        self.dicDrink.append(dic)
        
        self.bestCafeCollection.reloadData()
      }))
      
      self.present(alert, animated: true, completion: nil)
      
      
    } else {
      imagecafe.image = image
    }
  }
  
  
  
}



//MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension AddViewController : UIPickerViewDelegate ,
                              UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return arrText.count
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return arrText[row]
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    currIndex = row
    return typeTextField.text = arrText[row]
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}


//MARK: - PHPickerViewControllerDelegate

extension AddViewController: PHPickerViewControllerDelegate{
  func getPhotos(){
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 8
    
    let phPicker = PHPickerViewController(configuration: config)
    phPicker.delegate = self
    present(phPicker, animated: true,
            completion: nil)
  }
  
  
  
  
  func picker(_ picker: PHPickerViewController,
              didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for result in results {
      
      result.itemProvider.loadObject(ofClass: UIImage.self,
                                     completionHandler: {
                                      (imagePic , error) in
                                      if let imagePice = imagePic as? UIImage {
                                        DispatchQueue.main.async {
                                          self.arrimg.append(imagePice)
                                          
                                          
                                          self.imageCollection.reloadData()
                                        }
                                        
                                      }else{
                                      }
                                     }
      )
      imagecafe.reloadInputViews()
    }
  }
}


//MARK: - UICollectionView

extension AddViewController:UICollectionViewDelegate ,
                            UICollectionViewDataSource ,
                            UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    // return arrimg.count
    if (collectionView == imageCollection ){
      return arrimg.count
    }else {
      return dicDrink.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (collectionView == imageCollection ){
      let cell = imageCollection.dequeueReusableCell(withReuseIdentifier:"CafeCell",
                                                     for: indexPath) as! imageCafeCollectionViewCell
      // cell.imageCafee.sd_setImage(with: URL(string: arrPhoto.imageCafe[indexPath.row]),placeholderImage: UIImage(named: ""))
      cell.imageCafee.image = arrimg[indexPath.row]
      cell.deleteImagesButton.tag = indexPath.row
      return cell
    } else {
      let cell = bestCafeCollection.dequeueReusableCell(withReuseIdentifier: "bestDrink",for: indexPath) as! AddBestCafeCell2
      //      nameDrinks
      //      imageDrinks
      cell.imageBestDrink.image = dicDrink[indexPath.row]["imageDrinks"] as? UIImage
      cell.imageBestDrink.tag = indexPath.row
      cell.nameDrinkLabel.text = dicDrink[indexPath.row]["nameDrinks"] as? String
      cell.deleteDrinkButton.tag = indexPath.row
      return cell
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == imageCollection){
      return CGSize(width: self.view.frame.width * 0.96 ,
                    height: self.view.frame.width * 0.60 )
    } else {
      return CGSize(width: bestCafeCollection.frame.width * 0.48,
                    height: bestCafeCollection.frame.height * 0.47)
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == imageCollection){
      return 5
    }else {
      return 20
    }
    
  }
  
  
}
