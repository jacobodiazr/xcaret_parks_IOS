//
//  VideoViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/28/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import YoutubePlayerView

class VideoViewController: UIViewController {
    
    @IBOutlet weak var playerView: YoutubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.loadWithVideoId("UBLjz5sEvH4")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setStatusBarStyle(.lightContent)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "btn_back".getNameLabel()/*"lblBack".localized()*/, style: .plain, target: self, action: nil)
    }
}
