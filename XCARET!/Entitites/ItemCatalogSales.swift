//
//  ItemCatalogSales.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 15/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//


import Foundation
import SwiftyJSON

let appDelegateSales = UIApplication.shared.delegate as! AppDelegate

open class productPrices {
    var uid : String!
    var productos : [ItemProdProm]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = key
        productos = [ItemProdProm]()
        for prod in dictionary{
            let keyProd = prod.key
            let events = ItemProdProm(key: keyProd, dictionary: prod.value as! Dictionary<String, AnyObject>)
            productos.append(events)
        }
    }
    
    init(){
        self.uid = ""
        self.productos = [ItemProdProm]()
    }
}
