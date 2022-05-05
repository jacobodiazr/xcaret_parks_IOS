//
//  parkHomeCollectionViewCell.swift
//  XCARET!
//
//  Created by Hate on 19/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class parkHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblPrecio: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(itemPark: ItemPark){
        //PARCHEZAZO
        if itemPark.code == ""{
            itemPark.code = itemPark.sivex_code
        }
        
        let listPrecios = appDelegate.listPrecios
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == itemPark.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key == Constants.CURR.current})
        
        if price?.first?.precio != 0.0 && price?.first?.precio != nil{
            self.lblPrecio.isHidden = false
            self.lblPrecio.text = "\(price?.first?.precio.currencyFormat() ?? "")"
        }else{
            self.lblPrecio.isHidden = true
        }
        
        self.lblName.text = itemPark.name
        
        var imagen = UIImage(named: "Home/thumb\(itemPark.code!)")
        if imagen == nil{
            imagen = UIImage(named: "Parks/\(itemPark.code!)/Activities/ThumbsNew/ok")
        }
        self.img.image = imagen
    }

}
