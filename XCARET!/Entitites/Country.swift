//
//  Country.swift
//  XCARET!
//
//  Created by Angelica Can on 19/07/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import Foundation
import RSSelectionMenu
import SwiftyJSON

open class Country : NSObject, UniqueProperty{
    var id: Int
    var code: String
    var name: String
    
    override init(){
        self.id = 0
        self.code = ""
        self.name = ""
    }
    
    init(id: Int, code: String, name: String){
        self.id = id
        self.code = code
        self.name = name
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.code = key
        self.id = json["ID"].intValue
        self.name = json["Name"].stringValue
    }
    
    public func uniquePropertyName() -> String {
        return "id"
    }
    
    
    
}
