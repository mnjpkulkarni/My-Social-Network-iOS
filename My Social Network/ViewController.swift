//
//  ViewController.swift
//  My Social Network
//
//  Created by Manoj Kulkarni on 8/20/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func fbSignOnBtn(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook")
            }
            else if result?.isCancelled == true {
                print("User cancelled the Facebook authentication")
                
            }
            else {
                print("Successfully logged in...")
                let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuthentication(credential: credentials)
            }
        }
    }
    
    func fireBaseAuthentication(credential: AuthCredential) {
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase")
            }
            else {
                print("Successfully logged in...")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.signInCompleted(id: user.uid, userData: userData)
                }
            }
        }
        
    }

    @IBAction func signOnBtn(_ sender: Any) {
        
        if let email = emailTxtField.text, let password = passwordTxtField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                   print("User aunthenticated with Firebase")
                    if let user = user {
                         let userData = ["provider": user.providerID]
                        self.signInCompleted(id: user.uid,userData: userData)
                    }
                }
                else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase")
                        }
                        else {
                            print("User created successfully")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.signInCompleted(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func signInCompleted(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirBasDbUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
   }

    

    
    

}

