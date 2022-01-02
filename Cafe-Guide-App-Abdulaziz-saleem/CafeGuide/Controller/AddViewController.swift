//
//  AddViewController.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 26/05/1443 AH.
//

import UIKit
import PhotosUI

class AddViewController: UIViewController ,
                         UITextFieldDelegate     {
  
  
  //MARK: - Properties
  var arrPhoto:[CafeGuide]!
  var arrimg:[UIImage] = []
  var arrDrink:[[String:Any]] = [[String:Any]]()
  var currIndex = 0
  var arrText = ["All","Sitting inside","External request"]
  var pickerType = UIPickerView()

  var image:UIImage!
  var name:String!
  var bestCafe = false

  //MARK: - Outlet
  @IBOutlet weak var imgcafe: UIImageView!
  @IBOutlet weak var cafeName: UITextField!
  @IBOutlet weak var hisRating: UITextField!
  @IBOutlet weak var description1: UITextField!
  @IBOutlet weak var location: UITextField!
  @IBOutlet weak var type: UITextField!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var bestCafeCollection: UICollectionView!
  var toolbar: UIToolbar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    type.delegate = self
    pickerType.dataSource = self
    pickerType.dataSource = self
    imageCollection.delegate = self
  imageCollection.dataSource = self
    bestCafeCollection.delegate = self
    bestCafeCollection.dataSource = self
    
   toolbar = UIToolbar()
    toolbar.barStyle = UIBarStyle.default
    toolbar.isTranslucent = true
    toolbar.sizeToFit()
    
    let bttDone = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePicker) )
    type.inputAccessoryView = toolbar
    type.inputView = pickerType
    toolbar.setItems([bttDone], animated: false)
        toolbar.isUserInteractionEnabled = true
  }

  
  @IBAction func addimageCafe(_ sender: UIButton) {
    bestCafe = false
    addFoto()
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
      let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

      alert.addTextField { (textField) in
          textField.text = "Some default text"
      }

      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        let textField = alert?.textFields![0]
        
        self.arrDrink.append(["name":textField?.text!,"image":image])
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
    config.selectionLimit = 5
    
    let phPicker = PHPickerViewController(configuration: config)
    phPicker.delegate = self
    present(phPicker, animated: true,
            completion: nil)
  }
  
  
  func picker(_ picker: PHPickerViewController,
              didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    for result in results {
      print("~~ \(results.count)")
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
      return arrDrink.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (collectionView == imageCollection ){
    let cell = imageCollection.dequeueReusableCell(withReuseIdentifier:"CafeCell",
                                             for: indexPath) as! imageCafeCollectionViewCell
    // cell.imageCafee.sd_setImage(with: URL(string: arrPhoto.imageCafe[indexPath.row]),placeholderImage: UIImage(named: ""))
    cell.imageCafee.image = arrimg[indexPath.row]
    return cell
    } else {
      let cell = bestCafeCollection.dequeueReusableCell(withReuseIdentifier: "bestDrink",for: indexPath) as! AddBestCafeCell
      cell.bestDrink.image = arrDrink[indexPath.row]["image"] as! UIImage
      cell.nameDrink.text = arrDrink[indexPath.row]["name"] as! String
      return cell
  }
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (collectionView == imageCollection){
      return CGSize(width: self.view.frame.width,
                    height: self.view.frame.width )
    } else {
      return CGSize(width: bestCafeCollection.frame.width * 0.48,
                    height: bestCafeCollection.frame.height * 0.47)
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if (collectionView == imageCollection){
      return 0
    }else {
      return 20
    }
    
  }
}
