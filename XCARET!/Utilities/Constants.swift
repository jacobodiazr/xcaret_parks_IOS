//
//  Constants.swift
//  XCARET!
//
//  Created by Angelica Can on 11/8/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct LANG {
        static var current = { () -> String in
            print("Language \(NSLocale.preferredLanguages[0])")
            if NSLocale.preferredLanguages[0].contains("en") == true {
                return "en"
            }else {
                let fullNameArr = NSLocale.preferredLanguages[0].components(separatedBy: "-")
                return fullNameArr[0]
//                return "es"
            }
        }()
    }
    
    struct LANGLBL {
        static var current = { () -> String in
            print("Language \(NSLocale.preferredLanguages[0])")
            if NSLocale.preferredLanguages[0].contains("en") == true {
                return "en"
            }
            else {
                let fullNameArr = NSLocale.preferredLanguages[0].components(separatedBy: "-")
                return fullNameArr[0]
            }
        }()
    }
    
    struct CURR {
        static var current = { () -> String in
            
            if let currency = UserDefaults.standard.string(forKey: "UserCurrency") {
                return currency
            }else{
                let locale = Locale.current
                if Constants.LANG.current == "es" && locale.regionCode == "MX" {
                    return "MXN"
                }else{
                    return "USD"
                }
            }
        }()
    }
    
    struct CALENDAR {
        static let mesesES = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        static let mesesEN = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        static let diasES = ["Domingo", "Lunes","Martes","Miércoles","Jueves","Viernes","Sábado"]
        static let diasEN = ["Sundays","Mondays","Tuesdays","Wednesdays","Thursdays","Fridays","Saturdays"]
        static let diasMes = [31,28,31,30,31,30,31,31,30,31,30,31]
    }
    
    struct COLORS {
        struct MESSAGE_ALERT {
            static let error : UIColor = UIColor(red: 0.980, green: 0.102, blue: 0.110, alpha: 1.00).withAlphaComponent(0.8)
            static let info : UIColor = UIColor(red: 49/255, green: 112/255, blue: 143/255, alpha: 1.00).withAlphaComponent(0.8) //rgb(49, 112, 143)
            static let warning : UIColor =  UIColor(red: 49/255, green: 112/255, blue: 143/255, alpha: 1.00).withAlphaComponent(0.8)
            static let success : UIColor = UIColor(red: 60/255, green: 118/255, blue: 61/255, alpha: 1.00).withAlphaComponent(0.8) //rgb(60, 118, 61)
            static let normal : UIColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.00).withAlphaComponent(0.8) //rgb(60, 118, 61)
        }
        struct ITEMS_CELLS {
            static let circlemust : UIColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00)
            static let circleRed : UIColor = UIColor(red: 196/255, green: 42/255, blue: 16/255, alpha: 1.00)
            static let circleYellow : UIColor = UIColor(red: 248/255, green: 198/255, blue: 10/255, alpha: 1.00)
            static let shadowItems : UIColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1.00)
            static let gradientA : UIColor! = UIColor.clear
            static let gradientB : UIColor! = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.00)
            static let gradientTickets: [CGColor]! = [COLORS.ITEMS_CELLS.gradientA.cgColor, COLORS.ITEMS_CELLS.gradientB.cgColor]
            static var titleNotInclude : UIColor = UIColor(red: 196/255, green: 42/255, blue: 16/255, alpha: 1.00)
            static let titleInclude : UIColor = UIColor(red: 51/255, green: 163/255, blue: 0/255, alpha: 1.00)
            static var tabInactive : UIColor {
                get {
                    switch appDelegate.itemParkSelected.code.uppercased() {
                    case "XA", "FE":
                        return UIColor(named: "Colors/off_xailing") ?? UIColor(red: 171/255, green: 224/255, blue: 230/255, alpha: 1.00)
                    default:
                        return UIColor(red: 171/255, green: 224/255, blue: 230/255, alpha: 1.00)
                    }
                }
            }
            static var tabActive : UIColor {
                get {
                    switch appDelegate.itemParkSelected.code.uppercased() {
                    case "XA", "FE":
                        return UIColor(named: "Colors/basic_xailing") ?? UIColor(red: 84/255, green: 192/255, blue: 204/255, alpha: 1.00)
                    default:
                        return UIColor(red: 84/255, green: 192/255, blue: 204/255, alpha: 1.00)
                    }
                }
            }
            
            static var tabActiveOutline : UIColor {
                get {
                    switch appDelegate.itemParkSelected.code.uppercased() {
                    case "XA", "FE":
                        return UIColor(named: "Colors/outline_xailing") ?? UIColor(red: 84/255, green: 192/255, blue: 204/255, alpha: 1.00)
                    default:
                        return UIColor(red: 84/255, green: 192/255, blue: 204/255, alpha: 1.00)
                    }
                }
            }
            
            static let bgSideMenuXCA : UIColor = UIColor(red: 220/255, green: 217/255, blue: 100/255, alpha: 1.00)
            static let bgSideMenuXCB : UIColor = UIColor(red: 126/255, green: 160/255, blue: 14/255, alpha: 1.00)
            static let bgSideMenuXHA : UIColor = UIColor(red: 132/255, green: 198/255, blue: 246/255, alpha: 1.00)
            static let bgSideMenuXHB : UIColor = UIColor(red: 12/255, green: 106/255, blue: 175/255, alpha: 1.00)
            static let bgSubFilter : UIColor = UIColor(red: 250/255, green: 247/255, blue: 247/255, alpha: 1.00)
            static let btnHomeOrange : UIColor = UIColor(red: 246/255, green: 147/255, blue: 29/255, alpha: 1.00)
            static let btnHomeGreen : UIColor = UIColor(red: 0/255, green: 200/255, blue: 83/255, alpha: 1.00)
            static let btnHomeDefault : UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.00)
            static let bckCellSin : UIColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.00)
            static let bckCellCon : UIColor = UIColor(red: 246/255, green: 68/255, blue: 54/255, alpha: 1.00)
            static let bckCellGen : UIColor = UIColor(red: 51/255, green: 51/255, blue: 232/255, alpha: 1.00)
            static let bckCellRest : UIColor = UIColor(red: 51/255, green: 51/255, blue: 232/255, alpha: 1.00)
            
            static var titleCell : UIColor {
                get {
                    switch appDelegate.itemParkSelected.code.uppercased() {
                    case "FE":
                        return UIColor(named: "Colors/basic_xailing") ?? UIColor(red: 171/255, green: 224/255, blue: 230/255, alpha: 1.00)
                    default:
                        return UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.00)
                    }
                }
            }
            
            static var viewSeparator : UIColor {
                get {
                    switch appDelegate.itemParkSelected.code.uppercased() {
                    case "FE":
                        return UIColor(named: "Colors/outline_xailing") ?? UIColor(red: 188/255, green: 221/255, blue: 167/255, alpha: 1.00)
                    default:
                        return UIColor(red: 188/255, green: 221/255, blue: 167/255, alpha: 1.00)
                    }
                }
            }
        }
        
        struct GENERAL{
            static let btnGo : UIColor = UIColor(red: 120/255, green: 160/255, blue: 14/255, alpha: 1.00)
            static let btnFilter : UIColor = UIColor(red: 84/255, green: 192/255, blue: 204/255, alpha: 1.00)
            static let colorLine : UIColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
            static let bgBtnGrad1A : UIColor = UIColor(red: 111/255, green: 181/255, blue: 255/255, alpha: 1.00)
            static let bgBtnGrad1B : UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.00)
            static let lineGray : UIColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1.00)
            static let linePolyline : UIColor = UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.00)
            static let navBooking : UIColor = UIColor(red: 26/255, green: 101/255, blue: 66/255, alpha: 1.00)
            static let customDarkMode : UIColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
            static let customRedDarkModeXF : UIColor = UIColor(red: 255/255, green: 68/255, blue: 30/255, alpha: 1.00)
        }
        
        struct MARKER_MAP {
            static let route_white : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.00)
            static let route_blue : UIColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.00)
            static let route_red : UIColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00)
            static let route_brick : UIColor = UIColor(red: 158/255, green: 71/255, blue: 0/255, alpha: 1.00)
            static let route_black : UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.00)
            static let route_green : UIColor = UIColor(red: 38/255, green: 219/255, blue: 0/255, alpha: 1.00)
            static let activity : UIColor = UIColor(red: 131/255, green: 27/255, blue: 27/255, alpha: 1.00)
            static let service: UIColor = UIColor(red: 79/255, green: 152/255, blue: 240/255, alpha: 1.00)
            static let xelfie: UIColor = UIColor(red: 255/255, green: 222/255, blue: 23/255, alpha: 1.00)
        }
        
        struct PHOTOPASS {
            static let yellowMain : UIColor = UIColor(red: 255/255, green: 229/255, blue: 18/255, alpha: 1.00)
            static let btnDisabledValidateCode : UIColor =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.00)
            static let btnEnabledValidateCode : UIColor =  UIColor(red: 0/255, green: 221/255, blue: 81/255, alpha: 1.00)
            static let bckHeader : UIColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.00)
            static let titleHeader : UIColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.00)
        }
        
        struct HOTEL{
            static let mexicanPink : UIColor = UIColor(red: 233/255, green: 37/255, blue: 155/255, alpha: 1.00)
        }
        
        struct TICKETS {
            static let ticketXC : UIColor = UIColor(red: 51/255, green: 153/255, blue: 0/255, alpha: 1.00)
            static let ticketXH : UIColor = UIColor(red: 0/255, green: 165/255, blue: 234/255, alpha: 1.00)
            static let ticketXS : UIColor = UIColor(red: 230/255, green: 194/255, blue: 0/255, alpha: 1.00)
            static let ticketXP : UIColor = UIColor(red: 255/255, green: 118/255, blue: 26/255, alpha: 1.00)
            static let ticketXPF : UIColor = UIColor(red: 211/255, green: 45/255, blue: 0/255, alpha: 1.00)
            static let ticketXV : UIColor = UIColor(red: 137/255, green: 4/255, blue: 4/255, alpha: 1.00)
            static let ticketXO : UIColor = UIColor(red: 156/255, green: 28/255, blue: 100/255, alpha: 1.00)
            static let ticketXT : UIColor = UIColor(red: 158/255, green: 22/255, blue: 79/255, alpha: 1.00)
            static let ticketDEF : UIColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.00)
            static let ticketXY : UIColor = UIColor(red: 91/255, green: 52/255, blue: 43/255, alpha: 1.00)
            
            static let ticketOff : UIColor = UIColor(red: 83/255, green: 143/255, blue: 189/255, alpha: 1.00)
            static let colorBuy : UIColor = UIColor(red: 248/255, green: 148/255, blue: 29/255, alpha: 1.00)
            static let colorCancel : UIColor = UIColor(red: 187/255, green: 25/255, blue: 25/255, alpha: 1.00)
            static let colorValid : UIColor = UIColor(red: 184/255, green: 0/255, blue: 0/255, alpha: 1.00)
            static let colorClarification : UIColor = UIColor.darkGray
            
            //Add Ticket
            static let colorTextFieldBlue : UIColor = UIColor(red: 41/255, green: 118/255, blue: 209/255, alpha: 1.00)
            static let colorTextFieldOrage : UIColor = UIColor(red: 255/255, green: 139/255, blue: 0/255, alpha: 1.00)
            static let colorTextFieldRed : UIColor = UIColor(red: 189/255, green: 34/255, blue: 34/255, alpha: 1.00)
        }
        
        struct XAVAGE {
            static let redEntradas : UIColor = UIColor(red: 91/255, green: 0/255, blue: 1/255, alpha: 1.00)
        }
    }
}
