//
//  Post.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/25/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _noOfLikes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var noOfLikes: Int {
        return _noOfLikes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init (caption: String, imageUrl: String, noOfLikes: Int) {
    
        self._caption = caption
        self._imageUrl = imageUrl
        self._noOfLikes = noOfLikes
    
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] {
            self._caption = caption as! String
        }
        
        if let imageUrl = postData["imageUrl"] {
            self._imageUrl = imageUrl as! String
        }
        
        if let noOfLikes = postData["likes"] {
            self._noOfLikes = noOfLikes as! Int
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
           _noOfLikes = _noOfLikes + 1
        }
        else {
            _noOfLikes = _noOfLikes - 1
        }
        //DataService.ds.REF_POSTS.child("likes").setValue(_noOfLikes)
        _postRef.child("likes").setValue(_noOfLikes)
    }
    
    
}
