//
//  SuccessSendViewController.swift
//  XCARET!
//
//  Created by Jose Eduardo Cardenas Montero on 07/04/22.
//  Copyright © 2022 Angelica Can. All rights reserved.
//

import UIKit

class SuccessSendViewController: UIViewController {

    @IBOutlet weak var lblSendSuccessTitle: UILabel!
    @IBOutlet weak var lblSendSuccessDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSendSuccessTitle.text = "lbl_send_success_title".getNameLabel()
        lblSendSuccessDesc.text = "lbl_send_success_desc".getNameLabel()
    }

    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
