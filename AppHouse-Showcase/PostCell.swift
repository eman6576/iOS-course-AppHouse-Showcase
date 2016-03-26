//
//  PostCell.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeReference: Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "likedTapped:")
        tapGesture.numberOfTapsRequired = 1
        
        likesImageView.addGestureRecognizer(tapGesture)
        likesImageView.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        showcaseImage.clipsToBounds = true
    }
    
    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        
        likeReference = DataService.dataService.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        descriptionTextView.text = post.postDescription
        
        likesLabel.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            if image != nil {
                showcaseImage.image = image
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        
                        //Need to do error checking
                        let img = UIImage(data: data!)!
                        self.showcaseImage.image = img
                        
                        //Add the image to our cache for faster performance
                        FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        } else {
            showcaseImage.hidden = true
        }
        
        //Grab a reference to the specific post
        likeReference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                //The user did not like the specific post
                self.likesImageView.image = UIImage(named: "heart-empty")
            } else {
                self.likesImageView.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likedTapped(sender: UITapGestureRecognizer) {
        //Grab a reference to the specific post
        likeReference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                //The user did not like the specific post
                self.likesImageView.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeReference.setValue(true)
            } else {
                self.likesImageView.image = UIImage(named: "heart-empty")
                self.post.adjustLikes((false))
                self.likeReference.removeValue()
            }
        })
    }
}
