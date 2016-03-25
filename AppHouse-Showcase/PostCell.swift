//
//  PostCell.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    var request: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        showcaseImage.clipsToBounds = true
    }
    
    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        
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
    }
}
