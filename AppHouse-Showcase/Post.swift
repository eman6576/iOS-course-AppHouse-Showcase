//
//  Post.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/24/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String) {
        _postDescription = description
        _imageUrl = imageUrl
        _username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            _likes = likes
        } else {
            _likes = 0
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            _imageUrl = imageUrl
        }
        
        if let description = dictionary["description"] as? String {
            _postDescription = description
        }
    }
}