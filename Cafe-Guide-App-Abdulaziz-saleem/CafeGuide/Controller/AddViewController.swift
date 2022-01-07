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
  var currIndex = 0
  var arrText = ["inside","outside"]
  var pickerType = UIPickerView()
  
  var image:UIImage!
  var name:String!
  
  var bestCafe = false
  var collectioRf:CollectionReference!
  
  var currentCoffe:CafeGuide!

  var toolbar: UIToolbar!
  
  //MARK: - Outlet
  @IBOutlet weak var imgcafe: UIImageView!
  @IBOutlet weak var cafeName: UITextField!
  @IBOutlet weak var hisRating: UITextField!
  @IBOutlet weak var description1: UITextField!
  @IBOutlet weak var location: UITextField!
  @IBOutlet weak var location2: UITextField!
  @IBOutlet weak var type: UITextField!
  @IBOutlet weak var instagram: UITextField!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var bestCafeCollection: UICollectionView!
  @IBOutlet weak var addPhoto: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   // type.delegate = self
    pickerType.delegate = self
    pickerType.dataSource = self
    imageCollection.delegate = self
    imageCollection.dataSource = self
    bestCafeCollection.delegate = self
    bestCafeCollection.dataSource = self
  
    type.inputView = pickerType
    
    toolbar = UIToolbar()
    toolbar.barStyle = UIBarStyle.default
    toolbar.isTranslucent = true
    toolbar.sizeToFit()
    bestCafeCollection.layer.shadowOpacity = 0.5
    Colors.Design(cafeName)
    Colors.Design(hisRating)
    Colors.Design(description1)
    Colors.Design(location)
    Colors.Design(type)
    Colors.Design(location2)
    Colors.Design(instagram)
    Colors.styleHollowButton(addPhoto)
    hideKeyboardWhenTappedAround()
    imageCollection.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    
    let bttDone = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePicker) )
    type.inputAccessoryView = toolbar
    type.inputView = pickerType
    toolbar.setItems([bttDone], animated: false)
    toolbar.isUserInteractionEnabled = true
    
    
    if currentCoffe != nil {
      imgcafe.sd_setImage(with: URL(string: currentCoffe.photo))
      cafeName.text = currentCoffe.shopName
      hisRating.text = currentCoffe.evaluation
      description1.text = currentCoffe.description
      location.text = "\(currentCoffe.locationCafe[0])"
      location2.text = "\(currentCoffe.locationCafe[1])"
      type.text = currentCoffe.type
      instagram.text = currentCoffe.instagram
      getImages()
    }
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
//    print("~~ \(currentCoffe.shopName)")
    currentCoffe = nil
    arrimg.removeAll()
   
    arrDrinkImage.removeAll()
    arrDrinkName.removeAll()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if currentCoffe != nil {
    getImages()
      print("\(currentCoffe.imageCafe.count)")
    }
    
  }
  
  func getImages() {
    
    arrimg.removeAll()
    arrDrinkImage.removeAll()
    arrDrinkName.removeAll()
    for image in currentCoffe.imageCafe {
      print("~~~ \(image)")

      let imageView = UIImageView()
      imageView.sd_setImage(with: URL(string: image)) { image, error, _, _ in
        self.arrimg.append(image!)
        self.imageCollection.reloadData()

      }
      
    }
    
    for bestCafe in currentCoffe.bestCafes {
      let imageView = UIImageView()
      imageView.sd_setImage(with: URL(string: bestCafe.imageDrinks)) { image, error, _, _ in
       // self.arrDrink.append(["name" : bestCafe.nameDrinks,"image":image!])
        self.arrDrinkName.append(bestCafe.nameDrinks)
        self.arrDrinkImage.append(image!)
        self.bestCafeCollection.reloadData()
        
        print("~~ \n\n")
        print("~~ \(bestCafe.imageDrinks)")
        print("~~ \(bestCafe.nameDrinks)")
        print("~~ \n\n")

      }
      
    }
    
  }
  @IBAction func addimageCafe(_ sender: UIButton) {
   bestCafe = false
   addFoto()
//    for name in self.arrDrinkName {
//      print("~~ \(name)")
//    }
 }
  
  
  @objc func closePicker(){
    type.text = arrText[currIndex]
    view.endEditing(true)
  }
  
  
  @IBAction func add(_ sender: UIButton) {
    getPhotos()
    
  }
  
  @IBAction func addBestCafe(_ sender: UIButton) {
    bestCafe = true
    addFoto()
    
  }
  
 
  
  
  @IBAction func saveCafe(_ sender: UIButton) {
    sendData()
  }
  @IBAction func deleteImage(_ sender:UIButton) {
    let index = sender.tag
    
    arrimg.remove(at: index)
    imageCollection.reloadData()
  }
  
  @IBAction func DeleteBestDrink(_ sender:UIButton) {
    
      let index = sender.tag
      
    arrDrinkName.remove(at: index)
    arrDrinkImage.remove(at: index)
    bestCafeCollection.reloadData()
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
       "shopName" :self.cafeName.text!,
       "evaluation":self.hisRating.text!,
       "description":self.description1.text!,
       "locationCafe":[Double(self.location.text!),Double(self.location2.text!)],
       "type":self.type.text!,
       "imageCafe":[""],
       "instagram":self.instagram.text!,
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

        let photoData = self.imgcafe.image?.jpegData(compressionQuality: 0.5)

        storageRF.putData(photoData!, metadata: uploadMetadata) { metadata, error in
          if error != nil {
            print("~~ error upload: \(error?.localizedDescription)")
          } else {
            storageRF.downloadURL { url, error in
              if error != nil {
                print("~~ error get url image: \(error?.localizedDescription)")
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
              print("~~ error upload: \(error?.localizedDescription)")
            } else {
              storageRFe.downloadURL { url, error in
                if error != nil {
                  print("~~ error get url image: \(error?.localizedDescription)")
                } else {
                  imageURL.append(url!.absoluteString)
//                  print("~~ \(imageURL)")
                  db.collection("CafeGuide").document(documentID).setData(
                    ["imageCafe":imageURL,
                    ],merge: true)
                }
              }

            }
          }

        }


        var bestImageData = [Data]()
        var names = self.arrDrinkName

        for image in self.arrDrinkImage {
              let data = image.jpegData(compressionQuality: 0.5)
          bestImageData.append(data!)

        }
      
      
      

      var array = [[String:Any]]()
      var i = 0
      for image in bestImageData {
        
        
        imageID = UUID().uuidString
        let storageRF2 = storage.reference().child(documentID).child(imageID)

        storageRF2.putData(image, metadata: uploadMetadata) { metadata, error in
          if error != nil {
            
          } else {
            
            storageRF2.downloadURL { url, error in
              if error != nil {
                
              } else {

                print("~~ \(names[i])")
                print("~~ \(url!.absoluteString)")
                print("~~ \n\n")

                array.append(["nameDrinks":names[i],"imageDrinks":url!.absoluteString])
                db.collection("CafeGuide").document(documentID).setData(
                  ["bestCafes":array
                  ],merge: true)
                self.navigationController?.popViewController(animated: true)
                i += 1
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
        
        self.arrDrinkName.append(textField!.text!)
        self.arrDrinkImage.append(image)
        print("~~\(self.arrDrinkName.count),\(self.arrDrinkImage.count)")
        self.bestCafeCollection.reloadData()
      }))
      
      self.present(alert, animated: true, completion: nil)
      
      
    } else {
      imgcafe.image = image
    }
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
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
    return type.text = arrText[row]
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
      imgcafe.reloadInputViews()
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
      return arrDrinkImage.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (collectionView == imageCollection ){
      let cell = imageCollection.dequeueReusableCell(withReuseIdentifier:"CafeCell",
                                                     for: indexPath) as! imageCafeCollectionViewCell
      // cell.imageCafee.sd_setImage(with: URL(string: arrPhoto.imageCafe[indexPath.row]),placeholderImage: UIImage(named: ""))
      cell.imageCafee.image = arrimg[indexPath.row]
      cell.deleteImages.tag = indexPath.row
      return cell
    } else {
      let cell = bestCafeCollection.dequeueReusableCell(withReuseIdentifier: "bestDrink",for: indexPath) as! AddBestCafeCell
      
      cell.bestDrink.image = arrDrinkImage[indexPath.row]
      cell.bestDrink.tag = indexPath.row
      cell.nameDrink.text = arrDrinkName[indexPath.row]
      cell.deleteDrink.tag = indexPath.row
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
