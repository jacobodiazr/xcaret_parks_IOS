//
//  HorariosLocationPickupCollectionViewCell.swift
//  XCARET!
//
//  Created by YEiK on 22/10/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class HorariosLocationPickupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleHorarioLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    func configHorario(item : ItemLocations){

        var strHrsLocation = item.date.dropLast(3)
        let ampm = strHrsLocation < "12:00" ? "am" : "pm"
        if strHrsLocation[strHrsLocation.index(strHrsLocation.startIndex, offsetBy: 0)] == "0" {
            strHrsLocation.remove(at: strHrsLocation.startIndex)
        }
        titleHorarioLbl.text = "\(strHrsLocation) \(ampm)"
        titleHorarioLbl.font = UIFont.systemFont(ofSize: 16.0)
        titleHorarioLbl.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
        colorView.backgroundColor = .clear
    }
    
    override var isSelected: Bool{
        didSet{
                if self.isSelected{
                    titleHorarioLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
                    titleHorarioLbl.textColor = .white
                    colorView.backgroundColor = UIColor(red: 123/255, green: 176/255, blue: 230/255, alpha: 1.0)
                }else{
                    titleHorarioLbl.font = UIFont.systemFont(ofSize: 16.0)
                    titleHorarioLbl.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
                    colorView.backgroundColor = .clear

                }

        }
    }
    
}
