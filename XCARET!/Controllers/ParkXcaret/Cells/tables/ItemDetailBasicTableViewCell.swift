//
//  ItemDetailBasicTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 30/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

protocol ItemDetailBasicTableViewCellDelegate : class {
    func getAction(_sender: ItemButtonTableViewCell)
}

class ItemDetailBasicTableViewCell: UITableViewCell {
    weak var delegate : ItemButtonTableViewCellDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCallCenter: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.btnCallCenter.setTitle("lbl_call_center".getNameLabel().uppercased(), for: .normal)//("lblCallCenter".localized().uppercased(), for: .normal)
        // Configure the view for the selected state
    }
    
    func setInformation(itemEvent: ItemEvents){
        lblTitle.text = itemEvent.getDetail.name
//        lblSubTitle.text = ""
//        if lblSubTitle.text == "" {
//        }
        lblDescription.text = itemEvent.getDetail.description
    }
    
    @IBAction func btnCallCenter(_ sender: UIButton) {
        //Tools.shared.callNumber(number: "9841792605")
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.callNow.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_callNow": true]
        (AppDelegate.getKruxTracker()).trackPageView("ActivityDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
    }

}
