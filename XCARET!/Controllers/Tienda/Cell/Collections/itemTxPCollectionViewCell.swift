//
//  itemTxPCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 18/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemTxPCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var constraintHimg: NSLayoutConstraint!
    @IBOutlet weak var constraintWView: NSLayoutConstraint!
    @IBOutlet weak var viewContentImg: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var constrainLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var ConstraintRightMargin: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func config(items : ItemPark,sizeConstraintHimg : CGFloat, sizeConstraintWView : CGFloat, shadow : Bool = false){
        
        if shadow {
            viewContentImg.dropShadow(color: UIColor.gray, opacity: 0.3, offSet: CGSize(width: 2, height: 3), radius:3, scale: true, corner: 10, backgroundColor: UIColor.clear)
        }else{
            viewContentImg.dropShadow(color: UIColor.clear, opacity: 0.0, offSet: CGSize(width: 0, height: 0), radius:0, scale: false, corner: 0, backgroundColor: UIColor.clear)
        }
        
        constraintHimg.constant = sizeConstraintHimg
        constraintWView.constant = sizeConstraintWView
        
        let listPrecios = appDelegate.listPrecios
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == items.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key == Constants.CURR.current})

        if price?.first?.precio != 0.0{
            self.lblName.text = "\(items.name ?? "") \("lbl_from_shop".getNameLabel())"
            self.lblPrice.isHidden = false
            self.lblPrice.text = price?.first?.precio.currencyFormat()
            
        }else{
            self.lblName.text = items.name
            self.lblPrice.isHidden = true
        }
        
        var imagen = UIImage(named: "Shop/\(items.code.uppercased())")
        if imagen == nil{
            imagen = UIImage(named: "Shop/default")
        }
        self.img.image = imagen
    }

}
