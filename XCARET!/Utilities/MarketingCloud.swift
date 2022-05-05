//
//  MarketingCloud.swift
//  HotelXcaretMexico
//
//  Created by José Cárdenas on 10/11/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation
import MarketingCloudSDK

struct MarketingCloudConfig{
    
    //prod & preprod
    private let appIDProd = "d89fb1fb-9dcb-447c-a3e7-1784fad838f1"
    private let accessTokenProd = "G3bsHCjVuEqUDufyO29kjYEp"
    
    //dev
    private let appIDDev = "294fbf32-00ef-42da-a57b-45b50f203d62"
    private let accessTokenDev = "3I0JCBtTYHklNwfcBvMVPUZs"
    
    //current
    var appID: String = ""
    var accessToken: String = ""
    let appEndpoint = "https://mch290xfgh1l3xhrgf8mvcxxtjjm.device.marketingcloudapis.com/"
    let mid = "7329010"
    init(enviroment: TypeEnviroment){
        if enviroment == .develop {
            self.appID = self.appIDDev
            self.accessToken = self.accessTokenDev
        }else {
            self.appID = self.appIDProd
            self.accessToken = self.accessTokenProd
        }
        print("appId", self.appID)
        print("accessToken", self.accessToken)
    }
}

struct MarketingCloud{

    let appID = "0d34d906-52bc-4536-a47c-a91a1045dc7f"
    let accessToken = "xMfLWaY0ndK35snURsArUIl7"
    let appEndpoint = "https://mch290xfgh1l3xhrgf8mvcxxtjjm.device.marketingcloudapis.com/"
    let mid = "7329008"

    let appIDDev = "0d34d906-52bc-4536-a47c-a91a1045dc7f"
    let accessTokenDev = "xMfLWaY0ndK35snURsArUIl7"
    //let appEndpoint = "https://mch290xfgh1l3xhrgf8mvcxxtjjm.device.marketingcloudapis.com/"
    //let mid = "7329008"

//    static func setAttributes(user: UserXapi){
//        var attributes = [AnyHashable: Any]()
//        var fullName = ""
//
//        //if(!user.MailingStreet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//        //    attributes["address"] = user.MailingStreet.trimmingCharacters(in: .whitespacesAndNewlines)
//        //}
//        if(!user.MailingCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["City"] = user.MailingCity.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.mailingCountryCodeIso__c.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["Pais"] = user.mailingCountryCodeIso__c.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.MailingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["ZipCode"] = user.MailingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["Email"] = user.Email.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.FirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["FirstName"] = user.FirstName.trimmingCharacters(in: .whitespacesAndNewlines)
//            fullName = user.FirstName.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        //if(!Constants.LANG.current.isEmpty){
//        //    attributes["lang"] = Constants.LANG.current
//        //}
//        if(!user.LastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["LastName"] = user.LastName.trimmingCharacters(in: .whitespacesAndNewlines)
//            fullName += " " + user.LastName.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!fullName.isEmpty){
//            MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("NombreCompleto", value: fullName)
//            attributes["NombreCompleto"] = fullName
//        }
//        if(!user.Phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["PhoneNumber"] = user.Phone.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.mailingStateCodeIso__c.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["State"] = user.mailingStateCodeIso__c.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        if(!user.Title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
//            attributes["Title"] = user.Title.trimmingCharacters(in: .whitespacesAndNewlines)
//        }
//        attributes["Origen"] = "App_Hoteles"
//        attributes["Device"] = UIDevice.modelName
//
//        print("\n============== attributes ===============")
//        for (k, v) in attributes{
//            let key = k as! String
//            let value = v as! String
//            let success = MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed(key, value: value)
//            print("set attribute \(key) => \(value), result: \(success) ")
//        }
//
//        print("\n============== attributes ===============")
//    }
}
