//
//  parkPrefHomeCollectionViewCell.swift
//  XCARET!
//
//  Created by Hate on 19/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class parkPrefHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblSlogan: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(itemPark: ItemPark){
        //PARCHEZAZO
        if itemPark.code == "" {
            itemPark.code = itemPark.sivex_code
        }
        
        self.viewContent.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 2, height: 5), radius:3, scale: true, corner: 10, backgroundColor: UIColor.clear)

        let listPrecios = appDelegate.listPrecios
        self.viewContent.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 2, height: 5), radius:3, scale: true, corner: 10, backgroundColor: UIColor.clear)
        
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == itemPark.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key == Constants.CURR.current})
        
        if price?.first?.precio != 0.0 && price?.first?.precio != nil{
            self.lblPrecio.isHidden = false
            self.lblPrecio.text = "\("lbl_price_from".getNameLabel()) \(price?.first?.precio.currencyFormat() ?? "")"
        }else{
            self.lblPrecio.isHidden = true
        }
        
        self.lblSlogan.text = itemPark.detail.slogan
        var imagen = UIImage(named: "Background/bgHome/\(itemPark.code!)_Image")
        if imagen == nil{
            imagen = UIImage(named: "Parks/\(itemPark.code!)/Activities/ThumbsNew/ok")
        }
        self.img.image = imagen
        
        var imagenLogo = UIImage(named: "Logos/logo\(itemPark.code!)")
        if imagenLogo == nil{
            imagenLogo = UIImage(named: "Parks/\(itemPark.code!)/Activities/ThumbsNew/ok")
        }
        self.imgLogo.image = imagenLogo
        
    }

}
