//
//  ParksViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/9/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Firebase

class ParksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LogOut(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            FirebaseDB.shared.reserUserDefautls()
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            guard let rootViewController = window.rootViewController else {
                return
            }
            
            let mainNC = AppStoryboard.SignUp.instance.instantiateViewController(withIdentifier: "SignupNC")
            mainNC.view.frame = rootViewController.view.frame
            mainNC.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainNC
            })
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
