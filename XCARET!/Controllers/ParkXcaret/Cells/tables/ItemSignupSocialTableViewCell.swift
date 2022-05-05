//
//  ItemSignupSocialTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 9/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit


protocol SocialLoginDelegate : class {
    func getSocialLogin(type: String)
}

class ItemSignupSocialTableViewCell: UITableViewCell {
    weak var delegateSocialLogin : SocialLoginDelegate?
    @IBOutlet weak var lblCreateAccountSocial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblCreateAccountSocial.text = "lblCreateSocialLogin".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnSocialFacebook(_ sender: UIButton) {
        print("Create Facebook")
        delegateSocialLogin?.getSocialLogin(type: "F")
    }
    
    @IBAction func btnSocialGoogle(_ sender: UIButton) {
        print("Create Google")
        delegateSocialLogin?.getSocialLogin(type: "G")
    }
    
    
    @IBAction func btnSocialApple(_ sender: UIButton) {
        delegateSocialLogin?.getSocialLogin(type: "A")
    }
}
