//
//  GoToHomeViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/4/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class GoToHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        let mainNC = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "HomeParksNC")
        mainNC.view.frame = rootViewController.view.frame
        mainNC.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainNC
        })
    }
}
