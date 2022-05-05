//
//  Tools.swift
//  XCARET!
//
//  Created by Angelica Can on 11/20/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Kingfisher
import FBSDKCoreKit


open class Tools {
    static let shared = Tools()
    fileprivate var locationManager: CLLocationManager! = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func isLocationServiceEnabled() -> Bool{
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    func ask4LocationPermission(){
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
            return
        }
    }
    
    func ask4LocationPermission() -> Bool{
        var permissionResult: Bool = true
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
            permissionResult = false
        }
        return permissionResult
    }
    
    func ask4FacebookPermissions() -> Bool{
        var permissionResult: Bool = true
        if #available(iOS 14, *) {
            Settings.setAdvertiserTrackingEnabled(true)
        }
        return permissionResult
    }
    
    func inThePark(lat: Double, lon: Double) -> Bool {
        let coord1 = CLLocation(latitude: lat, longitude: lon)
        let coord2 = CLLocation(latitude: self.appDelegate.itemMapSelected.latitude, longitude: self.appDelegate.itemMapSelected.longitude)
        let distance = ceil(coord1.distance(from: coord2) / 1000)
        return distance <= 1.5
    }
    
    func ask4PermissionApp() -> Bool{
        var permissionResult: Bool = true
        //Validamos que los permisos sean satisfactorios
        permissionResult = self.ask4PermissionNotification()
        permissionResult = self.ask4LocationPermission()
        permissionResult = self.ask4FacebookPermissions()
        return permissionResult
    }
    
    func ask4PermissionNotification() -> Bool{
        var permissionFirst = AppUserDefaults.value(forKey: .Permission, fallBackValue: false).boolValue
        if !permissionFirst {
            permissionFirst = true
            AppUserDefaults.save(value: true, forKey: .Permission)
            appDelegate.ask4NotificationPermission(application: UIApplication.shared)
        }
        return permissionFirst
    }
    
    
    /*func ask4PermissionTransparency() -> Bool{
        if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        if status == .authorized {
                                ApplicationDelegate.shared.application(
                                    application,
                                    didFinishLaunchingWithOptions: launchOptions
                                )
                        }
                    }
            
        }
    }*/
    
    func isFormatHours24() -> Bool {
        var is24hrs = false
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        if formatter.contains("a"){
            is24hrs = false
        }else{
            is24hrs = true
        }
        return is24hrs
    }
    
    func getFormatHours(hour: String!, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        let newDateString = dateFormatter.date(from: hour)
        //print("Hora: \(newDateString)")
        
        let dateFormatter12Hrs = DateFormatter()
        dateFormatter12Hrs.dateFormat = "h:mm a"
        let hours12Hrs = dateFormatter12Hrs.string(from: newDateString!)
        return hours12Hrs
    }
    
    
    func castDateTicket(dateStr : String) -> String {
        var dateWithFormat : String = ""
        //let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
        let dateReal = convertDateToString(format: "yyyy-MM-dd'T'HH:mm:ss", dateStr: dateStr)
//        let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
        let newFormat = Constants.LANG.current == "es" ? "dd/MMM/yyyy" : "MMM/dd/yyyy"
        dateWithFormat = convertStringToDate(format: newFormat, dateConvert: dateReal)
        
        return dateWithFormat
    }
    
    func castMonthYearTicket(dateStr : String) -> String {
        var dateWithFormat : String = ""
        //let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
//        let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
        let dateReal = convertDateToString(format: "yyyy-MM-dd'T'HH:mm:ss", dateStr: dateStr)
        let newFormat = Constants.LANG.current == "es" ? "MMM/yyyy" : "MMM/yyyy"
        dateWithFormat = convertStringToDate(format: newFormat, dateConvert: dateReal)
        
        return dateWithFormat
    }
    
    func castDayTicket(dateStr : String) -> String {
        var dateWithFormat : String = ""
        
        //let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
        let dateReal = convertDateToString(format: "yyyy-MM-dd'T'HH:mm:ss", dateStr: dateStr)
//        let dateReal = convertDateToString(format: "yyyyMMdd", dateStr: dateStr)
        let newFormat = "dd"
        dateWithFormat = convertStringToDate(format: newFormat, dateConvert: dateReal)
        return dateWithFormat
    }
    
    func convertDateToString(format: String, dateStr : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") //Locale(identifier: "en_US")//Locale(identifier: "en_US_POSIX") //
        dateFormatter.dateFormat = format
        if !dateStr.isEmpty{
            let newDate = dateFormatter.date(from: dateStr)
            return newDate ?? Date()
        }else{
            let newDate = dateFormatter.date(from: "2021-10-19T00:00:00")
            return newDate ?? Date()
        }
    }
    
    func convertStringToDate(format: String, dateConvert : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // 09:10 PM
        //dateFormatter12Hrs.dateFormat = "h:mm a" // 9:10 PM
        let newDateStr = dateFormatter.string(from: dateConvert)
        return newDateStr
    }
    
    func callNumber(number: String){
        print("Tel \(number)")
        guard let url = URL(string: "tel://\(number)") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func callNumber(number: String, ext : String){
        guard let url = URL(string: "tel://\(number),\(ext)") else {
            return //be safe
        }
                
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func version() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func build() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    func getImageKingFisher(urlImage: String, completion: @escaping (UIImage) ->()){
        var imageDownload = UIImage()
        let img = UIImageView()
        let url = URL(string: urlImage)
        img.kf.setImage(with: url,
                        placeholder : UIImage(named: "Icons/ico_noprofile")) { result in
                            switch result {
                            case .success(let value):
                                imageDownload = value.image
                                completion(imageDownload)
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                                completion(imageDownload)
                            }
        }
    }
    
    /*BarCode*/
    func otherGenerateBarCode(string : String,  barcodeMode: BarcodeMode) -> UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: barcodeMode.filterName)
        filter?.setValue(data, forKey: "inputMessage")
        guard let outputImage = filter?.outputImage else {
            return UIImage()
        }
        
        let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        let output = outputImage.transformed(by: transform)
        //let context = CIContext(options: nil)
        //let newImage2 = UIImage(cgImage: outputImage as! CGImage)
        //let newImage = UIImage (cgImage: context.createCGImage(output, from: output.extent)!)
        return UIImage(ciImage: output)
        //return newImage
    }
}
