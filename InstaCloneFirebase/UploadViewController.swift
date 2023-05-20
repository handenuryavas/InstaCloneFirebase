//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Hande Nur Yavaş on 17.05.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadButtonClicked: UIButton!
    
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
        
    }
    

    @IBAction func actionButtonClicked(_ sender: Any)
    {
        
          
          let storage = Storage.storage()
          let storageReference = storage.reference()
          
          let mediaFolder = storageReference.child("media")
          
          
          if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
              
              let uuid = UUID().uuidString
              
              let imageReference = mediaFolder.child("\(uuid).jpg")
              
              imageReference.putData(data, metadata: nil) { (metadata, error) in
                  if error != nil {
                      self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                  } else {
                      
                      imageReference.downloadURL { (url, error) in
                          
                          if error == nil {
                              
                              let imageUrl = url?.absoluteString
                             
                              
                              let fireStoreDatabase = Firestore.firestore()
                              var fireStoreReference : DocumentReference? = nil
                              
                              let fireStorePosts = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                              
                              fireStoreReference = fireStoreDatabase.collection("Posts").addDocument(data : fireStorePosts, completion: { (error) in
                                  if error != nil {
                                      self.makeAlert(titleInput: "Error", messageInput: error? .localizedDescription ?? "Error")
                                  } else {
                                      
                                      self.imageView.image = UIImage(named: "select.png")
                                      self.commentText.text = ""
                                      self.tabBarController?.selectedIndex = 0
                                  }
                              })
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
}
