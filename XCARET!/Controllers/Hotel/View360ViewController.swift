//
//  View360ViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/3/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import CTPanoramaView

class View360ViewController: UIViewController {
    
    @IBOutlet weak var panoramaView: CTPanoramaView!
    @IBOutlet weak var compassView: CTPieSliceView!
    
    var nameImage : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panoramaView.controlMethod = .motion
        self.panoramaView.image = UIImage(named: "360/HX/spa")
        self.panoramaView.compass = compassView
    }
    

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
}
