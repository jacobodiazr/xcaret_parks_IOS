//
//  itemParkCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 18/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemParkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var constraintHimg: NSLayoutConstraint!
    @IBOutlet weak var constraintWimg: NSLayoutConstraint!
    @IBOutlet weak var constraintViewW: NSLayoutConstraint!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let constraintHxW = (UIScreen.main.bounds.width - 60) / 3
        self.constraintViewW.constant = constraintHxW
        self.constraintHimg.constant = constraintHxW
    }
    
    func config(park : ItemPark){
        
        
        
        var imagen = UIImage(named: "Shop/\(park.code!.uppercased())")
        if imagen == nil{
            imagen = UIImage(named: "Parks/XC/Activities/ThumbsNew/ok")
        }
        self.img.image = imagen
        
        //        let productPrice = getProductPrice(parkCode: itemPark.code.lowercased(), promotionCode: "")
        let listPrecios = appDelegate.listPrecios
        
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == park.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key == Constants.CURR.current.lowercased()})
        
        if price?.first?.precio != 0.0{
            self.lblPrice.isHidden = false
            lblName.text = "\(park.name ?? "Xcarte Default") desde"
            self.lblPrice.text = price?.first?.precio.currencyFormat()
        }else{
            lblName.text = "\(park.name ?? "Xcarte Default")"
            self.lblPrice.isHidden = true
        }
        
    }

}
