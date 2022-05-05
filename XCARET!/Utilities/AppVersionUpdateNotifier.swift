//
//  AppVersionUpdateNotifier.swift
//  XCARET!
//
//  Created by Angelica Can on 8/20/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import Alamofire

class AppVersionUpdateNotifier {
    static let shared = AppVersionUpdateNotifier()
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        WebService.shared.execute(url: "https://itunes.apple.com/lookup?bundleId=\(ourBundleId)", httpMethod: .get, params: nil) { (success, json) in
            var isNew: Bool?
            var versionStr: String?
            var appVersion = ""
            if success {
                print(json)
                let result = json["results"].arrayValue
               
                for item in result {
                    if let dic = item.dictionary {
                        appVersion = dic["version"]!.stringValue
                        print(appVersion)
                    }
                }
            }
            
            isNew = ourVersion != appVersion
            versionStr = appVersion
            
            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionStr)
        }
    }
}
