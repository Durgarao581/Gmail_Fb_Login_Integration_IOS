//
//  ViewController.swift
//  AuthIntegration
//
//  Created by Durga on 22/03/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
   override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        if let token = AccessToken.current,
           !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"],tokenString: token, version: nil, httpMethod: .get)
        }
        else {
            let loginButton = FBLoginButton()
            loginButton.center = view.center
            loginButton.delegate = self
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
            
            
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
            }
            return
          }
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token =   result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"],tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: {connection, result, error in
            print("\(result)")
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
   
}


