//
//  ViewController.swift
//  FirebaseSocialNetwork
//
//  Created by KoppoluSaiPratap on 27/08/17.
//  Copyright © 2017 KoppoluSaiPratap. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    //FACEBOOK_AUTHENTICATION
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {
            (result, error) in
            
            if error != nil {
                print("User: Unable to login with facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("User: \(String(describing: result))")
            } else {
                print("User: Successfully authenticated using facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAunthentication(credential)
            }
        })
    }
    
    func firebaseAunthentication(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {
            (user, error) in
            
            if error != nil {
                print("User: Unable to login with firebase - \(String(describing: error))")
            }else {
                print("User: Successfully authenticated using firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
            
        })
    }
    
    //EMAIL_AUTHENTICATION
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {
                (user, error) in
                if error == nil {
                    print("User: \(String(describing: error))")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: {
                        (user, error) in
                        if error != nil {
                            print("User: \(String(describing: error))")
                        } else {
                            print("User: Successfully authenticated using firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    

    func completeSignIn(id: String) {
       let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("User: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

