//
//  ViewController.swift
//  AppHouse-Showcase
//
//  Created by Emanuel  Guerrero on 3/21/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }

    @IBAction func facebookButtonTapped(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successful logged in with facebook. \(accessToken)")
                
                DataService.dataService.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged In!\(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" {
            DataService.dataService.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        //Create a new user
                        DataService.dataService.REF_BASE.createUser(email, password: password, withValueCompletionBlock: { error, result in
                            if error != nil {
                                self.showErrorAlert("Could not create account", message: "Problem creating account. Try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.dataService.REF_BASE.authUser(email, password: password, withCompletionBlock: nil)
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Could not login", message: "Please check your username or password")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showErrorAlert("Email and Password Required", message: "You must enter an email and a password")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

