//
//  AnalyticsBR.swift
//  XCARET!
//
//  Created by Angelica Can on 2/11/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import FBSDKShareKit

open class AnalyticsBR {
    static let shared = AnalyticsBR()
    
    func saveLogin(provider: String, status : Bool){
        if appDelegate.enviromentProduction == TypeEnviroment.production {
            print("Analytics - SaveLogin \(provider) \(status)")
            Analytics.logEvent(AnalyticsEventLogin, parameters: [
                "provider" : provider as String,
                "status" : status as Bool])
        }
    }
    
    func saveUser(provider: String, status : Bool){
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            print("Analytics - SaveLogin \(provider) \(status)")
            Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                "provider" : provider as String,
                "status" : status as Bool])
        }
    }
    
    func search(query: String){
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            print("Analytics - search \(query)")
            Analytics.logEvent(AnalyticsEventSearch, parameters: [
                "query" : query])
        }
    }
    
    func saveEventContentFB(content: String, title: String){
        print("Analytics - Event \(content) \(title)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - Event \(content) \(title)")
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: title, //Codigo del parque en id
                AnalyticsParameterItemName: title,
                AnalyticsParameterContentType: content]) //Type
        }
    }
    
    
    
    func saveEventContentFBTickets(content: String, title: String, name: String){
        print("Analytics - Event \(content) \(title)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - Event \(content) \(title)")
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: title, //Codigo del parque en id
                AnalyticsParameterItemName: name,
                AnalyticsParameterContentType: content]) //Type
        }
    }
    
    //Track de home/Cuuremcy
    func saveEventContentsMainMenuCurrency(content: String, title: String){
        print("Analytics - Event \(content) \(title)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - Event \(content) \(title)")
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: title, //Codigo del parque en id//mainTickets//USD_MXN_Currency
                AnalyticsParameterContentType: content]) //Type//MainNavigation//HM_XC_Promotion
        }
    }
    
    //Track de home/Cuuremcy
    func saveEventContentsTypePromoPopUp(ItemName: String, promotionID: String, promotionName: String, coupon: String, contentType: String){
        print("Analytics - Event \(ItemName) \(promotionID) \(promotionName) \(coupon) \(contentType)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - Event \(content) \(title)")
            Analytics.logEvent(AnalyticsEventSelectPromotion, parameters: [
                AnalyticsParameterItemName: ItemName, //XC mayusculas
                AnalyticsParameterPromotionID: promotionID, //xcaret code_landing
                AnalyticsParameterPromotionName: promotionName, //APP_QROO
                AnalyticsParameterCoupon : coupon, //APGX _ cupon_promotion
                AnalyticsParameterContentType: contentType //XC_HM_Navigation
            ])
        }
    }
    
    
    func saveEventContentsTypePromotions(itemName: String, promotionID: String, contentType: String){
        print("Analytics - Event \(itemName) \(promotionID) \(contentType)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - Event \(content) \(title)")
            Analytics.logEvent(AnalyticsEventViewPromotion, parameters: [
                AnalyticsParameterItemName: itemName, //XC mayusculas
                AnalyticsParameterPromotionID: promotionID,//xcaret code_landing
                AnalyticsParameterContentType: contentType //XC_HM_Navigation
            ])
        }
    }
    
    func saveEventContentFBByPark(content: String, title: String){
        print("Analytics - EventByPark \(appDelegate.itemParkSelected.code.uppercased())_\(content) \(title)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            //print("Analytics - EventByPark \(content) \(title)")
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: title, //Codigo del parque en id
                AnalyticsParameterItemName: title,
                AnalyticsParameterContentType: "\(appDelegate.itemParkSelected.code.uppercased())_\(content)"]) //con clave del parque
        }
    }
    
    func addToCart(name: String, category: String, price: String, currency: String, quantity: String){
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            print("Analytics - AddToCart \(name) - \(category) - \(price)")
            //Firebase
            Analytics.logEvent(AnalyticsEventAddToCart, parameters: [
                AnalyticsParameterItemID: name,
                AnalyticsParameterItemCategory: category,
                AnalyticsParameterPrice: price,
                AnalyticsParameterQuantity: quantity,
                AnalyticsParameterCurrency: currency])
            
            //Facebook
            let parameters: [String: String] = [
                AppEvents.ParameterName.contentID.rawValue: name,
                AppEvents.ParameterName.contentType.rawValue: category,
                AppEvents.ParameterName.numItems.rawValue: quantity,
                AppEvents.ParameterName.currency.rawValue: currency
            ]
            var priceS = price.replacingOccurrences(of: ",", with: "")
            priceS = String(format: "%.2f", ceil(priceS.string2Double()*100)/100)
            AppEvents.logEvent(.addedToCart, valueToSum: priceS.string2Double(), parameters: parameters)
        }
    }
    
    func beginCheckout(name: String, category: String, price: String, currency: String, quantity: String){
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            print("Analytics - BeginCheckout \(name) - \(category) - \(price)")
            //Firebase
            Analytics.logEvent(AnalyticsEventBeginCheckout, parameters: [
                AnalyticsParameterItemID : name,
                AnalyticsParameterItemName : name,
                AnalyticsParameterItemCategory: category,
                AnalyticsParameterPrice: price,
                AnalyticsParameterQuantity: quantity,
                AnalyticsParameterCurrency: currency])
            
            //Facebook
            let parameters: [String: String] = [
                AppEvents.ParameterName.contentID.rawValue: name,
                AppEvents.ParameterName.currency.rawValue: currency,
                AppEvents.ParameterName.numItems.rawValue: quantity,
                AppEvents.ParameterName.contentType.rawValue: category,
            ]
            var priceS = price.replacingOccurrences(of: ",", with: "")
            priceS = String(format: "%.2f", ceil(priceS.string2Double()*100)/100)
            AppEvents.logEvent(.initiatedCheckout, valueToSum: price.string2Double(), parameters: parameters)
        }
    }
    
    func purchase(name: String, category: String, price: String, currency: String, quantity: String){
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            print("Analytics - EcommercePurchase \(name) - \(category) - \(price)")
            //Firebase
            Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
                AnalyticsParameterItemID : name,
                AnalyticsParameterItemName : name,
                AnalyticsParameterItemCategory: category,
                AnalyticsParameterPrice: price,
                AnalyticsParameterQuantity: quantity,
                AnalyticsParameterCurrency: currency])
            //Facebook
            let parameters: [String: String] = [
//                AppEvents.ParameterName.contentID.rawValue: "test-\(name)-nocontable",
                AppEvents.ParameterName.contentID.rawValue: name,
                AppEvents.ParameterName.contentType.rawValue: category,
                AppEvents.ParameterName.numItems.rawValue: quantity,
            ]
            var priceD = price.replacingOccurrences(of: ",", with: "")
            priceD = String(format: "%.2f", ceil(priceD.string2Double()*100)/100) // "3.15"
            let aux = priceD
            AppEvents.logPurchase(priceD.string2Double(), currency: currency, parameters: parameters)
        }
    }
    
    func contenView(name: String, category: String, price: String, currency: String){
        print("Analytics - ContenView \(name) - \(category) - \(price)")
        //Facebook
        let parameters: [String: String] = [
            AppEvents.ParameterName.contentID.rawValue: name,
            AppEvents.ParameterName.contentType.rawValue: category,
            AppEvents.ParameterName.currency.rawValue: currency
        ]
        let priceD = String(format: "%.2f", ceil(price.string2Double()*100)/100) // "3.15"
        AppEvents.logEvent(.viewedContent, valueToSum: priceD.string2Double(), parameters: parameters)
    }
    
    func saveEventListShop(id: String, name: String){
        print("Analytics - Event \(id) \(name)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventSelectItem, parameters: [
                AnalyticsParameterItemListID: id,
                AnalyticsParameterItemListName: name
            ])
        }
    }
    
    func saveEventAddToCart(id: String, name: String, quantity: Int, currency: String, value: Double){
        print("Analytics - Event \(id) \(name) \(quantity) \(currency) \(value)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventAddToCart, parameters: [
                AnalyticsParameterItemListID : id,
                AnalyticsParameterItemListName : name,
                AnalyticsParameterQuantity : quantity,
                AnalyticsParameterCurrency : currency,
                AnalyticsParameterValue : value
            ])
        }
    }
    
    func saveEventRemoveFromCart(id: String, name: String, quantity: Int, currency: String, value: Double){
        print("Analytics - Event \(id) \(name) \(quantity) \(currency) \(value)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventRemoveFromCart, parameters: [
                AnalyticsParameterItemListID : id,
                AnalyticsParameterItemListName : name,
                AnalyticsParameterQuantity : quantity,
                AnalyticsParameterCurrency : currency,
                AnalyticsParameterValue : value
            ])
        }
    }
    
    func saveEventBeginCheckout(id: String, name: String, quantity: Int, currency: String, value: Double, coupon: String){
        print("Analytics - Event \(id) \(name) \(quantity) \(currency) \(value) \(coupon)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventBeginCheckout, parameters: [
                AnalyticsParameterItemListID : id,
                AnalyticsParameterItemListName : name,
                AnalyticsParameterQuantity : quantity,
                AnalyticsParameterCurrency : currency,
                AnalyticsParameterValue : value,
                AnalyticsParameterCoupon : coupon
            ])
        }
    }

//    func saveEventAddPaymentInfo(id: String, name: String, quantity: Int, currency: String, value: Double, coupon: String, paymentType: String){
//        print("Analytics - Event \(id) \(name) \(quantity) \(currency) \(value) \(coupon)")
//        Analytics.logEvent(AnalyticsEventAddPaymentInfo, parameters: [
//            AnalyticsParameterItemListID : id,
//            AnalyticsParameterItemListName : name,
//            AnalyticsParameterQuantity : quantity,
//            AnalyticsParameterCurrency : currency,
//            AnalyticsParameterValue : value,
//            AnalyticsParameterCoupon : coupon,
//            AnalyticsParameterPaymentType : paymentType
//
//        ])
//        if appDelegate.enviromentProduction == TypeEnviroment.production{
//            Analytics.logEvent(AnalyticsEventAddPaymentInfo, parameters: [
//                AnalyticsParameterItemListID : id,
//                AnalyticsParameterItemListName : name,
//                AnalyticsParameterQuantity : quantity,
//                AnalyticsParameterCurrency : currency,
//                AnalyticsParameterValue : value,
//                AnalyticsParameterCoupon : coupon,
//
//            ])
//        }
//    }
    
    func saveEventPurchase(id: String, name: String, quantity: Int, currency: String, value: Double, coupon: String, transactionID: Int, paymentType: String){
        print("Analytics - Event \(id) \(name) \(quantity) \(currency) \(value) \(coupon) \(transactionID) \(paymentType)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventPurchase, parameters: [
                AnalyticsParameterItemListID : id,
                AnalyticsParameterItemListName : name,
                AnalyticsParameterQuantity : quantity,
                AnalyticsParameterCurrency : currency,
                AnalyticsParameterValue : value,
                AnalyticsParameterCoupon : coupon,
                AnalyticsParameterTransactionID : transactionID,
                AnalyticsParameterPaymentType : paymentType
            ])
        }
    }
    
//    func saveEventViewPromotion(promId: String, promName: String, creativeName: String, listId: String, listName: String){
//        print("Analytics - Event \(promId) \(promName) \(creativeName) \(listId) \(listName)")
//        if appDelegate.enviromentProduction == TypeEnviroment.production{
//            Analytics.logEvent(AnalyticsEventViewPromotion, parameters: [
//                AnalyticsParameterPromotionID : promId,
//                AnalyticsParameterPromotionName : promName,
//                AnalyticsParameterCreativeName : creativeName,
//                AnalyticsParameterItemListID : listId,
//                AnalyticsParameterItemListName : listName
//            ])
//        }
//    }
    
    func saveEventSelectPromotion(promId: String, promName: String, creativeName: String, listId: String = "", listName: String = ""){
        print("Analytics - Event \(promId) \(promName) \(creativeName) \(listId) \(listName)")
        if appDelegate.enviromentProduction == TypeEnviroment.production{
            Analytics.logEvent(AnalyticsEventSelectPromotion, parameters: [
                AnalyticsParameterPromotionID : promId,
                AnalyticsParameterPromotionName : promName,
                AnalyticsParameterCreativeName : creativeName
//                AnalyticsParameterItemListID : listId,
//                AnalyticsParameterItemListName : listName
            ])
        }
    }
}

//if sendProm.first?.code_product != "" && sendProm.first?.descripcionEs != "" {
//    AnalyticsBR.shared.saveEventPurchase(id: (sendProm.first?.code_product)!, name: (sendProm.first?.descripcionEs.lowercased().capitalized)!)
//}
