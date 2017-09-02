//
//  FeedCell.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/22/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var noOfLikesLbl: UILabel!
    
    @IBOutlet weak var profilePicImg: UIImageView!
    
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionTxt: UITextView!
    @IBOutlet weak var userNameLbl: UITextField!
    
    @IBOutlet weak var likeImg: UIImageView!
    var post: Post!
    
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    func configCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_CURRENT_USER.child("likes").child(post.postKey)
        //self.profilePicImg =
        self.captionTxt.text = post.caption
        self.noOfLikesLbl.text = "\(post.noOfLikes)"
        
        if img != nil {
            self.postImg.image = img
        }
        else {
                let ref = Storage.storage().reference(forURL: post.imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase")
                }
                else {
                    print("Image downloaded from Firebase")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                           self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
            
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            }
            else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }
            else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }

}
