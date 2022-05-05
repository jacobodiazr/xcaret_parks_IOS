//
//  ItemNameCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/31/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemNameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    var colorCell : UIColor!
    var itemActivity : ItemActivity! {
        didSet{
            self.colorCell = getColor(category: itemActivity.category.cat_code)
        }
    }
    
    override var isSelected: Bool {
        didSet{
            print("Estoy en seleccion \(isSelected)")
            self.lblName.textColor =  isSelected ? self.colorCell : UIColor.white.withAlphaComponent(0.5)
            //self.backgroundColor = isSelected ? self.colorCell : self.colorCell.withAlphaComponent(0.8)
            self.transform = isSelected ?  .identity : CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
    
    private func getColor(category: String) -> UIColor{
        let colorBack : UIColor!
        //self.lblName.text = item.details.name.uppercased()
        switch category {
        case "CONSENT":
            colorBack = Constants.COLORS.ITEMS_CELLS.bckCellCon
        case "SINSENT":
            colorBack = Constants.COLORS.ITEMS_CELLS.bckCellSin
        case "REST":
            colorBack = Constants.COLORS.ITEMS_CELLS.bckCellRest
        default:
            colorBack = Constants.COLORS.ITEMS_CELLS.bckCellGen
        }
        return colorBack
    }
    
    public func configureCell(item: ItemActivity){
        if !self.isSelected {
            //self.backgroundColor = self.colorCell.withAlphaComponent(0.8)
            self.lblName.textColor =  UIColor.white.withAlphaComponent(0.5)
            self.transform =  CGAffineTransform(scaleX: 0.6, y: 0.6)
        }else{
            //self.backgroundColor = self.colorCell
            self.lblName.textColor =  self.colorCell
            self.transform = .identity
        }
       
        loadName(name: item.details.name.lowercased())
    }
    
    private func loadName(name: String){
        //Vamos por el caracter
        let ramdomChar = getRamdomCharacter()
        var replaceChar = ""
        if name.contains(ramdomChar){
            replaceChar = getNumberReplace(char: ramdomChar)
            let n4me = name.replacingOccurrences(of: ramdomChar, with: replaceChar)
            self.lblName.text = n4me.uppercased()
        }else{
            loadName(name: name)
        }
    }
    
    private func getNumberReplace(char: String) -> String {
        var charReplace = ""
        switch char {
        case "a":
            charReplace = "4"
        case "e":
            charReplace = "3"
        case "i":
            charReplace = "1"
        case "o":
            charReplace = "0"
        default:
            charReplace = "5"
        }
        return charReplace
    }
    
    private func getRamdomCharacter() -> String{
        let letters  = "aeio"
        let length: Int = 1
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
