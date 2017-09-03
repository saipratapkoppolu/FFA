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

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {
            (result, error) in
            
            if error != nil {
                print("User: Unable to login with facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("User: User cancelled facebook authentication")
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
            }
            
        })
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {
                (user, error) in
                if error == nil {
                    print("User: Email user authenticated with firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: {
                        (user, error) in
                        if error != nil {
                            print("User: Unable to authenticate with firebase using email")
                        } else {
                            print("User: Successfully authenticated using firebase")                
                        }
                    })
                }
            })
        }
    }
    

}

