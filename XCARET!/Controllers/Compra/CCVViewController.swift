//
//  CCVViewController.swift
//  XCARET!
//
//  Created by YEiK on 18/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class CCVViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = "lbl_payment_dialog_ccv_title".getNameLabel()
        infoLbl.text = "lbl_payment_dialog_ccv".getNameLabel()
    }
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
