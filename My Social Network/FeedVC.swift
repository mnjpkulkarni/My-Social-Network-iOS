//
//  FeedVC.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/22/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var uploadImg: CustomImage!
    @IBOutlet weak var captionTxt: UITextField!
    

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imgSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
            //print(snapshot.value!)
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snaps in snapshot {
                    print(snaps)
                    
                    if let postDict = snaps.value as? Dictionary<String, AnyObject> {
                        let key = snaps.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
            }
            self.tableView.reloadData()
            
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            uploadImg.image = image
            imgSelected = true
            
        }
        else {
            print("A valid image was not uploaded")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadImgTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
            
        if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
            
            cell.configCell(post: post, img: img)
        
            }
        else {
            cell.configCell(post: post)
           
            }
            return cell
        }
            
        else {
            return FeedCell()
        }
    }
  
    
    //Upload image to firebase
    
    @IBAction func postBtn(_ sender: Any) {
        
        guard let caption = captionTxt.text, caption != "" else {
            print("Caption needed!")
            return
        }
        
        guard let img = uploadImg.image, imgSelected == true else {
            print("An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_STORAGE_PICS.child(imgUID).putData(imgData, metadata: metadata) { (metadata, error) in

                if error != nil {
                    print("Unable to upload image to Firebase")
                    }
                else{
                    print("Successfully uploaded the image to Firebase")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                      self.postToDb(imgUrl: url)
                    }
                    
                    }
                
            }
        }
        
    }
    
    //Download image from storage to Database
    
    func postToDb(imgUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
        
            "caption": captionTxt.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        
        
        ]
        
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        
        captionTxt.text = ""
        imgSelected = false
        uploadImg.image = UIImage(named: "add-image")
        tableView.reloadData()
    }
    
    
    @IBAction func signOutBtn(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToMain", sender: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
