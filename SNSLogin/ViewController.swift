//
//  ViewController.swift
//  SNSLogin
//
//  Created by Takuyaaan on 2017/10/16.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import UIKit
import LineSDK
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var lineBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        twitterBtn.backgroundColor = UIColor.twitter
        facebookBtn.backgroundColor = UIColor.facebook
        lineBtn.backgroundColor = UIColor.line

        setupTwitter()
        setupFacebook()
        setupLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTwtter(_ sender: UIButton) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
//                session?.authToken
//                session?.authTokenSecret
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
    }
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        guard let token = FBSDKAccessToken.current() else {
            let fbManager = FBSDKLoginManager()
            fbManager.logIn(withReadPermissions: ["public_profile", "email", "uesr_friends"], from: self) { (fbResult, error) in
                if (error != nil) {
                    // Login error
                }
                else if (fbResult?.isCancelled)! {
                    // Login Canceled
                }
                else {
                    // Login Succeeded
                }
            }
            return
        }
    }
    
    @IBAction func loginLine(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
    }

    fileprivate func setupTwitter() {
    }

    fileprivate func setupFacebook() {
    }

    fileprivate func setupLine() {
        LineSDKLogin.sharedInstance().delegate = self
    }
}

// MARK: LineSDKLoginDelegate
extension ViewController: LineSDKLoginDelegate {
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        if let error = error {
            print("LINE Login Failed with Error: \(error.localizedDescription) ")
            return
        }
        guard let profile = profile, let credential = credential, let accessToken = credential.accessToken else {
            print("Invalid Repsonse")
            return
        }
        print("LINE Login Succeeded")
        print("Access Token: \(accessToken.accessToken)")
        print("User ID: \(profile.userID)")
        print("Display Name: \(profile.displayName)")
        print("Picture URL: \(profile.pictureURL as URL?)")
        print("Status Message: \(profile.statusMessage as String?)")
    }
}
