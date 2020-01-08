//
//  AddPhotoViewController.swift
//  My Taxi
//
//  Created by mac mini on 08/01/20.
//  Copyright © 2020 mac mini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD

class AddPhotoViewController: UIViewController {
    var image: UIImage?
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        showImageViewPicker()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        let storageRef = Storage.storage().reference().child("profileImage.png")
        guard let imageData = imgProfile.image?.pngData() else{return}
        let metadata = StorageMetadata()
        SVProgressHUD.show()
        storageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            if let error = error {
                print("unable to upload\(error.localizedDescription)")
                DispatchQueue.main.async {
                               SVProgressHUD.dismiss()
                           }
                return
            }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            print("Successfully uploaded")
            
            storageRef.downloadURL { (url, error) in
                if error == nil {
                    print(url)
                }
            }
            self.goToBankVerificationViewController()
        }
    }
    
    func goToBankVerificationViewController() {
        let vc = storyboard?.instantiateViewController(identifier: "BankVerificationViewController") as! BankVerificationViewController
        navigationController?.pushViewController(vc , animated: true)
    }
}

extension AddPhotoViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func  showImageViewPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgProfile.image = image
        dismiss(animated: true, completion: nil)
    }
}
