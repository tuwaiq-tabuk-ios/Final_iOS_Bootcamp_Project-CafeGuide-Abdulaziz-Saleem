//
//  FSCollectionReference.swift
//  CafeGuide
//
//  Created by عبدالعزيز البلوي on 14/06/1443 AH.
//

import Foundation
import FirebaseFirestore
 
 
enum FSCollectionReference: String {
  case users
}
// MARK: - Methods

func getFSCollectionReference(
_ collectionReference: FSCollectionReference
) -> CollectionReference {
  return Firestore.firestore()
    .collection(collectionReference.rawValue)
    }  
