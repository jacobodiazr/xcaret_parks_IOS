//
//  ItemScheduleDestinationCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 26/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemScheduleDestinationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblSchedule: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(schedule: String){
        if Constants.LANG.current == "es"{
            lblSchedule.text = Tools.shared.getFormatHours(hour: schedule, format: "HH:mm")
        }else{
            lblSchedule.text = schedule
        }
    }

}
