//
//  ArgAppUpdater.swift
//  XCARET!
//
//  Created by Angelica Can on 8/21/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
    //let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
    // You can add many thing based on "http://itunes.apple.com/lookup?bundleId=\(identifier)"  response
    // here version and trackViewUrl are key of URL response
    // so you can add all key beased on your requirement.
    
}

class ArgAppUpdater: NSObject {
    private static var _instance: ArgAppUpdater?;
    
    private override init() {
        
    }
    
    public static func getSingleton() -> ArgAppUpdater {
        if (ArgAppUpdater._instance == nil) {
            ArgAppUpdater._instance = ArgAppUpdater.init();
        }
        return ArgAppUpdater._instance!;
    }
    
    
    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                
                print("Data:::",data)
                print("response###",response!)
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                print("dictionary",dictionary!)
                
                
                guard let info = result.results.first else { throw VersionError.invalidResponse }
                print("result:::",result)
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        
        print("task ******", task)
        return task
    }
    
    private func checkVersion(completion: @escaping (Bool, AppInfo?) -> Void){
        var existUpdate : Bool = false
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in
            
            let appStoreAppVersion = info?.version
            
            if let error = error {
                print(error)
            //}else if appStoreAppVersion! != currentVersion! {
            }else if appStoreAppVersion?.compare(currentVersion!, options: .numeric) == .orderedDescending {
                appDelegate.appInfo = info
                AppUserDefaults.save(value: true, forKey: .ExistUpdateApp)
                existUpdate = true
            }else{
                print("app Actualizada")
                AppUserDefaults.save(value: true, forKey: .ShowUpdateApp)
                AppUserDefaults.save(value: false, forKey: .ExistUpdateApp)
            }
            completion(existUpdate, info)
        }
    }
    
    private  func checkVersion(force: Bool) {
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in
            
            let appStoreAppVersion = info?.version
            
            if let error = error {
                print(error)
            }else if appStoreAppVersion!.compare(currentVersion!, options: .numeric) == .orderedDescending {
                appDelegate.appInfo = info
                AppUserDefaults.save(value: true, forKey: .ExistUpdateApp)
                DispatchQueue.main.async {
                    let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    topController.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                }
            }else{
                print("app Actualizada")
                AppUserDefaults.save(value: true, forKey: .ShowUpdateApp)
                AppUserDefaults.save(value: false, forKey: .ExistUpdateApp)
            }
        }
    }
    
    func showUpdateConfirmInit(){
        checkVersion { (isUpdate, info) in
            if isUpdate{
                let showUpdateApp = AppUserDefaults.value(forKey: .ShowUpdateApp, fallBackValue: true).boolValue
                if showUpdateApp {
                    DispatchQueue.main.async {
                        let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                        topController.showAppUpdateAlert(Version: (info?.version)!, Force: false, AppURL: (info?.trackViewUrl)!)
                    }
                }
            }
        }
    }
    
    func showUpdateWithConfirmation() {
        checkVersion(force : false)
    }
    
    func showUpdateWithForce() {
        checkVersion(force : true)
    }
    
    
    
}

extension UIViewController {
    fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        print("AppURL:::::",AppURL)
        
        let bundleName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String;
        //let alertMessage = "\(bundleName) Version \(Version) is available on AppStore."
        let alertMessage = String(format: "lblLeyendVersion".localized(), arguments: [bundleName, Version])
        //let alertMessage = String(format: "lblLeyendVersion".localized(), [bundleName, Version])
        let alertTitle = "lbl_new_version".getNameLabel()//"lblNewVersion".localized()
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if !Force {
            let notNowButton = UIAlertAction(title: "lbl_opt_not_now".getNameLabel()/*"lblOptNotNow".localized()*/, style: .default) { (action:UIAlertAction) in
                AppUserDefaults.save(value: false, forKey: .ShowUpdateApp)
                print("Don't Call API");
            }
            alertController.addAction(notNowButton)
        }
        
        let updateButton = UIAlertAction(title: "lbl_opt_update".getNameLabel()/*"lblOptUpdate".localized()*/, style: .default) { (action:UIAlertAction) in
            print("Call API");
            print("No update")
            //AppUserDefaults.save(value: true, forKey: .ShowUpdateApp)
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
