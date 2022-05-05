//
//  DataCalendarioCollectionViewCell.swift
//  XCARET!
//
//  Created by Yeik on 11/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class DataCalendarioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contenDia: UIView!
    @IBOutlet weak var diaLbl: UILabel!
    @IBOutlet weak var colorDes: UIView!
    @IBOutlet weak var circuloSelect: UIView!
    
    var itemDiaCalendario = ItemDiaCalendario()
    
    func configDia (item : ItemDiaCalendario){
        itemDiaCalendario = item
        diaLbl.isHidden = false
        colorDes.isHidden = false
        contenDia.isHidden = false
        
        colorDes.isHidden = false
        if item.descuento == 0 {
            colorDes.isHidden = true
        }else if item.descuento == 10 {
            colorDes.backgroundColor = .systemGreen
            colorDes.isHidden = false
        }else{
            colorDes.backgroundColor = .systemYellow
            colorDes.isHidden = false
        }
        
        diaLbl.text = "\(item.diaNumero ?? 0)"
        
        if item.disable == 0 {
            diaLbl.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
        }else if item.disable == 1{
            diaLbl.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 0.5)
            colorDes.isHidden = true
        }else if item.disable == 2{
            diaLbl.isHidden = true
            colorDes.isHidden = true
            contenDia.isHidden = true
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if itemDiaCalendario.disable == 0 {
                if self.isSelected{
                    self.circuloSelect.backgroundColor = .systemBlue
                    self.diaLbl.textColor = .white
                }else{
                    self.circuloSelect.backgroundColor = .clear
                    self.diaLbl.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.0)
                    
                }
            }
            
        }
    }
}
