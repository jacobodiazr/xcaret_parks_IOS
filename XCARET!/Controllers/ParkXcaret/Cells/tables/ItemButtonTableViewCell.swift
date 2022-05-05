//
//  ItemButtonTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/18/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

protocol ItemButtonTableViewCellDelegate : class {
    func getAction(_sender: ItemButtonTableViewCell)
}

class ItemButtonTableViewCell: UITableViewCell {

    weak var delegate : ItemButtonTableViewCellDelegate?
    @IBOutlet weak var lblBtnSeeAll: UIButton!
    @IBOutlet weak var widthBtn: NSLayoutConstraint!
    var btnColorText = UIColor()
    var btnbackg = UIColor()
    
    var codeCell = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        configModeDarkCustom()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnSeeAllActivities(_ sender: UIButton) {
        delegate?.getAction(_sender: self)
    }
    
    func setCell(code: String){
        var leyend: String = ""
        self.codeCell = code
        configModeDarkCustom()
        switch code {
        case "HOTEL":
            leyend = "lbl_title_contact_us".getNameLabel()//"titleContactUs".localized()
            lblBtnSeeAll.backgroundColor = Constants.COLORS.HOTEL.mexicanPink
            lblBtnSeeAll.cornerRadius = 20
            self.lblBtnSeeAll.setTitle(leyend, for: .normal)
            self.lblBtnSeeAll.setTitleColor(.white, for: .normal)
            self.widthBtn.constant = self.bounds.width - 200
        case "PARKS":
            leyend = "lbl_call_center".getNameLabel().uppercased()//"lblCallCenter".localized().uppercased()
            lblBtnSeeAll.backgroundColor = Constants.COLORS.ITEMS_CELLS.btnHomeGreen
            lblBtnSeeAll.cornerRadius = 25
            lblBtnSeeAll.borderWidth = 0
            self.lblBtnSeeAll.setTitle(leyend, for: .normal)
            self.lblBtnSeeAll.setTitleColor(.white, for: .normal)
            self.widthBtn.constant = self.bounds.width - 200
        case "INFO" :
            leyend = String(format: "\("lbl_about".getNameLabel()) \(appDelegate.itemParkSelected.name.uppercased())"/*"lblAboutXcaret".localized().uppercased()*/, arguments: [appDelegate.itemParkSelected.name.uppercased()])
            self.lblBtnSeeAll.backgroundColor = self.btnbackg//UIColor.white
            self.lblBtnSeeAll.cornerRadius = 5
            self.lblBtnSeeAll.borderColor = btnColorText//Constants.COLORS.ITEMS_CELLS.btnHomeDefault
            self.lblBtnSeeAll.borderWidth = 1
            self.lblBtnSeeAll.setTitle(leyend, for: .normal)
            self.lblBtnSeeAll.setTitleColor(btnColorText, for: .normal)//(Constants.COLORS.ITEMS_CELLS.btnHomeDefault, for: .normal)
            self.widthBtn.constant = self.bounds.width - 60
        default:
            leyend = String(format: "\("lbl_about".getNameLabel().uppercased())\(String(describing: appDelegate.itemParkSelected.name)))"/*"lblAboutXcaret".localized().uppercased()*/, arguments: [appDelegate.itemParkSelected.name])
            lblBtnSeeAll.backgroundColor = UIColor.white
            lblBtnSeeAll.cornerRadius = 5
            lblBtnSeeAll.borderColor = Constants.COLORS.GENERAL.colorLine
            lblBtnSeeAll.borderWidth = 1
            lblBtnSeeAll.titleLabel?.textColor = Constants.COLORS.GENERAL.colorLine
            self.lblBtnSeeAll.setTitle(leyend, for: .normal)
            self.widthBtn.constant = self.bounds.width - 60
        }
        
    }
    
    func configModeDarkCustom(){
        if appDelegate.itemParkSelected.code == "XF" {
            self.btnColorText = .white
            self.btnbackg = Constants.COLORS.GENERAL.customDarkMode
            self.backgroundColor = Constants.COLORS.GENERAL.customDarkMode
        }else{
            self.btnColorText = Constants.COLORS.GENERAL.colorLine
            self.btnbackg = .white
            self.backgroundColor = .white
        }
    }
}
