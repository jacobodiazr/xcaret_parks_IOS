//
//  ItemScheduleCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/26/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemScheduleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblSchedule: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = 10
        lblSchedule.cornerRadius = 10
    }
    
    public func configureCell(schedule: String){
        lblSchedule.text = schedule
    }
}
