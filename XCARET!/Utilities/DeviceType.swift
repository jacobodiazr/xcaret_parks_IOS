//
//  DeviceType.swift
//  XCARET!
//
//  Created by Javier Canto on 8/10/17.
//  Copyright © 2017 Experiencias Xcaret. All rights reserved.
//

import UIKit

public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8Plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    iPhoneXS         = "iPhone XS",
    iPhoneXSMax      = "iPhone XS Max",
    iPhoneXR         = "iPhone XR",
    iPhone11         = "iPhone 11",
    iPhone11Pro      = "iPhone 11 Pro",
    iPhone11ProMax   = "iPhone 11 Pro Max",
    iPhoneSE2Gen     = "iPhone SE (2nd generation)",
    iPhone12mini     = "iPhone 12 mini",
    iPhone12         = "iPhone 12",
    iPhone12Pro      = "iPhone 12 Pro",
    iPhone12ProMax   = "iPhone 12 Pro Max",
    iPhone13mini     = "iPhone 13 mini",
    iPhone13         = "iPhone 13",
    iPhone13Pro      = "iPhone 13 Pro",
    iPhone13ProMax   = "iPhone 13 Pro Max",
    unrecognized     = "?unrecognized?"
}

public extension UIDevice {
    
    var getImage: String {
        var image = ""
        switch UIScreen.main.bounds.height {
        case 568: //SE
            image = "Splash/BgLoginSE"
        case 667: //6,7,8
            image = "Splash/BgLogin"
        case 736: // Plus
            image = "Splash/BgLoginPlus"
        case 812: //X
            image = "Splash/BgLoginX"
        default:
            image = "Splash/BgLogin"
        }
        return image
    }
    
    
    func setTopButtonCloseBuy() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 50
        default:
            top = 25
        }
        return top
    }
    
    var getOnBoard: [UIImage]!{
        var images = [UIImage]()
        var folder : String = ""
        switch UIScreen.main.bounds.height {
        case 568: //SE
            folder = "Bck_SE"
        case 667: //6,7,8
             folder = "Bck_6s"
        case 736: // Plus
             folder = "Bck_Plus"
        case 812: //X
             folder = "Bck_X"
        default:
             folder = "Bck_SE"
        }
        images = [UIImage(named: "OnBoard/\(folder)/0")!, UIImage(named: "OnBoard/\(folder)/1")!,
                  UIImage(named: "OnBoard/\(folder)/2")!, UIImage(named: "OnBoard/\(folder)/3")!]
        
        return images
    }
    
    func getTopLogo() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 75
        default:
            top = 50
        }
        return top
    }
    
    func setTopWKWebView() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 75
        default:
            top = 60
        }
        return top
    }
    
    func getTopCollection() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 0
        default:
            top = 0
        }
        return top
    }
    
    func getHeightSideMenu() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 107
        default:
            height = 107
        }
        return height
    }
    
    func getHeightSearch() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 160
        default:
            height = 160
        }
        return height
    }
    
    func getiPhoneX() -> Bool {
        var iphonex : Bool = false
        let type = getTypeIphone()
        switch type {
        case "X":
            iphonex = true
        default:
            iphonex = false
        }
        return iphonex
    }
    
    func getPositionCollActivities() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 145
        default:
            height = 125
        }
        return height
    }
    
    func getPositionCollServices() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 115
        default:
            height = 95
        }
        return height
    }
    
    func getHeightViewCode() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 70
        default:
            height = 50
        }
        return height
    }
    
    func getHeightHomeSearch() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 35
        default:
            height = 35
        }
        return height
    }
    
    func getTopHomeSearch() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 40
        default:
            height = 20
        }
        return height
    }
    
    func getTopHome() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X", "I":
            height = 0
        default:
            height = 15
        }
        return height
    }
    
    func getTopHomeCardPref() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 64
        default:
            height = 44
        }
        return height
    }
    
    func getHeightHomeMenu() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 80
        default:
            height = 60
        }
        return height
    }
    
    func getHeightHeaderHome() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 175.0
        default:
            height = 175.0
        }
        return height
    }
    
    func getHeightHomePromociones() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "I":
            height = 20
        default:
            height = 50
        }
        return height
    }
    
    func getHeightCarrito() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 0.0
        default:
            height = 0.0
        }
        return height
    }
    
    func getBottomViewBuy() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = -34
        default:
            height = 0
        }
        return height
    }
    
    func getBottomLeyend() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 80
        default:
            height = 60
        }
        return height
    }
    
    func getHeightHeader() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 80
        default:
            height = 80
        }
        return height
    }
    
    func getHeightWalletSize() -> CGFloat{
        var height : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            height = 680
        default:
            height = 620
        }
        return height
    }
    
    func getTopLogin() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = -20
        default:
            top = 40
        }
        return top
    }
    
    func getTopLoginWith() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 100
        default:
            top = 30
        }
        return top
    }
    
    func getTopEmail() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = -20
        default:
            top = 40
        }
        return top
    }
    
    func getTopKeyBoardDataCard() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "I":
            top = -60
        default:
            top = 0
        }
        return top
    }
    
    
    func getTopCreateAccount() -> CGFloat{
        var top : CGFloat = 0.0
        let type = getTypeIphone()
        switch type {
        case "X":
            top = 20
        default:
            top = 60
        }
        return top
    }
    
    func getTypeIphone() -> String {
        var type = ""
        if UIDevice().userInterfaceIdiom == .phone {
            //for iphone
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334:
                //iPhone 5 or 5S or 5C
                //iPhone 6/6S/7/8
                type = "I"
            case 1920, 2208:
                //iPhone 6+/6S+/7+/8+
                type = "IP"
            case 2436, 2688, 1792:
                //iPhone X, Xs
                //iPhone Xs Max
                //iPhone Xr
                type = "X"
            default:
                type = ""
            }
        }else if UIDevice().userInterfaceIdiom == .pad{
            // for ipad
            type = "I"
        }
        
        return type
    }
    
    func getFolder() -> String {
        var folder : String = ""
        if UIDevice().userInterfaceIdiom == .phone {
            //for iphone
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334:
                //iPhone 5 or 5S or 5C
                //iPhone 6/6S/7/8
                folder = "Background/iphone6/"
            case 1920, 2208:
                //iPhone 6+/6S+/7+/8+
                folder = "Background/iphonePlus/"
            case 2436:
                //iPhone X, Xs
                folder = "Background/iphoneX/"
            case 2688, 1792:
                //iPhone Xs Max
                //iPhone Xr
                folder = "Background/iphoneXR/"
            default:
                folder = "Background/iphone6/"
            }
        }else if UIDevice().userInterfaceIdiom == .pad{
            // for ipad
            folder = "Background/iphone6/"
        }
        
        return folder
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            //if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {  // **ipv6 committed
            if addrFamily == UInt8(AF_INET){
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    var type: Model {
        var systemInfo = utsname()
            uname(&systemInfo)
        
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        
        let modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,1"   : .iPadAir1,
            "iPad4,2"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,11"  : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPadPro9_7_cell,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2Gen,
            "iPhone13,1" : .iPhone12mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            "iPhone14,4" : .iPhone13mini,
            "iPhone14,5" : .iPhone13,
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}
