//
//  AddBestCafeVC.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 29/05/1443 AH.
//

import UIKit

class AddBestCafeVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIPickerViewDelegate  {
 
  
  @IBOutlet weak var imageDrink: UIImageView!
  @IBOutlet weak var drinkName: UITextField!
  
  var arrDrink:[[String:Any]] = [[String:Any]]()
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
  @IBAction func addImageDrink(_ sender: UIButton) {
    addFoto()
  }
  
  
  @IBAction func saveBestCafe(_ sender: UIButton) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "addNewe") as! AddViewController
    vc.name = drinkName.text!
    vc.image = imageDrink.image
    self.navigationController?.popViewController(animated: true)
  }
  
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
    
    imageDrink.image = image
    arrDrink.removeAll()
    arrDrink.append(["image":image,"name":drinkName.text!])
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  
}
