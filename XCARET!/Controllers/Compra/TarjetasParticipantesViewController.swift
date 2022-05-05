//
//  TarjetasParticipantesViewController.swift
//  XCARET!
//
//  Created by YEiK on 18/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class TarjetasParticipantesViewController: UIViewController {
    
    @IBOutlet weak var lblMeses: UILabel!
    @IBOutlet weak var lblSubtitle1: UILabel!
    @IBOutlet weak var lblSubtitle2: UILabel!
    @IBOutlet weak var lblMultiplesOpciones: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblMeses.text = "lbl_months_without_interest".getNameLabel()
        lblSubtitle1.text = "lbl_months_without_interest_subtitle_one".getNameLabel()
        lblSubtitle2.text = "lbl_months_without_interest_subtitle_two".getNameLabel()
        lblMultiplesOpciones.text = "lbl_multiple_choices".getNameLabel()

    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
