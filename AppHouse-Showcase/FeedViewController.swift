//
//  FeedViewController.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postsDescriptionTextField: MaterialTextField!
    @IBOutlet weak var imageSelectorImageView: UIImageView!
    
    var posts = [Post]()
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 407
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.dataService.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            //Cancel if there is a current request for the old image that came off
            //the screen
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                image = FeedViewController.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, image: image)
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 200
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    /**
     This method is depreciated but we are only allowing users to upload photos.
    **/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImageView.image = image
    }
    
    @IBAction func selectImageTapped(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePost(sender: UIButton) {
        
    }
}
