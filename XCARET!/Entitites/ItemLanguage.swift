
//
//  ItemLanguage.swift
//  XCARET!
//
//  Created by Angelica Can on 12/5/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation

open class ItemLangLegal {
    var title: String!
    var desc : String!
    var isoLang : String!
    init() {
        self.title = ""
        self.desc = ""
        self.isoLang = ""
    }
}


open class ItemLanguage{
    var isoLang : String
    var name : String
    var color : String
    
    init() {
        isoLang = ""
        name = ""
        color = ""
    }
}

open class ItemLanguageAdmission{
    var isoLang : String
    var name : String
    var description : String
    var days : String
    var longDescription : String
    var duration : String
    var include : String
    var information : String
    var slogan: String
    var recomendations: String
    
    init() {
        isoLang = ""
        name = ""
        description = ""
        days = ""
        longDescription = ""
        duration = ""
        include = ""
        information = ""
        slogan = ""
        recomendations = ""
    }
}

open class ItemLangDetail {
    var isoLang : String
    var name : String
    var description : String!
    var include : String!
    var warning : String!
    
    init() {
        self.isoLang = ""
        self.name = ""
        self.description = ""
        self.include = ""
        self.warning = ""
    }
}

open class ItemLangPark {
    var isoLang : String!
    var slogan : String!
    var include : String!
    var recomendations : String!
    var description : String!
    var address : String!
    var p_schelude : String!
    
    init() {
        self.isoLang = ""
        self.slogan = ""
        self.include = ""
        self.recomendations = ""
        self.description = ""
        self.address = ""
        self.p_schelude = ""
    }
}

open class ItemLangPicture{
    var isoLang: String!
    var name : String!
    init() {
        self.isoLang = ""
        self.name = ""
    }
}

open class ItemLangContentPrograms{
    var isoLang : String
    var name : String
    var description : String!
    
    init() {
        self.isoLang = ""
        self.name = ""
        self.description = ""
    }
}

open class ItemLangDestinations{
    var isoLang : String!
    var address : String!
    
    init() {
        self.isoLang = ""
        self.address = ""
    }
}


