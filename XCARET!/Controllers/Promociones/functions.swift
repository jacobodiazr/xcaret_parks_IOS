//
//  functions.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 16/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation

func getProductPrice(parkCode : String, promotionCode : String, paxType : String = "adulto", distintivo : String = "park", type_prod : String = "default") -> Float{
    let currencies = appDelegate.listCurrencies.filter({$0.currency == Constants.CURR.current}).first
    let promotion = appDelegate.listPromotions.filter({$0.code == promotionCode}).first
    
    var product = appDelegate.listProducts.filter({$0.code_park == parkCode.lowercased() && $0.distintivo == distintivo})
    var productPrice = appDelegate.listProductPrices.filter({$0.key_currency == currencies?.uid && $0.paxType == paxType && $0.key_promotion == ""})
    

    
    return ((productPrice.first?.price ?? "1000.0") as NSString).floatValue
    
}

func addCar () -> String {
    return "Hola"
}
