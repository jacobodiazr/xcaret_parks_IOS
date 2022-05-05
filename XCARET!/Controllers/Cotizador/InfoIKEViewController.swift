//
//  InfoIKEViewController.swift
//  XCARET!
//
//  Created by YEiK on 16/08/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class InfoIKEViewController: UIViewController {

    @IBOutlet weak var ikeLblTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ikeLblTextView.text = "lbl_cart_popup_ike".getNameLabel()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
