//
//  FirebaseDB.swift
//  XCARET!
//
//  Created by Angelica Can on 11/7/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import SwiftyJSON
import FirebaseInstanceID

open class FirebaseDB {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let shared = FirebaseDB()
    private var dbHandler: DatabaseHandle?
    private var refTickets : DatabaseReference = DatabaseReference()
    private let refSecurity : DatabaseReference = Database.database(url: "https://xcaretftvym2017security.firebaseio.com/").reference()
    private let refCarShop : DatabaseReference = Database.database(url: "https://xcaretftvym2017productcarshopdev.firebaseio.com/").reference()
    private var refPhotos : DatabaseReference = DatabaseReference()
    private var refInfo : DatabaseReference = DatabaseReference()
    let storageRef = Storage.storage().reference()
    var handleTicket: DatabaseHandle?
    
    init() {
        let typeEnviroment : TypeEnviroment = appDelegate.enviromentProduction
        switch typeEnviroment {
        case .preproduction:
            refInfo = Database.database(url: "https://xcaretftvym2017preprod.firebaseio.com/").reference()
            refTickets = Database.database(url: "https://xcaretftvym2017ticketsprod.firebaseio.com/").reference()
            refPhotos = Database.database(url: "https://xcaretftvym2017photos.firebaseio.com/").reference()
        case .production:
            refInfo = Database.database(url: "https://xcaretftvym2017.firebaseio.com/").reference()
            refTickets = Database.database(url: "https://xcaretftvym2017ticketsprod.firebaseio.com/").reference()
            refPhotos = Database.database(url: "https://xcaretftvym2017photos.firebaseio.com/").reference()
        default:
            refInfo = Database.database(url: "https://parquesxcaret-dev.firebaseio.com/").reference()
            refTickets = Database.database(url: "https://xcaretftvym2017tickets.firebaseio.com/").reference()
            refPhotos = Database.database(url: "https://xcaretftvym2017photosdev.firebaseio.com/").reference()
        }
    }
    
    /*func getEnviroment(simple: Bool = false) -> String{
        let typeEnviroment : TypeEnviroment = appDelegate.enviromentProduction
        switch typeEnviroment {
        case .preproduction:
            return "/preproduction"
        case .production:
            if !simple{
                return "/production/v2"
            }else{
                return "/production"
            }
        default:
            return "/develop"
        }
    }*/
    
    func getToken(completion: @escaping(String) -> Void){
        var token = ""
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                token = "" //Messaging.messaging().fcmToken!
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                token = (result.token)
                print("token: \(token)")
            }
            completion(token)
        }
    }
    
    func getTypeAuthentication(completion: @escaping (AuthenticationType) -> Void){
        var type : AuthenticationType = .anonimous
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    type = .facebook
                case "google.com":
                    type = .google
                case "password":
                    type = .userPass
                case "apple.com":
                    type = .apple
                default:
                    type = .anonimous
                    print("user is signed in with \(userInfo.providerID)")
                }
            }
            completion(type)
        }
    }
    
    func setUserDefaults(name: String, email: String, uid : String, provider: String, country: String = ""){
        print("UID Logged : \(uid)")
        AppUserDefaults.save(value: name, forKey: .UserName)
        AppUserDefaults.save(value: email, forKey: .UserEmail)
        AppUserDefaults.save(value: uid, forKey: .UserUID)
        AppUserDefaults.save(value: provider, forKey: .UserProvider)
        AppUserDefaults.save(value: country, forKey: .UserCountry)
        AppUserDefaults.save(value: true, forKey: .UserIsLogged)
    }
    
    func reserUserDefautls(){
        AppUserDefaults.save(value: "", forKey: .UserName)
        AppUserDefaults.save(value: "", forKey: .UserEmail)
        AppUserDefaults.save(value: "", forKey: .UserUID)
        AppUserDefaults.save(value: "", forKey: .UserProvider)
        AppUserDefaults.save(value: "", forKey: .UserCountry)
        AppUserDefaults.save(value: false, forKey: .UserIsLogged)
        AppUserDefaults.save(value: true, forKey: .ShowUpdateApp)
    }
    
    func linkAuthenticateUserApp(user: UserApp, completion: @escaping (Bool, UserApp) -> Void){
        var authUser: Bool = false
        var userAuth: UserApp = UserApp()
        //Buscamos si existe el usuario
        self.getUserByUID(uid: user.uid) { (exist, userAppExist) in
            
            if exist {
                AnalyticsBR.shared.saveLogin(provider: user.provider, status: true)
                var name = ""
                if user.lastname.isEmpty{
                    name = "\(user.name) \(user.lastname)"
                }else{
                    name = "\(user.name)"
                }
                self.setUserDefaults(name: name, email: user.email, uid: user.uid, provider: user.provider)
                self.updateUser(user: user, completion: { (success, userApp) in
                    if success{
                        completion(exist, user)
                    }else{
                        completion(false, user)
                    }
                })
            }else{
                self.saveUser(user: user, completion: { (success, userAppCreate) in
                    authUser = success
                    userAuth = userAppCreate
                    if authUser {
                        self.setUserDefaults(name: userAuth.name, email: userAuth.email, uid: user.uid, provider: user.provider)
                    }
                    completion(authUser, userAuth)
                })
            }
        }
    }
    
    
    func authUserApp(user: UserApp, completion: @escaping (Bool, UserApp) -> Void){
        var authUser: Bool = false
        var userAuth: UserApp = UserApp()
        //Buscamos si existe el usuario en la base de Firebase
        self.getUserByUID(uid: user.uid) { (exist, userAppExist) in
            //Si existe, guardamos sus datos en UserDefautls
            if exist {
                authUser = true
                userAuth = userAppExist
                AnalyticsBR.shared.saveLogin(provider: user.provider, status: true)
                self.setUserDefaults(name: userAuth.name, email: userAuth.email, uid: user.uid, provider: user.provider, country: userAuth.country)
                completion(authUser, userAuth)
            }else{
                self.saveUser(user: user, completion: { (success, userAppCreate) in
                    authUser = success
                    userAuth = userAppCreate
                    if authUser {
                        self.setUserDefaults(name: userAuth.name, email: userAuth.email, uid: user.uid, provider: user.provider, country: userAuth.country)
                    }
                    completion(authUser, userAuth)
                })
            }
        }
    }
    
    private func updateUser(user: UserApp, completion: @escaping (Bool, UserApp) -> Void){
        let uid = user.uid
        self.getToken { (token) in
            let token: String! = token //Messaging.messaging().fcmToken
            print("token: \(token!)")
            print("uid: \(uid)")
            let data: [String: Any]! = ["email": user.email,
                                        "name": user.name,
                                        "phone": user.phone,
                                        "device": UIDevice().type.rawValue,
                                        "platform": UIDevice.current.systemName,
                                        "version": UIDevice.current.systemVersion,
                                        "lang": Constants.LANG.current,
                                        "token": token!,
                                        "registered": Date().string(format: "dd/MM/yyyy HH:mm:ss"),
                                        "provider" : user.provider,
                                        "country" : user.country,
                                        "macaddress" : UIDevice.current.identifierForVendor?.uuidString ?? ""]
            //Guadamos Datos en Firebase
            //let locationRef = self.ref.child("\(self.getEnviroment(simple: true))/security/visitors/\(uid)")
            let locationRef = self.refSecurity.child("visitors/\(uid)")
            locationRef.updateChildValues(data){
                (error: Error?, ref: DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    AnalyticsBR.shared.saveUser(provider: user.provider, status: false)
                    completion(false, user)
                }else{
                    AnalyticsBR.shared.saveUser(provider: user.provider, status: true)
                    completion(true, user)
                }
            }
        }
    }
    
    private func saveUser(user: UserApp, completion: @escaping (Bool, UserApp) -> Void){
        let uid = user.uid
        self.getToken { (token) in
            let token: String! = token//Messaging.messaging().fcmToken
            print("token: \(token!)")
            print("uid: \(uid)")
            let data: [String: Any]! = ["email": user.email,
                                        "name": user.name,
                                        "phone": user.phone,
                                        "device": UIDevice().type.rawValue,
                                        "platform": UIDevice.current.systemName,
                                        "version": UIDevice.current.systemVersion,
                                        "lang": Constants.LANG.current,
                                        "token": token!,
                                        "registered": Date().string(format: "dd/MM/yyyy HH:mm:ss"),
                                        "provider" : user.provider,
                                        "country" : user.country,
                                        "macaddress" : UIDevice.current.identifierForVendor?.uuidString ?? ""]
            //Guadamos Datos en Firebase
            //let locationRef = self.ref.child("\(self.getEnviroment(simple: true))/security/visitors/\(uid)")
            let locationRef = self.refSecurity.child("visitors/\(uid)")
            locationRef.setValue(data){
                (error: Error?, ref: DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    AnalyticsBR.shared.saveUser(provider: user.provider, status: false)
                    completion(false, user)
                }else{
                    AnalyticsBR.shared.saveUser(provider: user.provider, status: true)
                    completion(true, user)
                }
            }
        }
    }
    
    func getUserByUID(uid: String, completion: @escaping (Bool, UserApp) -> Void){
        var userExist = false
        var userApp : UserApp = UserApp()
        
        //self.ref.child("\(getEnviroment(simple: true))/security/visitors/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
        self.refSecurity.child("visitors/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                userExist = true
                userApp = UserApp()
                let dict = snapshot.value as! [String : Any]
                userApp.name = dict["name"] as? String ?? ""
                userApp.lastname = dict["lastName"] as? String ?? ""
                userApp.middlename = dict["middleName"] as? String ?? ""
                userApp.email = dict["email"] as? String ?? ""
                userApp.lada = dict["lada"] as? String ?? ""
                userApp.phone = dict["phone"] as? String ?? ""
                userApp.country = dict["country"] as? String ?? ""
                userApp.state = dict["state"] as? String ?? ""
                userApp.device = dict["device"] as? String ?? ""
                userApp.platform = dict["platform"] as? String ?? ""
                userApp.version = dict["version"] as? String ?? ""
                userApp.lang = dict["lang"] as? String ?? ""
                userApp.token = dict["token"] as? String ?? ""
                userApp.registered = dict["registered"] as? String ?? ""
                userApp.provider = dict["provider"] as? String ?? ""
                userApp.macaddress = dict["macaddress"] as? String ?? ""
                FirebaseDB.shared.getToken(completion: { (tokenNew) in
                    //let tokenActual = FirebaseDB.shared.getToken()
                    if tokenNew != userApp.token {
                        print("Toquen desiguales")
                        //self.ref.child("\(self.getEnviroment(simple: true))/security/visitors/\(uid)").updateChildValues(["token" : tokenNew])
                        self.refSecurity.child("visitors/\(uid)").updateChildValues(["token" : tokenNew])
                    }
                })
                
                print("Guardamos MacAddress")
                //self.ref.child("\(self.getEnviroment(simple: true))/security/visitors/\(uid)").updateChildValues(["macaddress" : UIDevice.current.identifierForVendor?.uuidString ?? ""])
                self.refSecurity.child("visitors/\(uid)").updateChildValues(["macaddress" : UIDevice.current.identifierForVendor?.uuidString ?? ""])
                
                completion(userExist, userApp)
            }else{
                completion(userExist, userApp)
            }
        })
    }
    
    
    /*****************/
    /*** CATALOGOS ***/
    /*****************/
    
    
    
    /// Funcion que devuelve el catalogo de las categorias de actividades
    ///
    /// - Parameter completion: retorna la lista
    func getCatCategories(completion: @escaping ([ItemCategory]) -> Void){
        var listCategories : [ItemCategory]!
        self.refInfo.child("/clasificators/categories/").observe(.value) { (snapshot) in
            listCategories = [ItemCategory]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemCategory = ItemCategory(key: key, dictionary: postDictionary)
                        listCategories.append(itemCategory)
                    }
                }
            }
            self.appDelegate.listAllCategories = listCategories
            print("Carga categories")
            completion(listCategories)
        }
    }
    
    /// Funcion que devuelve el catalogo de restricciones
    ///
    /// - Parameter completion: retorna la lista
    func getCatRestrictions(completion: @escaping ([ItemRestiction]) -> Void){
        var listRestrictions : [ItemRestiction]!
        self.refInfo.child("/clasificators/restrictions/").observe(.value) { (snapshot) in
            listRestrictions = [ItemRestiction]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemCategory = ItemRestiction(key: key, dictionary: postDictionary)
                        listRestrictions.append(itemCategory)
                    }
                }
            }
            self.appDelegate.listAllRestrictions = listRestrictions
            print("Carga restrictions ")
            completion(listRestrictions)
        }
    }
    
    func getCatSubcategories(completion: @escaping ([ItemSubcategory]) -> Void){
        var listSubcategories : [ItemSubcategory]!
        self.refInfo.child("/clasificators/subcategories/").observe(.value) { (snapshot) in
            listSubcategories = [ItemSubcategory]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemSubcategory = ItemSubcategory(key: key, dictionary: postDictionary)
                        listSubcategories.append(itemSubcategory)
                    }
                }
            }
            self.appDelegate.listAllSubcategories = listSubcategories
            print("Carga subcategories")
            completion(listSubcategories)
        }
        
    }
    
    func getCatRoutes(completion: @escaping ([ItemRoute]) -> Void){
        var listRoutes : [ItemRoute]!
        self.refInfo.child("/clasificators/routs/").observe(.value) { (snapshot) in
            listRoutes = [ItemRoute]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemRoute = ItemRoute(key: key, dictionary: postDictionary)
                        listRoutes.append(itemRoute)
                    }
                }
            }
            self.appDelegate.listAllRoutes = listRoutes.sorted(by: { (rout0, rout1) -> Bool in
                return rout0.r_code < rout1.r_code
            })
            print("Carga routes")
            completion(listRoutes)
        }
    }
    
    func getCatServices(completion: @escaping ([ItemService]) -> Void){
        var listServices : [ItemService]!
        self.refInfo.child("/clasificators/services/").observe(.value) { (snapshot) in
            listServices = [ItemService]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemService = ItemService(key: key, dictionary: postDictionary)
                        listServices.append(itemService)
                    }
                }
            }
            self.appDelegate.listAllServices = listServices
            print("Carga services")
            completion(listServices)
        }
    }
    
    func getCatFiltersMap(completion: @escaping ([ItemFilterMap]) -> Void){
        var listFilters : [ItemFilterMap] = [ItemFilterMap]()
        appDelegate.listAllFilters = [ItemFilterMap]()
        self.refInfo.child("/clasificators/filtersmap/").queryOrdered(byChild: "f_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listFilters = [ItemFilterMap]()
                for snap in snapshots{
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemService = ItemFilterMap(key: key, dictionary: postDictionary)
                        listFilters.append(itemService)
                    }
                }
                self.appDelegate.listAllFilters = listFilters.sorted(by: { (filt0, filt1) -> Bool in
                    return filt0.f_order < filt1.f_order
                })
            }
            print("Carga filtersmap")
            completion(listFilters)
        }
    }
    
    func getCatTags(completion: @escaping ([ItemTag]) -> Void){
        var listTags : [ItemTag]!
        self.refInfo.child("/clasificators/tags/").observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listTags = [ItemTag]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemTags = ItemTag(key: key, dictionary: postDictionary)
                        listTags.append(itemTags)
                    }
                }
            }
            self.appDelegate.listAllTags  = listTags
            print("Carga tags")
            completion(listTags)
        }
    }
    
    /// Funcion que devuelve el catalogo de las categorias de actividades
    ///
    /// - Parameter completion: retorna la lista
    func getScheduleDestination(completion: @escaping ([ItemScheduleDest]) -> Void){
        var listScheduleDest : [ItemScheduleDest]!
        self.refInfo.child("/clasificators/destination_schedules/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { snapshot in
            listScheduleDest = [ItemScheduleDest]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemScheduleDest = ItemScheduleDest(key: key, dictionary: postDictionary)
                        listScheduleDest.append(itemScheduleDest)
                    }
                }
            }
            self.appDelegate.listScheduleDest = listScheduleDest
            print("Carga Schedule Dest")
            completion(listScheduleDest)
        }
    }
    
    
    
    /*****************/
    /*** ENTIDADES ***/
    /*****************/
    
    /// Función que obtiene la lista de las restricciones por actividad
    ///
    /// - Parameter completion: retorna la lista
    func getRestrictionsByActivity(completion: @escaping ([ItemRestrictionsByActivity]) -> Void){
        var listRestByAct : [ItemRestrictionsByActivity]!
        self.refInfo.child("/core/restrictionactivities/").observe(.value) { (snapshot) in
            listRestByAct = [ItemRestrictionsByActivity]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemRest = ItemRestrictionsByActivity(key: key, dictionary: postDictionary)
                        listRestByAct.append(itemRest)
                    }
                }
            }
            self.appDelegate.listAllRestByActivity = listRestByAct
            print("Carga restrictionactivitities")
            completion(listRestByAct)
        }
    }
    
    
    /// Funcion que obtiene la lista de las categorias que pertenecen a una actividad
    ///
    /// - Parameter completion: retorna la lista
    func getCategoryByActivity(completion: @escaping ([ItemCategoryByActivity]) -> Void){
        var listCatByAct : [ItemCategoryByActivity]!
        self.refInfo.child("/core/categoriesactivities/").observe(.value) { (snapshot) in
            listCatByAct = [ItemCategoryByActivity]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemAct = ItemCategoryByActivity(key: key, dictionary: postDictionary)
                        listCatByAct.append(itemAct)
                    }
                }
            }
            self.appDelegate.listAllCateByActivity = listCatByAct
            print("Carga categoriesactivities")
            completion(listCatByAct)
        }
    }
    
    
    func getSubcategoryByActivity(completion: @escaping ([ItemSubcategoryByActivity]) -> Void){
        var listSubByAct : [ItemSubcategoryByActivity]!
        self.refInfo.child("/core/subcategoryactivities/").observe(.value) { (snapshot) in
            listSubByAct = [ItemSubcategoryByActivity]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemSub = ItemSubcategoryByActivity(key: key, dictionary: postDictionary)
                        listSubByAct.append(itemSub)
                    }
                }
            }
            self.appDelegate.listAllSubCatByActivity = listSubByAct
            print("Carga subcategoriesactivities")
            completion(listSubByAct)
        }
    }
    
    /// Funcion que devuelve la lista de las actividades
    ///
    /// - Parameter completion: retorna la lista
    func getActivities(completion: @escaping ([ItemActivity]) -> Void){
        var listActivities : [ItemActivity]!

        self.refInfo.child("/core/activities/").queryOrdered(byChild: "act_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listActivities = [ItemActivity]()
                self.appDelegate.listAllActivities = [ItemActivity]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemAct = ItemActivity(key: key, dictionary: postDictionary)
                        listActivities.append(itemAct)
                    }
                }
                self.appDelegate.listAllActivities = listActivities.sorted(by: { (act0, act1) -> Bool in
                    return act0.act_number < act1.act_number
                })
            }
            print("Carga activitites")
            completion(listActivities)
        }
    }

    
    func getAwards(completion: @escaping ([ItemAward]) -> Void){
        var listAward : [ItemAward]!
        self.refInfo.child("/core/awards/").queryOrdered(byChild: "a_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listAward = [ItemAward]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemAward = ItemAward(key: key, dictionary: postDictionary)
                        listAward.append(itemAward)
                    }
                }
                self.appDelegate.listAllAwards = listAward
            }
            print("Carga Awards")
            completion(listAward)
        }
    }
    
    func getParks(completion: @escaping ([ItemPark]) -> Void){
        var listParksEnabled: [ItemPark]!
        var listAllParks : [ItemPark]!
        self.refInfo.child("/core/parks/").observe(.value) { (snapshot) in
        //self.ref.child("\(getEnviroment())/core/parks/").queryOrdered(byChild: "p_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listParksEnabled = [ItemPark]()
                listAllParks = [ItemPark]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemPark = ItemPark(key: key, dictionary: postDictionary)
                        if itemPark.status{
                            //Aquí validamos que esta version de la app pueda ver el parque
                            let versionCurrentApp = Tools.shared.version()
                            print("versionCurrentApp -> \(versionCurrentApp!) -- \(itemPark.code!) : \(itemPark.version_ios)")
                            let versionCompare = versionCurrentApp!.compare(itemPark.version_ios, options: .numeric)
                            if versionCompare == .orderedSame{
                                listParksEnabled.append(itemPark)
                            }else if versionCompare == .orderedDescending{
                                listParksEnabled.append(itemPark)
                            }
                        }
                        listAllParks.append(itemPark)
                    }
                }
                self.appDelegate.listAllParksEnabled = listParksEnabled.sorted(by: { (ip0, ip1) -> Bool in
                    return ip0.order < ip1.order
                })
                self.appDelegate.listAllParks = listAllParks
            }
            print("Carga parks")
            completion(listParksEnabled)
        }
    }
    
    func getSeason(completion: @escaping ([ItemSeason]) -> Void){
        var listSeason : [ItemSeason]!
        self.refInfo.child("/clasificators/seasons/").observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listSeason = [ItemSeason]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemSeason = ItemSeason(key: key, dictionary: postDictionary)
                        listSeason.append(itemSeason)
                    }
                }
                self.appDelegate.listSeason = listSeason
            }
            print("Carga seasons")
            completion(listSeason)
        }
    }
    
    
    func getCalendarDF(completion: @escaping ([ItemSeason]) -> Void){
        var listCalendarDF : [ItemSeason]!
        self.refInfo.child("/clasificators/calendardf/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                listCalendarDF = [ItemSeason]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemCalendar = ItemSeason(key: key, dictionary: postDictionary)
                        listCalendarDF.append(itemCalendar)
                    }
                }
                self.appDelegate.listCalendar = listCalendarDF
            }
            print("Carga calendardf")
            completion(listCalendarDF)
        }
    }
    
    func getSchedules(completion: @escaping ([ItemSchedule]) -> Void){
        var listSchedules : [ItemSchedule]!
        self.refInfo.child("/core/schedules/").queryOrdered(byChild: "sc_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            listSchedules = [ItemSchedule]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemSchedule = ItemSchedule(key: key, dictionary: postDictionary)
                        listSchedules.append(itemSchedule)
                    }
                }
            }
            self.appDelegate.listAllSchedules = listSchedules
            print("Carga schedules")
            completion(listSchedules)
        }
    }
    
    func getSchedulesDF(completion: @escaping ([ItemSchedule]) -> Void){
        var listSchedulesDF : [ItemSchedule]!
        self.refInfo.child("/core/schedulesdf/").queryOrdered(byChild: "sc_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            listSchedulesDF = [ItemSchedule]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemSchedule = ItemSchedule( key: key, dictionary: postDictionary)
                        listSchedulesDF.append(itemSchedule)
                    }
                }
            }
            self.appDelegate.listAllSchedulesDF = listSchedulesDF
            print("Carga schedulesdf")
            completion(listSchedulesDF)
        }
    }
    
    func getTagsActivity(completion: @escaping ([ItemTagByActivity]) -> Void){
        var listTagsActivity : [ItemTagByActivity]!
        self.refInfo.child("/core/tagsactivities/").observe(.value) { (snapshot) in
            listTagsActivity = [ItemTagByActivity]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemTagAct = ItemTagByActivity(key: key, dictionary: postDictionary)
                        listTagsActivity.append(itemTagAct)
                    }
                }
            }
            self.appDelegate.listAllTagsByActivity = listTagsActivity
            print("Carga tagsactivities")
            completion(listTagsActivity)
        }
    }

    
    func getServicesLocation(completion: @escaping ([ItemServicesLocation]) -> Void){
        var listServLoc : [ItemServicesLocation]!
        self.refInfo.child("/core/serviceslocations/").queryOrdered(byChild: "s_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            listServLoc = [ItemServicesLocation]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemServLocation = ItemServicesLocation(key: key, dictionary: postDictionary)
                        listServLoc.append(itemServLocation)
                    }
                }
            }
            self.appDelegate.listAllServicesLocation = listServLoc
            print("Carga serviceslocations")
            completion(listServLoc)
        }
    }
    
    func getLegals(completion: @escaping ([ItemLegal]) -> Void){
        var listLegals : [ItemLegal]!
        self.refInfo.child("/information/legals").observe(.value) { (snapshot) in
            listLegals = [ItemLegal]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let itemFav = ItemLegal(dictionary: postDictionary)
                        listLegals.append(itemFav)
                    }
                }
            }
            self.appDelegate.listLegals = listLegals
            print("Carga legals")
            completion(listLegals)
        }
    }
    
    func getItemAlbum(code: String, uidAlbumDet: String, completion: @escaping (ItemAlbumDetail) -> Void){
        self.refPhotos.child("/photocodes/\(code)/albumsList/\(uidAlbumDet)").observe(.value) { (snapshot) in
            var itemAlbum = ItemAlbumDetail()
            if snapshot.exists(){
                if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    itemAlbum = ItemAlbumDetail(key: key, dictionary: postDictionary)
                    completion(itemAlbum)
                }
            }
        }
    }
    
    func getAlbumByUser(completion: @escaping ([ItemAlbum]) -> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        print("Album User \(uid)")
        var listAlbums : [ItemAlbum]!
        self.appDelegate.listAlbum = [ItemAlbum]()
        
        //Vamos por los albumes por usuario
        self.refPhotos.child("/photousers/\(uid)/listCodes").observe(.value) { (snapshotUserCodes) in
            listAlbums = [ItemAlbum]()
            self.appDelegate.listAlbum = [ItemAlbum]()
            if !snapshotUserCodes.exists(){
                print("No existe")
                self.appDelegate.listAlbum = listAlbums
                completion(listAlbums)
            }else{
                if let snapshotsCodes = snapshotUserCodes.children.allObjects as? [DataSnapshot]{
                    for snap in snapshotsCodes {
                        // por cada codigo, vamos a buscar los albumes
                        //Obtenemos la lista de codigos
                        let key = snap.key
                        print(key)
                        if !key.isEmpty{
                            
                            //Actualizamos la info de PhotoUser
                            PhotoBR.shared.validateCode(code: key, completion: { (isValid, albumList) in
                                print("Validacion de codigo")
                            })
                            
                            //Vamos por la info de PhotoCode
                            self.refPhotos.child("/photocodes/\(key)").observe(.value, with: { (snapshot) in
                                if snapshot.exists(){
                                    if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        print("keyCode : \(key)")
                                        let itemAlbum = ItemAlbum(key: key, dictionary: postDictionary)
                                        listAlbums.append(itemAlbum)
                                        
                                        //Si existe en nuestra lista actualizamos la informacion
                                        //Esto sucede cuando el observe se activa
                                        if self.appDelegate.listAlbum.contains(where: {$0.code == key}){
                                            listAlbums = [ItemAlbum]()
                                            for itemUp in self.appDelegate.listAlbum {
                                                if itemUp.code == key{
                                                    listAlbums.append(itemAlbum)
                                                }else{
                                                    listAlbums.append(itemUp)
                                                }
                                            }
                                        }
                                        
                                        print("\(snapshotsCodes.count) - \(listAlbums.count)")
                                        //Enviamos a la vista si ya se termino de recorrer la lista de albumes
                                        if snapshotsCodes.count == listAlbums.count{
                                            self.appDelegate.listAlbum = listAlbums
                                            completion(listAlbums)
                                        }else{
                                            self.appDelegate.listAlbum = [ItemAlbum]()
                                            //listAlbums =  [ItemAlbum]()
                                        }
                                        
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func saveInteractionPhoto(code: String, albumUID: String, listPhotos: [ItemPhoto], completion:(Bool)-> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        for itemPhoto in listPhotos {
            self.refPhotos.child("/photousers/\(uid)").child("listCodes").child("\(code)").child("savePhotos").child("\(albumUID)").child("\(itemPhoto.mediaID!)").childByAutoId().setValue(["date" : Date().string(format: "dd/MM/yyyy HH:mm:ss")])
        }
        completion(true)
    }
    
    func updateAlbumByUser(code: String, parkId: Int, completion: (Bool) -> Void){
        let listAllAlbums = appDelegate.listAlbum
        if let itemAlbum = listAllAlbums.first(where: {$0.code == code}){
            //Validamos total unlock sea menor a total puchase
            if itemAlbum.totalPurchase > itemAlbum.totalUnlock {
                if let itemDetailAlbum = itemAlbum.listAlbumesDet.first(where: {$0.parkId == parkId}){
                    //Actualizamos el numero de desbloquedos
                    let dataCountUnlock : [String: Any]! = ["totalUnlock": itemAlbum.totalUnlock + 1]
                    self.refPhotos.child("/photocodes/\(code)").updateChildValues(dataCountUnlock)
                    
                    //Actualizamos el estatus del ambum para desbloquearlo
                    let dataUnlock : [String: Any]! = ["unlock": true]
                    self.refPhotos.child("/photocodes/\(code)/").child("albumsList").child("\(itemDetailAlbum.uid!)").updateChildValues(dataUnlock)
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    func updateTotalMedia(codeAlbum : String, uidAlbumDet: String , totalmedia: Int, completion: (Bool) -> Void){
        self.refPhotos.child("/photocodes/\(codeAlbum)/albumsList/\(uidAlbumDet)").updateChildValues(["totalMedia" : totalmedia])
        completion(true)
    }
    
    func updatePhotoAlbum(itemAlbum: ItemAlbum, listAllAlbumFB: ItemAlbum, completion: (Bool) -> Void){
        var countDet: Int = 0
        //Actualizamos el total de desbloqueados
        let updateInfo : [String : Any] = [
            "totalUnlock" : itemAlbum.totalUnlock!,
            "visitDate" : itemAlbum.visitDate!,
            "expiresDate" : itemAlbum.expiresDate!,
        ]
        self.refPhotos.child("/photocodes/\(itemAlbum.code!)").updateChildValues(updateInfo)
        
        //2. Recorremos el arreglo que nos devuelve photos
        for detAlbum in itemAlbum.listAlbumesDet {
            if let detItemPhoto = listAllAlbumFB.listAlbumesDet.first(where: {$0.parkId == detAlbum.parkId}){
                //Actualizamos valores de FB
                print("Actualiza \(detItemPhoto.uid ?? "X") - \(detItemPhoto.parkId ?? 0) ")
                let objDetail : [String: Any] = [
                    "visitDate" : detAlbum.visitDate!,
                    "totalMedia" : detAlbum.totalMedia!,
                    "unlock" : detAlbum.unlock!
                ]
                self.refPhotos.child("/photocodes/\(itemAlbum.code!)/albumsList").child(detItemPhoto.uid).updateChildValues(objDetail)
            }else{
                //Añadimos album faltante
                print("Añadimos nuevo \(detAlbum.parkId ?? 0)")
                let objDetail : [String: Any] = [
                    "parkID" : detAlbum.parkId!,
                    "visitDate" : detAlbum.visitDate!,
                    "totalMedia" : detAlbum.totalMedia!,
                    "unlock" : detAlbum.unlock!
                ]
                self.refPhotos.child("/photocodes/\(itemAlbum.code!)/albumsList").childByAutoId().setValue(objDetail)
            }
            countDet+=1
            
            if countDet == itemAlbum.listAlbumesDet.count {
                completion(true)
            }
        }
    }
    
    func updateStatusAlbum(itemAlbum: ItemAlbum, completion: (Bool) -> Void){
        //Actualizamos el dato del estatus del album
        self.refPhotos.child("/photocodes/\(itemAlbum.code!)").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                self.refPhotos.child("/photocodes/\(itemAlbum.code!)").updateChildValues(["isValid" : itemAlbum.isValid!])
            }
        }
        completion(true)
    }
    
    func saveAlbumByUser(itemAlbum: ItemAlbum, completion: (Bool) -> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        //Si existe el album solo actualizamos totalUnlock que viene de getSelectedParks
        //De lo contrario guardamos el album completito
        self.refPhotos.child("/photocodes/\(itemAlbum.code!)").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                //Actualizamos el total de desbloqueados
                self.refPhotos.child("/photocodes/\(itemAlbum.code!)").updateChildValues(["totalUnlock" : itemAlbum.totalUnlock!])
                
                //Verificar que este actualizada la lista de albumes FB VS Photos
                //Vamos por el detalle que existe en Firebase
                if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let itemAlbumFB = ItemAlbum(dictionary: postDictionary)
                    //1.Obtenemos el detalle de albumes de FB
                    let listAllAlbumFB = itemAlbumFB.listAlbumesDet
                    //2. Recorremos el arreglo que nos devuelve photos
                    for detAlbum in itemAlbum.listAlbumesDet{
                        if let detItemPhoto = listAllAlbumFB!.first(where: {$0.parkId == detAlbum.parkId}){
                            //Actualizamos valores de FB
                            print("Actualiza \(detItemPhoto.uid ?? "X") - \(detItemPhoto.parkId ?? 0) ")
                            let objDetail : [String: Any] = [
                                "visitDate" : detAlbum.visitDate!,
                                "totalMedia" : detAlbum.totalMedia!,
                                "unlock" : detAlbum.unlock!
                            ]
                            self.refPhotos.child("/photocodes/\(itemAlbum.code!)/albumsList").child(detItemPhoto.uid).updateChildValues(objDetail)
                        }else{
                            //Añadimos album faltante
                            print("Añadimos nuevo \(detAlbum.parkId ?? 0)")
                            let objDetail : [String: Any] = [
                                "parkID" : detAlbum.parkId!,
                                "visitDate" : detAlbum.visitDate!,
                                "totalMedia" : detAlbum.totalMedia!,
                                "unlock" : detAlbum.unlock!
                            ]
                            self.refPhotos.child("/photocodes/\(itemAlbum.code!)/albumsList").childByAutoId().setValue(objDetail)
                        }
                    }
                }
            }else{
                let dataAlbum : [String: Any]! = [
                    "code" : itemAlbum.code!,
                    "book" : itemAlbum.isBook,
                    "visitDate" : itemAlbum.visitDate!,
                    "expiresDate" : itemAlbum.expiresDate!,
                    "dateRegister" : Date().string(format: "dd/MM/yyyy HH:mm"),
                    "totalPurchase" : itemAlbum.totalPurchase!,
                    "totalUnlock" : itemAlbum.totalUnlock!,
                    "isValid" : itemAlbum.isValid!,
                    "albumsList" : []
                ]
                //Guardamos el parent
                self.refPhotos.child("/photocodes").child(itemAlbum.code).setValue(dataAlbum)
                //Guardamos los hijitos
                for item in itemAlbum.listAlbumesDet {
                    let objDetail : [String: Any] = [
                        "parkID" : item.parkId!,
                        "visitDate" : item.visitDate!,
                        "totalMedia" : item.totalMedia!,
                        "unlock" : item.unlock!
                    ]
                    self.refPhotos.child("/photocodes/\(itemAlbum.code!)/albumsList").childByAutoId().setValue(objDetail)
                }
            }
        }

        //Guardamos el usuario
        self.refPhotos.child("/photousers/\(uid)/listCodes").child("\(itemAlbum.code!)").setValue(["dateRegister" : Date().string(format: "dd/MM/yyyy HH:mm")])
        
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.Photo.rawValue, title: TagsPhoto.saveAlbum.rawValue)
        completion(true)
    }
    
    func getFavorites(completion: @escaping ([ItemFavorite]) -> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var listFavorites : [ItemFavorite] = [ItemFavorite]()
        self.refInfo.child("/core/favorites/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemFav = ItemFavorite(uid: key, dictionary: postDictionary)
                        listFavorites.append(itemFav)
                    }
                }
            }
            completion(listFavorites)
        })
    }
    
    func getFavoritesByPark(codePark: String, completion: @escaping ([ItemFavorite]) -> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var listFavorites : [ItemFavorite] = [ItemFavorite]()
        self.refInfo.child("/core/favorites/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            //self.ref.child("\(getEnviroment())/core/favorites/\(uid)").queryOrdered(byChild: "key_park").queryEqual(toValue: codePark).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemFav = ItemFavorite(uid: key, dictionary: postDictionary)
                        //Si es del mismo parque lo añadimos
                        if itemFav.f_keyPark == codePark{
                            listFavorites.append(itemFav)
                        }
                    }
                }
            }
            completion(listFavorites)
        })
    }
    
    func saveFavorite(fav: String, name: String, completion: @escaping (Bool) -> Void) {
        let uid = AppUserDefaults.value(forKey: .UserUID)
        self.refInfo.child("/core/favorites/\(uid)").child(fav).setValue(["date_registered" : Date().string(format: "dd/MM/yyyy HH:mm"), "key_park" : appDelegate.itemParkSelected.uid])
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.AddFavorite.rawValue, title: name)
        completion(true)
    }
    
    func removeFavorite(fav: String, name: String,completion: @escaping (Bool) -> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID)
        self.refInfo.child("/core/favorites/\(uid)/\(fav)").removeValue()
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.DeleteFavorite.rawValue, title: name)
        completion(true)
    }
    
    func getUrlImageUser() -> String {
        let user = Auth.auth().currentUser
        var urlImage = ""
            if let user = user {
                if !((user.isAnonymous)) {
                    if user.providerData.count > 0{
                        if let photoProfile = user.providerData[0].photoURL?.absoluteString{
                            if photoProfile.contains("facebook"){
                                urlImage = photoProfile + "?type=large"
                            }else{
                                urlImage = photoProfile
                            }
                        }
                    }
                }
            }
        
        return urlImage
    }
    
    func getMaps(completion: @escaping () -> Void){
        self.refInfo.child("/core/mapsconfig/IOS/").observe(.value) { (snapshot) in
            var listMaps = [ItemMapInfo]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemMap = ItemMapInfo(key: key, dictionary: postDictionary)
                        listMaps.append(itemMap)
                    }
                }
            }
            self.appDelegate.listAllMaps = listMaps
            completion()
        }
    }
    
    func getInfoContact(completion: @escaping () -> Void){
        self.refInfo.child("/information/contactconfig").observe(.value) { (snapshot) in
            var itemContact = ItemContact()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        itemContact = ItemContact(key: key, dictionary: postDictionary)
                    }
                }
            }
            self.appDelegate.itemContact = itemContact
            completion()
        }
    }
    
//    func getCupons(completion: @escaping () -> Void){
//        self.refInfo.child("/core/cuponConfiguration/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
//            var listCupons = [ItemCupon]()
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshots {
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let itemCupon = ItemCupon(key: key, dictionary: postDictionary)
//                        listCupons.append(itemCupon)
//                    }
//                }
//            }
//            self.appDelegate.listCupons = listCupons
//            completion()
//        }
//    }
    
    func getPictures(completion: @escaping ()-> Void){
        self.refInfo.child("/core/pictures/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            var listPictures = [ItemPicture]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemPicture = ItemPicture(key: key, dictionary: postDictionary)
                        listPictures.append(itemPicture)
                    }
                }
            }
            self.appDelegate.listPictures = listPictures
            completion()
        }
    }
    
    func getGalleries(completion: @escaping ()-> Void){
        self.refInfo.child("/core/picturesgallery/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            var listGallery = [ItemGallery]()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemGallery = ItemGallery(key: key, dictionary: postDictionary)
                        listGallery.append(itemGallery)
                    }
                }
            }
            self.appDelegate.listGallery = listGallery
            completion()
        }
    }
    
    func getBookingConfig(completion: @escaping ()-> Void){
        self.refInfo.child("/clasificators/param_settings/").observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var param_settings : [String: Any] = [String: Any]()
                for snap in snapshots {
                    let item: [String: Any] = [
                        snap.key: snap.value as Any
                    ]
                    param_settings.add(item)
                }
                let itemBooking = ItemBookingConfig(dictionary: param_settings)
                self.appDelegate.bookingConfig = itemBooking
                completion()
            }
        }
    }
    
    func saveTicket(cupon: String, completion:(Bool)-> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        let data: [String: Any]! = ["barCode" : cupon, "platform" : "iOS", "version" : Tools.shared.version() ?? "6.0.0"]
        self.refTickets.child("/tickets/\(uid)").childByAutoId().setValue(data)
        completion(true)
    }
    
    func saveTicketList(listTickets: [ItemTicket], completion:([ItemTicket])-> Void){
        var listTicketsResult : [ItemTicket] = [ItemTicket]()
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var arrayProducts : [[String : Any]] =  [[String : Any]]()
        var arrayComponents : [[String : Any]] =  [[String : Any]]()
        var itemPromotion : [String: Any] = [String: Any]()
        
        var countProd = 0
        var countComp = 0
        //Llenamos la lista de tickets
        for ticket in listTickets {
            arrayProducts =  [[String : Any]]()
            countComp = 1
            countProd = 1
            
            //Armar los productos
            for itemProd in ticket.listProducts {
                arrayComponents = [[String : Any]]()
                itemPromotion = [String: Any]()
                
                var orderProduct = 0
                //Armamos los componentes
//                let aux = itemProd
                /*for itemComponent in itemProd.listComponents {
                    let itemPromoComponent : [String : Any]! = [
                        "dsCodigoPromocion": itemComponent.itemPromotion.dsCodigoPromocion!,
                        "dsNombrePromocion": itemComponent.itemPromotion.dsNombrePromocion!,
                        "dsURLImagenCupon": itemComponent.itemPromotion.dsURLImagenCupon!

                    ]
                    
                    let itemAddComponent : [String: Any]! = [
                        "visitDate" : "\(itemComponent.visitDate ?? "")",
                        "dueDate" : "\(itemComponent.dueDate ?? "")",
                        "feOperacion" : "\(itemComponent.feOperacion ?? "")",
                        "productCode" : "\(itemComponent.productCode ?? "")",
                        "productName" : "\(itemComponent.productName ?? "")",
                        "hasPickup" : itemComponent.hasPickup ?? false,
                        "hasAYB" : itemComponent.hasAYB ?? false,
                        "hasPhotopass" : itemComponent.hasPhotopass ?? false,
                        "timePickup" : "\(itemComponent.timePickup ?? "")",
                        "locationPickup" : "\(itemComponent.locationPickup ?? "")",
                        "un" : "\(itemComponent.un ?? "")",
                        "familyProducto" : "\(itemComponent.familyProducto ?? "")",
                        "promotion" : itemPromoComponent as Any
                    ]
                    arrayComponents.append(itemAddComponent)
                    countComp += 1
                }*/
                
                if itemProd.promocion != nil {
                    itemPromotion = [
                        "dsCodigoPromocion": itemProd.promocion.dsCodigoPromocion!,
                        "dsNombrePromocion": itemProd.promocion.dsNombrePromocion!,
                        "dsURLImagenCupon": itemProd.promocion.dsURLImagenCupon!
                    ]
                }
                
                switch itemProd.familyProducto.lowercased() {
                case "fotos":
                    orderProduct = 5
                case "entradas":
                    orderProduct = 1
                case "tours" :
                    orderProduct = 2
                case "actividades":
                    orderProduct = 3
                default:
                    orderProduct = 4
                }
                
                //Armamos el producto
                let itemAddProd : [String : Any]! = [
                    "adults" : itemProd.adults,
                    "childrens" : itemProd.childrens,
                    "infants" : itemProd.infants,
                    "visitDate" : "\(itemProd.visitDate ?? "")",
                    "dueDate" : "\(itemProd.dueDate ?? "")",
                    "feOperacion" : "\(itemProd.feOperacion ?? "")",
                    "paxes" : "\(itemProd.paxes ?? "")",
                    "productCode" : "\(itemProd.productCode ?? "")",
                    "productName" : "\(itemProd.productName ?? "")",
                    "hasPickup" : itemProd.hasPickup ?? false,
                    "hasAYB" : itemProd.hasAYB ?? false,
                    "hasPhotopass" : itemProd.hasPhotopass ?? false,
                    "timePickup" : "\(itemProd.timePickup ?? "")",
                    "locationPickup" : "\(itemProd.locationPickup ?? "")",
                    "un" : "\(itemProd.un ?? "")",
                    "order" : orderProduct,
                    "familyProducto" : "\(itemProd.familyProducto ?? "")",
                    //"components" : arrayComponents,
                    "promotion" : itemPromotion
                ]
                arrayProducts.append(itemAddProd)
                countProd += 1
            }
            
            //Armar el ticket
            let ticketSave : [String : Any]! = [
                "bookingReference" : "\(ticket.bookingReference ?? "")",
                "barCode" : "\(ticket.barCode ?? "")",
                "status" : "\(ticket.status ?? "")",
                "enabled" : ticket.enabled ?? 1,
                "purchaseDate" : "\(ticket.purchaseDate ?? "")",
                "registerDate" : "\(ticket.registerDate ?? "")",
                "dueDate" : "\(ticket.dueDate ?? "")",
                "totalAmount" : "\(ticket.totalAmount ?? "")",
                "discount" : "\(ticket.discount ?? "")",
                "currency" : "\(ticket.currency ?? "")",
                //"platform" : "\(ticket.platform ?? "")",
                //"version" : "\(ticket.version ?? "")",
                "contactName" : "\(ticket.contactName ?? "")",
                "contactEmail" : "\(ticket.contactEmail ?? "")",
                "salesChannel" : "\(ticket.salesChannel ?? "")",
                "idCanalVenta" : "\(ticket.idCanalVenta ?? "")",
                "products" : arrayProducts
            ]
            
            if ticket.uid != "" {
                self.refTickets.child("/tickets/\(uid)/\(ticket.uid)").updateChildValues(ticketSave)
            }else{
                let ticketReSave = appDelegate.listTickets.filter({$0.barCode == ticket.barCode})
                if ticketReSave.count == 0 {
                    self.refTickets.child("/tickets/\(uid)").childByAutoId().setValue(ticketSave)
                }
            }
            
            listTicketsResult.append(ticket)
        }
        
        /*listTicketsResult = listTicketsResult.sorted(by: { (item0, item1) -> Bool in
            return item0.visitDate > item1.visitDate
        })*/
        completion(listTicketsResult)
    }
    
    
    
    func getTicketsList(completion:@escaping ([ItemTicket])-> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var listTickets : [ItemTicket] = [ItemTicket]()
        //self.refTickets.child("/tickets/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
        handleTicket = self.refTickets.child("/tickets/\(uid)").observe(.value) { (snapshot) in
        //self.refTickets.removeObserver(withHandle: self.handleTicket!)
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemTicket = ItemTicket(key: key, dictionary: postDictionary)
                        print("key: \(key) - \(itemTicket.barCode!)")
                        if !itemTicket.barCode.isEmpty{
                            listTickets.append(itemTicket)
                        }
                    }
                }
            }
            self.appDelegate.listTickets = listTickets
            completion(self.appDelegate.listTickets)
        }
    }
    
    func getListCountries(completion:@escaping ([Country]) -> Void){
        var listCountries : [Country] = [Country]()
        self.refInfo.child("/clasificators/country/").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let country = Country(key: key, dictionary: postDictionary)
                        listCountries.append(country)
                    }
                }
            }
            completion(listCountries)
        }
    }
    
    func getAdmissionsActivities(completion:@escaping () -> Void){
        var listAdmissionActivities : [ItemAdmissionActivities]!
        self.refInfo.child("/core/admissionactivities/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listAdmissionActivities = [ItemAdmissionActivities]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let admission = ItemAdmissionActivities(key: key, dictionary: postDictionary)
                        listAdmissionActivities.append(admission)
                    }
                }
            }
            self.appDelegate.listAdmissionsActivities = listAdmissionActivities
            completion()
        }
    }
    
    func getAdmission(completion:@escaping () -> Void){
        
        var listAdmission : [ItemAdmission]!
        self.refInfo.child("/core/admissions/").queryOrdered(byChild: "ad_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            self.appDelegate.listAdmissions.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listAdmission = [ItemAdmission]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let admission = ItemAdmission(key: key, dictionary: postDictionary)
                        listAdmission.append(admission)
                    }
                }
            }
            self.appDelegate.listAdmissions = listAdmission
            completion()
        }
    }
    
    func getProductoAyB(completion:@escaping () -> Void){
        
        var listCodes = [ItemProductAyB]()
        self.refInfo.child("/core/ayb/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            self.appDelegate.listCodeAyB.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listCodes = [ItemProductAyB]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let codeAyB = ItemProductAyB(key: key, dictionary: postDictionary)
                        listCodes.append(codeAyB)
                    }
                }
            }
            self.appDelegate.listCodeAyB = listCodes
            completion()
        }
    }
    
    func getEvents(completion:@escaping () -> Void){
        
        var listEvents: [ItemEvents]!
        self.refInfo.child("/core/events/").queryOrdered(byChild: "ev_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            self.appDelegate.listEvents.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listEvents = [ItemEvents]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemEvents(key: key, dictionary: postDictionary)
                        listEvents.append(events)
                    }
                }
            }
            self.appDelegate.listEvents = listEvents
            completion()
        }
    }
    
//    func getStaticDataByPark(codePark: String, completion: @escaping ([ItemXOStaticData]) -> Void){
//        self.appDelegate.listXOStaticData.removeAll()
//        self.appDelegate.listXNStaticdata.removeAll()
//        self.appDelegate.listXIStaticdata.removeAll()
//        var listXOStaticData : [ItemXOStaticData] = [ItemXOStaticData]()
//        var listXNStaticData : [ItemXNStaticData] = [ItemXNStaticData]()
//        var listXIStaticData : [ItemXNStaticData] = [ItemXNStaticData]()
//        if codePark == "XO"{
//            if let path = Bundle.main.path(forResource: codePark, ofType: "json") {
//                do {
//                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                    let jsonObj = try JSON(data: data)
//                    let itemskermes = jsonObj.arrayValue
//                    for itemKermes in itemskermes {
//                        let listXOData = ItemXOStaticData(Json: itemKermes)
//                        listXOStaticData.append(listXOData)
//                    }
//                    self.appDelegate.listXOStaticData = listXOStaticData
//                } catch let error {
//                    print("parse error: \(error.localizedDescription)")
//                }
//            } else {
//                print("Invalid filename/path.")
//            }
//        }else if codePark == "XN"{
//            if let path = Bundle.main.path(forResource: codePark, ofType: "json") {
//                do {
//                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                    let jsonObj = try JSON(data: data)
//                    let itemsXenotes = jsonObj.arrayValue
//                    for itemXenotes in itemsXenotes {
//                        let listXNData = ItemXNStaticData(Json: itemXenotes)
//                        listXNStaticData.append(listXNData)
//                    }
//                    self.appDelegate.listXNStaticdata = listXNStaticData
//                } catch let error {
//                    print("parse error: \(error.localizedDescription)")
//                }
//            } else {
//                print("Invalid filename/path.")
//            }
//        }else if codePark == "XI"{
//            if let path = Bundle.main.path(forResource: codePark, ofType: "json") {
//                do {
//                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                    let jsonObj = try JSON(data: data)
//                    let itemsXichen = jsonObj.arrayValue
//                    for itemXichen in itemsXichen {
//                        let listXIData = ItemXNStaticData(Json: itemXichen)
//                        listXIStaticData.append(listXIData)
//                    }
//                    self.appDelegate.listXIStaticdata = listXIStaticData
//                } catch let error {
//                    print("parse error: \(error.localizedDescription)")
//                }
//            } else {
//                print("Invalid filename/path.")
//            }
//        }
//        
//        completion(listXOStaticData)
//    }
    
    func getcontentPrograms(completion:@escaping () -> Void){
        
        var listContentPrograms: [ItemContentPrograms]!
        //        self.refInfo.child("/core/contentPrograms/").queryOrdered(byChild: "cont_status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
        self.refInfo.child("/core/contentPrograms/").observeSingleEvent(of: .value) { (snapshot) in
            self.appDelegate.listContentPrograms.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listContentPrograms = [ItemContentPrograms]()
                for snap in snapshots {
                    for snapIn in snap.children.allObjects {
                        let snap = snapIn as! DataSnapshot
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let events = ItemContentPrograms(key: key, dictionary: postDictionary)
                            listContentPrograms.append(events)
                        }
                    }
                }
            }
            self.appDelegate.listContentPrograms = listContentPrograms
            completion()
        }
    }
    
    func getPrograms(completion:@escaping () -> Void){
        
        var itemContentPrograms: contentPrograms!
        self.refInfo.child("/core/programs/").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                print(snapshots)
                for snap in snapshots {
                    print(snap.key)
                    print(snap.value!)
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        itemContentPrograms = contentPrograms(key: key, dictionary: postDictionary)
                    }
                }
            }
            self.appDelegate.contentPrograms = itemContentPrograms
            completion()
        }
    }
    
    func getDestinations(completion:@escaping () -> Void){
        var listDestByAdmission: [ItemDestination]!
        self.refInfo.child("/core/destinations/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listDestByAdmission = [ItemDestination]()
                for snap in snapshots {
                    print(snap.key)
                    print(snap.value!)
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let itemDestByAdmission = ItemDestination(key: key, dictionary: postDictionary)
                        listDestByAdmission.append(itemDestByAdmission)
                    }
                }
            }
            self.appDelegate.listDestByAdmission = listDestByAdmission
            completion()
        }
    }
    
    
    
    
    func getListLang(completion : @escaping ([language]) -> Void){
        
        var listLanguage: [language]!
        print(Constants.LANG.current)
        self.refInfo.child("/i18n/lang/").queryOrdered(byChild: "lang_status").queryEqual(toValue: true).observe(.value) { (snapshot) in
            self.appDelegate.listLanguages.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listLanguage = [language]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = language(key: key, dictionary: postDictionary)
                        listLanguage.append(events)
                    }
                }
            }
            self.appDelegate.listLanguages = listLanguage
            completion(listLanguage)
        }
        
    }
    
    func getLangLabelEN(completion: @escaping ([langLabel]) -> Void){
        
        var listlangLabel: [langLabel]!
        self.refInfo.child("/i18n/en/LangLabel").observe(.value) { (snapshot) in
            self.appDelegate.listDataLangLabel = self.appDelegate.listDataLangLabel.filter({ $0.uid == "es" })
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangLabel = [langLabel]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "en"
                        let events = langLabel(key: key, dictionary: postDictionary)
                        listlangLabel.append(events)
                    }
                }
            }
            
            self.appDelegate.listDataLangLabel.append(contentsOf: listlangLabel)
            completion(listlangLabel)
        }
        
    }
    
    
    func getLangLabelES(completion: @escaping ([langLabel]) -> Void){
        
        var listlangLabel: [langLabel]!
        
        print(Constants.LANG.current)
//        let langInit: String = Constants.LANG.current
        self.refInfo.child("/i18n/es/LangLabel").observe(.value) { (snapshot) in
            self.appDelegate.listDataLangLabel.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangLabel = [langLabel]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "es"
                        let events = langLabel(key: key, dictionary: postDictionary)
                        listlangLabel.append(events)
                    }
                }
            }
            self.appDelegate.listDataLangLabel.append(contentsOf: listlangLabel)
            completion(listlangLabel)
        }
    }
    
    func getLangProduct(completion: @escaping ([langProduct]) -> Void){
        
        var listlangProduct: [langProduct]!
        
        print(Constants.LANG.current)
        
        self.refInfo.child("/i18n/es/LangProduct").observe(.value) { (snapshot) in
            self.appDelegate.listDatalangProduct.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangProduct = [langProduct]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "es"
                        let events = langProduct(key: key, dictionary: postDictionary)
                        listlangProduct.append(events)
                    }
                }
            }

            self.appDelegate.listDatalangProduct.append(contentsOf: listlangProduct)
            completion(listlangProduct)
        }
        
    }
    
    func getLangProductEN(completion: @escaping ([langProduct]) -> Void){

        var listlangProduct: [langProduct]!

        print(Constants.LANG.current)
//        let langInit: String = Constants.LANG.current
        self.refInfo.child("/i18n/en/LangProduct").observe(.value) { (snapshot) in
            self.appDelegate.listDatalangProduct = self.appDelegate.listDatalangProduct.filter({ $0.uid == "es"})
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangProduct = [langProduct]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "en"
                        let events = langProduct(key: key, dictionary: postDictionary)
                        listlangProduct.append(events)
                    }
                }
            }

            self.appDelegate.listDatalangProduct.append(contentsOf: listlangProduct)
            completion(listlangProduct)
        }
    }
    
    
    
    
//    func getListPrecios(completion : @escaping ([ItemPrecios]) -> Void){
//
//        var listPrecios: [ItemPrecios]!
//        self.refInfo.child("/promociones/precios/").observe(.value) { (snapshot) in
//            self.appDelegate.listPrecios.removeAll()
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                listPrecios = [ItemPrecios]()
//                for snap in snapshots {
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let events = ItemPrecios(key: key, dictionary: postDictionary)
//                        listPrecios.append(events)
//                    }
//                }
//            }
//            self.appDelegate.listPrecios = listPrecios
//            completion(listPrecios)
//        }
//    }
    
    
    
    func getListPreciosXapiX(completion : @escaping ([ItemPrecios]) -> Void){

        var listPrecios: [ItemPrecios] = [ItemPrecios]()
        var itemProdProm : [ItemProdProm]!
        
        let itemProdRegular  = [
            "uid" : "",
            "code" : "Regular",
            "coupon" : "",
            "order" : 0,
            "topPreference" : 1,
            ] as Dictionary<String, AnyObject>
        
        let listPromotions = ItemPromotions(key: "", dictionary: itemProdRegular)
        appDelegate.listPromotions.append(listPromotions)
        
        
        let auxListProductPrices = self.appDelegate.listProductPrices
        
        
        let auxprom = appDelegate.listPromotions
//        let aux2 = appDelegate.listCurrencies
        var listProductsPromotions = [ItemProductsPromotions]()
        
        let aux = appDelegate.listProductsPromotions
        let aux2 = appDelegate.listPrecios
        
        for itemlistPromotions in appDelegate.listPromotions {
            if itemlistPromotions.code == "Regular" {
                listProductsPromotions = appDelegate.listProductsPromotions.filter({ $0.status == 1 && $0.key_promotion == ""})
            }else{
                listProductsPromotions = appDelegate.listProductsPromotions.filter({ $0.status == 1 && $0.key_promotion == itemlistPromotions.uid})
            }
            
            itemProdProm = [ItemProdProm]()
            for itemlistProductsPromotions in listProductsPromotions {
                let product = appDelegate.listProducts.filter({$0.uid == itemlistProductsPromotions.key_product}).first
                let langProdES = appDelegate.listDatalangProduct.filter({ $0.key_product == itemlistProductsPromotions.key_product && $0.uid == "es"}).first
                let langProdEN = appDelegate.listDatalangProduct.filter({ $0.key_product == itemlistProductsPromotions.key_product && $0.uid == "es"}).first//appDelegate.listDatalangProduct.filter({ $0.key_product == itemlistProductsPromotions.key_product && $0.uid == "en"}).first
                let auxappDelegatelistProductPrices = appDelegate.listProductPrices
                
                let productPrice = appDelegate.listProductPrices.filter({$0.key_product == itemlistProductsPromotions.key_product && $0.key_promotion == itemlistProductsPromotions.key_promotion })
                let productPriceAdulto = productPrice.filter({$0.paxType == "adulto"})
//                let productPriceMenor = productPrice.filter({$0.paxType == "menor"})
                let currencyES = appDelegate.listCurrencies.filter({ $0.currency == Constants.CURR.current}).first
//                let currencyEN = appDelegate.listCurrencies.filter({ $0.currency == "USD"}).first
                let priceESAdulto = productPriceAdulto.filter({ $0.key_currency == currencyES?.uid}).first
//                let priceENAdulto = productPriceAdulto.filter({ $0.key_currency == currencyEN?.uid}).first
//                let priceESMenor = productPriceMenor.filter({ $0.key_currency == currencyES?.uid}).first
//                let priceENMenor = productPriceMenor.filter({ $0.key_currency == currencyEN?.uid}).first
                
                var product_childs : [[String : Any]] =  [[String : Any]]()
                for prdChil in itemlistProductsPromotions.product_childs{
                    let itemPrdChil : [String : Any]! = [
                        "key" : prdChil.key,
                        "value" : prdChil.value
                    ]
                    product_childs.append(itemPrdChil)
                }
                
                let itemProdPromDictionary  = [
                    "uid" : itemlistProductsPromotions.uid,
                    "code_landing" : product?.code_landing as Any,
                    "code_park" : product?.code_park as Any,
                    "code_product" : product?.code_product as Any,
                    "code_promotion" : itemlistPromotions.code,
                    "cupon_promotion" : itemlistPromotions.coupon,
                    "packageId" : itemlistProductsPromotions.packageId,
                    "descripcionDe" : "",
                    "descripcionEn" : langProdEN?.description as Any,
                    "descripcionEs" : langProdES?.description as Any,
                    "descripcionFr" : "",
                    "descripcionIt" : "",
                    "descripcionPt" : "",
                    "descripcionRu" : "",
                    "distintivo" : product?.distintivo as Any,
                    "extra_day" : product?.D as Any,
                    "food" : product?.C as Any,
                    "id_product" : product?.id_product as Any,
                    "key_park" : product?.uid_park as Any,
                    "photopass" : product?.P as Any,
                    "product_order" : product?.order as Any,
                    "status_product" : product?.status_product as Any,
                    "transportation" : product?.T as Any,
                    "type_prod" : product?.type_prod as Any,
                    "unidadNegocio" : "",
                    "product_childs" : product_childs,
                    "adulto" : [
                    Constants.CURR.current : [
                        "ahorro" : priceESAdulto?.saving,
                        "descuentoPrecompra" : priceESAdulto?.preBuyDiscount,
                        "precio" : priceESAdulto?.price,
                        "precioDescuento" : priceESAdulto?.priceDiscount,
                        "tipoCambio" : priceESAdulto?.currencyChange
                    ]
                  ]
                    ] as Dictionary<String, AnyObject>
                if product?.code_product != "" && product?.code_product != nil {
                    itemProdProm.append(ItemProdProm.init(key: (product?.code_product)!, dictionary: itemProdPromDictionary))
                }
//                print(product as Any)
            }
            let listPreciosItem = ItemPrecios()
            listPreciosItem.uid = itemlistPromotions.code
            listPreciosItem.productos = itemProdProm
            listPrecios.append(listPreciosItem)
        }
        
        
        if appDelegate.getDataXapi {
            appDelegate.listPrecios.removeAll()
            appDelegate.listPrecios = listPrecios
        }
        
        completion(listPrecios)
    }
    
    func getListPreciosXapi(completion : @escaping ([ItemPrecios]) -> Void){
        
        var listPrecios: [ItemPrecios] = [ItemPrecios]()
        var itemProdProm : [ItemProdProm]!
        
        let itemProdRegular  = [
            "uid" : "",
            "code" : "Regular",
            "coupon" : "",
            "order" : 0,
            "status" : 1,
            "topPreference" : 1,
            ] as Dictionary<String, AnyObject>
        
        let listPromotions = ItemPromotions(key: "", dictionary: itemProdRegular)
        appDelegate.listPromotions.append(listPromotions)
        
        let productsPromotions = appDelegate.listProductsPromotions//.filter({ $0.status == 1})
//        let productsPromotionsaux = appDelegate.listProductsPromotions.filter({ $0.status == 0})
//        var productChilds = [ItemProductsPromotions]()
        
        for itemlistPromotions in appDelegate.listPromotions {
            itemProdProm = [ItemProdProm]()
            print(itemlistPromotions.code, itemlistPromotions.coupon, itemlistPromotions.defaultImage)
            var products = [ItemProductPrices]()
            if itemlistPromotions.code == "Regular" {
                products = self.appDelegate.listProductPrices.filter({ $0.key_promotion == "" })
            }
            else{
                products = self.appDelegate.listProductPrices.filter({ $0.key_promotion == itemlistPromotions.uid })
            }
            
            for itemProducts in products {
//                let itemProdStatus = productsPromotions.filter({ $0.key_product == itemProducts.key_product })
//                if itemProdStatus.count > 0 {
                    var infoBasic = [ItemProducts]()
                    if itemlistPromotions.code == "Regular" {
                        infoBasic = self.appDelegate.listProducts.filter({ $0.uid == itemProducts.key_product && $0.base_product == 1 })
                    }else{
                        infoBasic = self.appDelegate.listProducts.filter({ $0.uid == itemProducts.key_product })//&& $0.base_product == 0 })
                    }
                    
                    let infoPark = self.appDelegate.listAllParksEnabled.filter({ $0.uid == infoBasic.first?.uid_park }).first
                    let infoLang = self.appDelegate.listDatalangProduct.filter({ $0.key_product == infoBasic.first?.uid })// && $0.uid == Constants.LANG.current.lowercased() })
                    let infoBasicFirts = infoBasic.first
                    
                var productChilds = productsPromotions.filter({ $0.key_product == itemProducts.key_product && $0.key_promotion == itemProducts.key_promotion})
                
                    var product_childs : [[String : Any]] =  [[String : Any]]()
                    var itemProdPromDictionaryUID = ""
                    var itemProdPromDictionaryPackageId = 0
                    itemProdPromDictionaryUID = productChilds.first?.uid ?? ""
                    itemProdPromDictionaryPackageId = productChilds.first?.packageId ?? 0
                    if productChilds.first?.product_childs.count ?? 0 > 0 {
                        for prdChil in productChilds.first!.product_childs{
                            let itemPrdChil : [String : Any]! = [
                                "key" : prdChil.key,
                                "value" : prdChil.value
                            ]
                            product_childs.append(itemPrdChil)
                        }
                    }
                    
                    let itemProdPromDictionary = [
                        "uid" : itemProdPromDictionaryUID as Any,//"",//itemlistProductsPromotions.uid,
                        "code_landing" : infoBasicFirts?.code_landing as Any,//"",//product?.code_landing as Any,
                        "code_park" : infoBasicFirts?.code_park as Any,
                        "code_product" : infoBasicFirts?.code_product as Any,
                        "code_promotion" : itemlistPromotions.code,
                        "cupon_promotion" : itemlistPromotions.coupon,
                        "packageId" : itemProdPromDictionaryPackageId,
                        "descripcionDe" : "",
                        "descripcionEn" : infoLang.first?.description as Any,
                        "descripcionEs" : infoLang.first?.description as Any,
                        "descripcionFr" : "",
                        "descripcionIt" : "",
                        "descripcionPt" : "",
                        "descripcionRu" : "",
                        "distintivo" : infoBasicFirts?.distintivo as Any,
                        "extra_day" : infoBasicFirts?.D as Any,
                        "food" : infoBasicFirts?.C as Any,
                        "id_product" : infoBasicFirts?.id_product as Any,
                        "key_park" : infoBasicFirts?.uid_park as Any,
                        "photopass" : infoBasicFirts?.P as Any,
                        "product_order" : infoPark?.order as Any,//infoBasicFirts?.order as Any,
                        "status_product" : infoBasicFirts?.status_product as Any,
                        "transportation" : infoBasicFirts?.T as Any,
                        "type_prod" : infoBasicFirts?.type_prod as Any,
                        "unidadNegocio" : "",
                        "product_childs" : product_childs,
                        "adulto" : [
                            Constants.CURR.current : [
                                "ahorro" : itemProducts.saving,
                                "descuentoPrecompra" : itemProducts.preBuyDiscount,
                                "precio" : itemProducts.price,
                                "precioDescuento" : itemProducts.priceDiscount,
                                "tipoCambio" : itemProducts.currencyChange
                            ]
                        ]
                    ] as Dictionary<String, AnyObject>
                

                
                if infoBasicFirts?.code_product != "" && infoBasicFirts?.code_product != nil && infoBasicFirts?.uid_park != "-MdJo9jKOH6uTUVnCBSW" && productChilds.first?.status != 0 {
                        itemProdProm.append(ItemProdProm.init(key: (infoBasicFirts?.code_product)!, dictionary: itemProdPromDictionary))
                    }
//                }
            }
            let listPreciosItem = ItemPrecios()
            listPreciosItem.uid = itemlistPromotions.code
            listPreciosItem.productos = itemProdProm
            listPrecios.append(listPreciosItem)
            print(listPreciosItem)
        }
        
//        if appDelegate.getDataXapi
            appDelegate.listPrecios.removeAll()
            appDelegate.listPrecios = listPrecios
        
        
        completion(listPrecios)
    }
    
    
    
    func getListLangsPromotionsEN(completion : @escaping ([Itemslangs]) -> Void){
        
        print(Constants.LANG.current)
        var listlangs: [Itemslangs]!
        
        self.refInfo.child("/i18n/en/LangPromotion").observe(.value) { [self] (snapshot) in
            self.appDelegate.listlangsPromotions = self.appDelegate.listlangsPromotions.filter({$0.uid == "es"})
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangs = [Itemslangs]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "en"
                        let events = Itemslangs(key: key, uidProm: snap.key,  dictionary: postDictionary)
                        listlangs.append(events)
                    }
                }
            }
            listlangs = listlangs.filter({$0.status != nil})
            self.appDelegate.listlangsPromotions.append(contentsOf: listlangs)
            completion(listlangs)
        }
    }
    
    
    func getListLangsPromotionsES(completion : @escaping ([Itemslangs]) -> Void){
            
        print(Constants.LANG.current)
        var listlangsES: [Itemslangs]!
//            let langInit: String = Constants.LANG.current
                self.refInfo.child("/i18n/es/LangPromotion").observe(.value) { (snapshot) in
                    self.appDelegate.listlangsPromotions.removeAll()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        listlangsES = [Itemslangs]()
                        for snap in snapshots  {
                            if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = "es"
                                let events = Itemslangs(key: key, uidProm: snap.key,  dictionary: postDictionary)
                                listlangsES.append(events)
                            }
                        }
                    }
                    listlangsES = listlangsES.filter({$0.status != nil})
                    self.appDelegate.listlangsPromotions.append(contentsOf: listlangsES)
                    completion(listlangsES)
                }
        }
    
    
    func getListLangsCatopcpromEN(completion : @escaping ([ItemsCatopcprom]) -> Void){
        
        var listlangsProm: [ItemsCatopcprom]!
        self.refInfo.child("/langs/en/promociones/lang_catopcprom").observe(.value) { (snapshot) in
            self.appDelegate.listlangCatopcprom = self.appDelegate.listlangCatopcprom.filter({ $0.uid == "es" })
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangsProm = [ItemsCatopcprom]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "en"
                        let events = ItemsCatopcprom(key: key,uidProm: snap.key ,dictionary: postDictionary)
                        listlangsProm.append(events)
                    }
                }
            }
            self.appDelegate.listlangCatopcprom.append(contentsOf: listlangsProm)
            completion(listlangsProm)
        }
    }
    
    
    func getListLangsCatopcpromES(completion : @escaping ([ItemsCatopcprom]) -> Void){
        var listlangsProm: [ItemsCatopcprom]!
        self.refInfo.child("/langs/es/promociones/lang_catopcprom").observe(.value) { (snapshot) in
            self.appDelegate.listlangCatopcprom.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangsProm = [ItemsCatopcprom]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "es"
                        let events = ItemsCatopcprom(key: key,uidProm: snap.key ,dictionary: postDictionary)
                        listlangsProm.append(events)
                    }
                }
            }
            self.appDelegate.listlangCatopcprom.append(contentsOf: listlangsProm)
            completion(listlangsProm)
        }
    }
    
    
    func getListLangBenefitEN(completion : @escaping ([ItemsLangBenefitDesc]) -> Void){
        var listlangsBenefit: [ItemsLangBenefitDesc]!
        self.refInfo.child("/i18n/en/LangBenefit").observe(.value) { (snapshot) in
            self.appDelegate.listangBenefitDesc = self.appDelegate.listangBenefitDesc.filter({ $0.uid == "es"})
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangsBenefit = [ItemsLangBenefitDesc]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "en"
                        let events = ItemsLangBenefitDesc(key: key, dictionary: postDictionary)
                        listlangsBenefit.append(events)
                    }
                }
            }
            self.appDelegate.listangBenefitDesc.append(contentsOf: listlangsBenefit)
            completion(listlangsBenefit)
        }
    }
    
    
    func getListLangBenefitES(completion : @escaping ([ItemsLangBenefitDesc]) -> Void){
        var listlangsBenefit: [ItemsLangBenefitDesc]!
        self.refInfo.child("/i18n/es/LangBenefit").observe(.value) { (snapshot) in
            self.appDelegate.listangBenefitDesc.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listlangsBenefit = [ItemsLangBenefitDesc]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = "es"
                        let events = ItemsLangBenefitDesc(key: key, dictionary: postDictionary)
                        listlangsBenefit.append(events)
                    }
                }
            }
            
            self.appDelegate.listangBenefitDesc.append(contentsOf: listlangsBenefit)
            completion(listlangsBenefit)
        }
    }
    
    
    func getListLangBenefit(completion : @escaping ([ItemsLangBenefit]) -> Void){
        
        var listItemsLangBenefit : [ItemsLangBenefit] = [ItemsLangBenefit]()
        
        for itemBenefit in appDelegate.listPromotionBenefit {
            let desc = appDelegate.listangBenefitDesc.filter({ $0.key_benefit == itemBenefit.key_benefit })
            for itemDesc in desc {
                
                let img = appDelegate.listBenefits.filter({ $0.uid == itemBenefit.key_benefit })
                
                let itemsLangBenefit = ItemsLangBenefit()
                itemsLangBenefit.uid = itemDesc.uid
                itemsLangBenefit.description = itemDesc.description
                itemsLangBenefit.image = img.first?.icon
                itemsLangBenefit.order = itemBenefit.order
                itemsLangBenefit.status = true
                itemsLangBenefit.promotion = itemBenefit.key_promotion
                
                listItemsLangBenefit.append(itemsLangBenefit)
            }
            
        }
        appDelegate.listlamgBenefit = listItemsLangBenefit
        completion(listItemsLangBenefit)
        
    }
    
    
//    func getCurrency(completion : @escaping ([ItemCurrency]) -> Void){
//
//
//        var listCurrency: [ItemCurrency]!
//        //            let langInit: String = Constants.LANG.current
//        self.refInfo.child("/promociones/catalog_currency").observe(.value) { (snapshot) in
//            self.appDelegate.listCurrenct.removeAll()
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                listCurrency = [ItemCurrency]()
//                for snap in snapshots  {
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let events = ItemCurrency(key: key, dictionary: postDictionary)
//                        listCurrency.append(events)
//                    }
//                }
//            }
//            self.appDelegate.listCurrenct.append(contentsOf: listCurrency)
//            completion(listCurrency)
//        }
//    }
    
    
//SALES
    
    func getlistBenefits(completion : @escaping ([ItemBenefits]) -> Void){
        
        var listBenefits: [ItemBenefits]!
        self.refInfo.child("/sales/benefits/").observe(.value) { (snapshot) in
            self.appDelegate.listBenefits.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listBenefits = [ItemBenefits]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemBenefits(key: key, dictionary: postDictionary)
                        listBenefits.append(events)
                    }
                }
            }
            self.appDelegate.listBenefits = listBenefits
            completion(listBenefits)
        }
    }
    
    func getlistCategoryProduct(completion : @escaping ([ItemCategoryProduct]) -> Void){
       
        var listCategoryProduct: [ItemCategoryProduct]!
        self.refInfo.child("/sales/categoryProduct/").observe(.value) { (snapshot) in
            self.appDelegate.listCategoryProduct.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listCategoryProduct = [ItemCategoryProduct]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemCategoryProduct(key: key, dictionary: postDictionary)
                        listCategoryProduct.append(events)
                    }
                }
            }
            self.appDelegate.listCategoryProduct = listCategoryProduct
            completion(listCategoryProduct)
        }
    }
    
    func getlistCategoryPromotion(completion : @escaping ([ItemCategoryPromotion]) -> Void){
        
        var listCategoryPromotion: [ItemCategoryPromotion]!
        self.refInfo.child("/sales/categoryPromotion/").observe(.value) { (snapshot) in
            self.appDelegate.listCategoryPromotion.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listCategoryPromotion = [ItemCategoryPromotion]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemCategoryPromotion(key: key, dictionary: postDictionary)
                        listCategoryPromotion.append(events)
                    }
                }
            }
            self.appDelegate.listCategoryPromotion = listCategoryPromotion
            completion(listCategoryPromotion)
        }
    }
    
    func getlistCurrencies(completion : @escaping ([ItemCurrencies]) -> Void){
        
        var listCurrencies: [ItemCurrencies]!
        self.refInfo.child("/sales/currency/").observe(.value) { (snapshot) in
            self.appDelegate.listCurrencies.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listCurrencies = [ItemCurrencies]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemCurrencies(key: key, dictionary: postDictionary)
                        listCurrencies.append(events)
                    }
                }
            }
            self.appDelegate.listCurrencies = listCurrencies.filter({$0.status == 1})
            completion(listCurrencies)
        }
    }
    
//    func getlistProductPricesX(completion : @escaping ([ItemProductPrices]) -> Void){
//
//        var listProductPrices: [ItemProductPrices]!
//        self.refInfo.child("/sales/productsPrices/").observe(.value) { (snapshot) in
//            self.appDelegate.listProductPrices.removeAll()
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                listProductPrices = [ItemProductPrices]()
//                for snap in snapshots {
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let events = ItemProductPrices(key: key, dictionary: postDictionary)
//                        listProductPrices.append(events)
//                    }
//                }
//            }
//            self.appDelegate.listProductPrices = listProductPrices
//            completion(listProductPrices)
//        }
//    }
    
    func getlistProductPrices(completion : @escaping ([ItemProductPrices]) -> Void){
        var listProductPrices: [ItemProductPrices]!
        self.refInfo.child("/sales/productsPrices/\(Constants.CURR.current)").observe(.value) { (snapshot) in
            self.appDelegate.listProductPrices.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listProductPrices = [ItemProductPrices]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemProductPrices(key: key, dictionary: postDictionary)
                        listProductPrices.append(events)
                    }
                }
            }
            self.appDelegate.listProductPrices = listProductPrices//.filter({ $0.paxType == "adulto" })
            completion(listProductPrices)
        }
    }
    
    func getlistProducts(completion : @escaping ([ItemProducts]) -> Void){
        
        var listProducts: [ItemProducts]!
        self.refInfo.child("/sales/products/").observe(.value) { (snapshot) in
            self.appDelegate.listProducts.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listProducts = [ItemProducts]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemProducts(key: key, dictionary: postDictionary)
                        listProducts.append(events)
                    }
                }
            }
            self.appDelegate.listProducts = listProducts.filter({ $0.status_product == 1 })
            completion(listProducts)
        }
    }
    
    func getlistProductsPromotions(completion : @escaping ([ItemProductsPromotions]) -> Void){
        
        var listProductsPromotions: [ItemProductsPromotions]!
        self.refInfo.child("/sales/productsPromotions/").observe(.value) { (snapshot) in
            self.appDelegate.listProductsPromotions.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listProductsPromotions = [ItemProductsPromotions]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemProductsPromotions(key: key, dictionary: postDictionary)
                        listProductsPromotions.append(events)
                    }
                }
            }
            
            self.appDelegate.listProductsPromotions = listProductsPromotions//.filter({ $0.status == 1 })
            completion(listProductsPromotions)
        }
    }
    
    func getlistPromotionBenefit(completion : @escaping ([ItemPromotionBenefit]) -> Void){
        
        var listPromotionBenefit: [ItemPromotionBenefit]!
        self.refInfo.child("/sales/promotionBenefit/").observe(.value) { (snapshot) in
            self.appDelegate.listPromotionBenefit.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listPromotionBenefit = [ItemPromotionBenefit]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemPromotionBenefit(key: key, dictionary: postDictionary)
                        listPromotionBenefit.append(events)
                    }
                }
            }
            self.appDelegate.listPromotionBenefit = listPromotionBenefit
            completion(listPromotionBenefit)
        }
    }
    
    
    func getlistPromotions(completion : @escaping ([ItemPromotions]) -> Void){
        
        var listPromotions: [ItemPromotions]!
        self.refInfo.child("/sales/promotions/").queryOrdered(byChild: "status").queryEqual(toValue: 1).observe(.value) { (snapshot) in
//        self.refInfo.child("/sales/promotions/").observe(.value) { (snapshot) in
            self.appDelegate.listPromotions.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listPromotions = [ItemPromotions]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemPromotions(key: key, dictionary: postDictionary)
                        listPromotions.append(events)
                    }
                }
            }
            self.appDelegate.listPromotions = listPromotions.filter({$0.status == 1})
            completion(listPromotions)
        }
    }
    
    func getlistPromotionTabOption(completion : @escaping ([ItemPromotionTabOption]) -> Void){
       
        var listPromotionTabOption: [ItemPromotionTabOption]!
        self.refInfo.child("/sales/promotionTabOption/").observe(.value) { (snapshot) in
            self.appDelegate.listPromotionTabOption.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listPromotionTabOption = [ItemPromotionTabOption]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemPromotionTabOption(key: key, dictionary: postDictionary)
                        listPromotionTabOption.append(events)
                    }
                }
            }
            self.appDelegate.listPromotionTabOption = listPromotionTabOption
            completion(listPromotionTabOption)
        }
    }
    
    func getlistTabOption(completion : @escaping ([ItemTabOption]) -> Void){
        
        var listTabOption: [ItemTabOption]!
        self.refInfo.child("/sales/tabOption/").observe(.value) { (snapshot) in
            self.appDelegate.listTabOption.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listTabOption = [ItemTabOption]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemTabOption(key: key, dictionary: postDictionary)
                        listTabOption.append(events)
                    }
                }
            }
            self.appDelegate.listTabOption = listTabOption
            completion(listTabOption)
        }
    }
    
    func getlistTypeProduct(completion : @escaping ([ItemTypeProduct]) -> Void){
        
        var listTypeProduct: [ItemTypeProduct]!
        self.refInfo.child("/sales/typeProduct/").observe(.value) { (snapshot) in
            self.appDelegate.listTypeProduct.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listTypeProduct = [ItemTypeProduct]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let events = ItemTypeProduct(key: key, dictionary: postDictionary)
                        listTypeProduct.append(events)
                    }
                }
            }
            self.appDelegate.listTypeProduct = listTypeProduct
            completion(listTypeProduct)
        }
    }
    

//    func getListPickup(completion : @escaping ([itemsPickup]) -> Void){
//
//
//        var listPickup: [itemsPickup]!
//
//        self.refInfo.child("/core/pickup/").observe(.value) { [self] (snapshot) in
//                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                    listPickup = [itemsPickup]()
//                    for snap in snapshots  {
//
//                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
//                            let key = snap.key
//                            let events = itemsPickup(key : key, dictionary: postDictionary)
//                            listPickup.append(events)
//                        }
//                    }
//                }
//                self.appDelegate.listPickup.append(contentsOf: listPickup)
//                completion(listPickup)
//            }
//    }
    
    
    
    func getListGeographicPickup(completion : @escaping ([itemsGeographicPickup]) -> Void){
        
        var listGeographicPickup: [itemsGeographicPickup]!
        
        self.refInfo.child("/core/geographicPickup/").observe(.value) { [self] (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listGeographicPickup = [itemsGeographicPickup]()
                    for snap in snapshots  {
                        
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let events = itemsGeographicPickup(dictionary: postDictionary)
                            listGeographicPickup.append(events)
                        }
                    }
                }
                self.appDelegate.listGeographicPickup.append(contentsOf: listGeographicPickup)
                completion(listGeographicPickup)
            }
    }
    
    
    func getListCarShop(completion : @escaping ([ItemListCarshop]) -> Void){
        
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var itemListCarshop: [ItemListCarshop]!
        
        self.refCarShop.child("/productusers/\(uid)/cartProduct/").observeSingleEvent(of: .value) { [self] (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                itemListCarshop = [ItemListCarshop]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let events = ItemListCarshop(key: key ,dictionary: postDictionary)
                        itemListCarshop.append(events)
                    }
                }
            }
            let itemsDetail = itemListCarshop.first?.detail.filter({$0.status == 1})
            self.appDelegate.listItemListCarshop = itemListCarshop
            self.appDelegate.listItemListCarshop.first?.detail = itemsDetail ?? [ItemCarshop]()
            completion(itemListCarshop)
        }
    }
    
    func getListCarShopObserve(completion : @escaping ([ItemListCarshop]) -> Void){
        
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var itemListCarshop: [ItemListCarshop]!
        
        self.refCarShop.child("/productusers/\(uid)/cartProduct/").observe(.value) { [self] (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                itemListCarshop = [ItemListCarshop]()
                for snap in snapshots  {
                    let aux = snap.value as? [String: AnyObject]
                    let array = aux!.filter({$0.key == "detail"})
                    let arrayValues = array.values as? Dictionary<String, AnyObject>
////                    for item in arrayValues {
////                        print(item)
////                    }
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let events = ItemListCarshop(key: key ,dictionary: postDictionary)
                        itemListCarshop.append(events)
                    }
                }
            }
            let itemsDetail = itemListCarshop.first?.detail.filter({$0.status == 1})
            self.appDelegate.listItemListCarshop = itemListCarshop
            self.appDelegate.listItemListCarshop.first?.detail = itemsDetail ?? [ItemCarshop]()
            completion(itemListCarshop)
        }
    }
    
    func deleteItemListCarshop(listItemCarShop : ItemCarshop, completion:(Bool)-> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var status = false
        let aux = "/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(String(listItemCarShop.key))/"
        print(aux)
        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(String(listItemCarShop.key))/").removeValue(){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be delete: \(error).")
          } else {
            print("Data delete successfully!")
            status = true
          }
        }
        completion(status)
    }
    
    func saveUpdateKeyCarShop(key: String, value : Any, idDetail : String = "", idProduct : String = "", completion: @escaping (Bool)-> Void){
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")

            if idDetail != "" && idProduct != "" {
                let aux = "/productusers/\(uid)/cartProduct/\(self.appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(idDetail)/products/\(idProduct)/"
                print(aux)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(self.appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(idDetail)/products/\(idProduct)/").updateChildValues([key: value])
                    completion(true)
                
            }else if idDetail != "" && idProduct == ""{
                let aux = "/productusers/\(uid)/cartProduct/\(self.appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(idDetail)/"
                print(aux)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(self.appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(idDetail)").updateChildValues([key: value])
                    completion(true)
            }else{
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(self.appDelegate.listItemListCarshop.first?.key ?? "")").updateChildValues([key: value])
                    completion(true)
                
            }
    }
    
    func saveItemCarshopSencillo(itemCarShop : [ItemCarShoop], editItem : String = "", completion:(ItemListCarshop)-> Void){
        
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        
        var carShop: Dictionary = [String: Any]()
        
        var detail : [String : Any] =  [String : Any]()
        var productos : [String : Any] = [String : Any]()
        
        var productApiRequest : Dictionary = [String : Any]()
        var assistance : Dictionary = [String : Any]()
        var photopass : Dictionary = [String : Any]()
        var transport : Dictionary = [String : Any]()
        
        var itemAddProd : Dictionary = [String : Any]()
        var itemAddDetail : Dictionary = [String : Any]()
        
        detail.removeAll()
        productos.removeAll()
        
        let itemP = itemCarShop.first
        let itemD = itemCarShop.first
        
        let photoPassStatus = itemP!.itemComplementos.fotos.status
        
        assistance = [
            "addOnId" : itemP?.itemComplementos.seguroIKE.id ?? 0,
            "addOnName" : itemP?.itemComplementos.seguroIKE.name ?? "",
            "adults" : itemP?.itemComplementos.seguroIKE.adultAmount ?? 0,
            "amount" : itemP?.itemComplementos.seguroIKE.amount ?? 0,
            "normalAdults" : itemP?.itemComplementos.seguroIKE.normalAdultAmount ?? 0,
            "normalAmount" : itemP?.itemComplementos.seguroIKE.normalAmount ?? 0
        ]
        
        photopass = [
            "amount" : itemP!.itemComplementos.fotos.amount,
            "individual" : itemP!.itemComplementos.fotos.individual,
            "itineraryId" : itemP!.itemComplementos.fotos.itineraries.itineraryId!,
            "itineraryName" : itemP!.itemComplementos.fotos.name,
            "normalAmount" : itemP!.itemComplementos.fotos.normalAmount,
            "normalIndividual" : itemP!.itemComplementos.fotos.normalIndividual,
            "optionId" : itemP!.itemComplementos.fotos.rateKey!,
            "packageId" : itemP!.itemComplementos.fotos.itineraries.packageId!,
            "packageName" : itemP!.itemComplementos.fotos.packageName
        ]
        
        transport = [
            "geographicName" : itemP?.itemComplementos.transporte.nameLoc ?? "",
            "hotelId" : itemP?.itemComplementos.transporte.id ?? 0,
            "hotelPickupId" : itemP?.itemComplementos.transporte.pickUps.id ?? 0,
            "nameHotel" : itemP?.itemComplementos.transporte.name ?? "",
            "schedulePark" : itemP?.itemComplementos.transporte.time ?? "",
            "timePickup" : itemP?.itemComplementos.transporte.pickUps.time ?? ""
        ]
        let auxRateKey = itemP!.itemDiaCalendario.rateKey
        let aRateKey = itemP!.itemDiaCalendario.rateKey.filter({ $0.nameGeographic.lowercased() == itemP?.itemComplementos.transporte.nameLoc.lowercased() })
        print(aRateKey)
        
        productApiRequest = [
            "activitiesRateKey" : aRateKey.first?.rateKey ?? itemP!.itemDiaCalendario.rateKey.first!.rateKey!,
            "addonsRateKey" : itemP!.itemComplementos.seguroIKE.rateKey!,
//            "transport" : transport,
//            "photopass" : photopass,
        ]
        
        var dateOrder = ""
        if itemP?.dateOrder == ""{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyyHH:mm:ss.SSSS"
            dateOrder = dateFormatter.string(from: date)
        }else{
            dateOrder = itemP?.dateOrder ?? ""
        }
        
        
        itemAddProd = [
            "dateOrder" : dateOrder,
            "productDate" : itemP!.itemDiaCalendario.date,
            "availabilityStatus" : true,
            "businessCode" : itemP?.itemProdProm.first?.code_park ?? "",
            "productAllotment" : itemP?.productAllotment ?? false,
            "productId" : itemP?.itemProdProm.first?.idProducto ?? 0,
            "productIke" : itemP!.itemComplementos.seguroIKE.status!,
            "productName" : itemP!.itemProdProm.first!.descripcionEn!,
            "productFood" : itemP?.itemProdProm.first?.food == 0 ? false : true,
            "productPhotopass" : photoPassStatus!,//itemP?.itemProdProm.first?.photopass == 0 ? false : true,
            "productTransport" : itemP?.itemProdProm.first?.transportation == 0 ? false : true,
            "productVisitor" : [
                "productAdult" : itemP?.itemVisitantes.adulto,
                "productChild" : itemP?.itemVisitantes.ninio,
                "productInfant" : itemP?.itemVisitantes.infantes
            ]
        ] as [String : Any]
        
        productos = itemAddProd
        
        
        var addPriceFotoSub = 0.0
        var addPriceFotoAhorro = 0.0
        
        var addPriceIKE = 0.0
        var addPriceIKEAhorro = 0.0
        
        if itemD!.itemComplementos.fotos.status! {
            addPriceFotoSub = itemD!.itemComplementos.fotos.amount
            addPriceFotoAhorro = itemD!.itemComplementos.fotos.normalAmount - itemD!.itemComplementos.fotos.amount
        }
        
        if itemD!.itemComplementos.seguroIKE.status! {
            addPriceIKE = itemD!.itemComplementos.seguroIKE.amount
            addPriceIKEAhorro =  itemD!.itemComplementos.seguroIKE.amount - itemD!.itemComplementos.seguroIKE.normalAmount
        }
        
        let subtotal = (Double(itemD!.itemVisitantes.adulto) * itemD!.itemDiaCalendario.subtotalAdulto) + (Double(itemD!.itemVisitantes.ninio) * itemD!.itemDiaCalendario.subtotalChildren)
        let ahorro = (Double(itemD!.itemVisitantes.adulto) * itemD!.itemDiaCalendario.ahorroAdulto) + (Double(itemD!.itemVisitantes.ninio) * itemD!.itemDiaCalendario.ahorroChildren)
        let price = (subtotal + addPriceFotoSub + addPriceIKE) + (ahorro + addPriceFotoAhorro + addPriceIKEAhorro)//Double(itemD!.itemDiaCalendario.normalAmount)//(Double(itemD!.itemVisitantes.adulto) * itemD!.itemDiaCalendario.normalAmount) + (Double(itemD!.itemVisitantes.ninio) * itemD!.itemDiaCalendario.ahorroChildren)
        print(subtotal)
        print(ahorro)
        print(price)
        
        
        let datails = itemD!.itemProdProm.first
        let aux =  subtotal + addPriceFotoSub + addPriceIKE
        itemAddDetail = [
            "familyId" : itemD!.itemDiaCalendario.family.id,
            "uid" : itemD!.itemProdProm.first?.uid ?? "",
            "promotionId" : datails?.cupon_promotion ?? "",//datail?.code_product ?? "",
            "promotionName" : datails?.code_promotion ?? "",//datail?.descripcionEn ?? "",
            "price" : price,
            "discountPrice" : subtotal + addPriceFotoSub + addPriceIKE,//ahorro + addPriceFotoAhorro + addPriceIKEAhorro,
            "saving" : ahorro + addPriceFotoAhorro + addPriceIKEAhorro,//price,
            "status" : itemP?.status ?? 1
        ]
        
        detail = itemAddDetail
        
        if appDelegate.listItemListCarshop.count > 0{
            
            if editItem != "" {
                
                let aux = "/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")"
                
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)").updateChildValues(detail)
                
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")/").updateChildValues(productos)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")/productApiRequest/").updateChildValues(productApiRequest)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")/productApiRequest/assistance/").updateChildValues(assistance)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")/productApiRequest/photopass/").updateChildValues(photopass)
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editItem)/products/\(itemCarShop.first?.keyItemEditCarShop ?? "")/productApiRequest/transport/").updateChildValues(transport)
                
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(itemCarShop.first?.keyItemEditCarShop ?? "")/products/\(editItem)/").updateChildValues(productos)
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(itemCarShop.first?.keyItemEditCarShop ?? "")/products/\(editItem)/productApiRequest/").updateChildValues(productApiRequest)
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(itemCarShop.first?.keyItemEditCarShop ?? "")/products/\(editItem)/productApiRequest/assistance/").updateChildValues(assistance)
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(itemCarShop.first?.keyItemEditCarShop ?? "")/products/\(editItem)/productApiRequest/photopass/").updateChildValues(photopass)
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(itemCarShop.first?.keyItemEditCarShop ?? "")/products/\(editItem)/productApiRequest/transport/").updateChildValues(transport)
                
            }else{
                if let keyValueProd =  self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/").childByAutoId().key{
                    
                    
                    self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)").updateChildValues(detail)
                    
                    if let keyProductApiRequest = self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/").childByAutoId().key {
                        
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/\(keyProductApiRequest)/").updateChildValues(productos)
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/").updateChildValues(productApiRequest)
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/assistance/").updateChildValues(assistance)
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/photopass/").updateChildValues(photopass)
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/transport/").updateChildValues(transport)
                    }
                    
                    
                }
            }
            
        }else{
            let date = Date()
            let calendario = Calendar.current
            let anio = calendario.component(.year, from: date)
            let day = calendario.component(.day, from: date)
            let mes = calendario.component(.month, from: date)
            let calendar = Calendar(identifier: .gregorian)
            let components = DateComponents(year: anio, month: mes, day: day, hour: 0, minute: 0, second: 0)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es")
            formatter.dateFormat = "yyyy-MM-dd"
            let fechaHoy = formatter.string(from: calendar.date(from: components)!)
            carShop = [
                "creationDate": fechaHoy,
                "currency" : Constants.CURR.current,
                "status": 1,
                "totalDiscountPrice": 0.0,
                "totalPrice" : 0.0
            ]
            
            if let keyValue = self.refCarShop.child("/productusers/\(uid)/cartProduct/").childByAutoId().key {
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)").updateChildValues(carShop)
                if let keyValueProd =  self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/").childByAutoId().key{
                    
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)").updateChildValues(detail)
                        
                        if let keyProductApiRequest = self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/").childByAutoId().key {
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/\(keyProductApiRequest)/").updateChildValues(productos)
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/").updateChildValues(productApiRequest)
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/assistance/").updateChildValues(assistance)
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/photopass/").updateChildValues(photopass)
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/\(keyProductApiRequest)/productApiRequest/transport/").updateChildValues(transport)
                        }
                }
            }
        }
        
        completion(ItemListCarshop())
    }
    
    
    
    func saveItemListCarshop(listItemCarShop : [ItemCarShoop], editId : String = "", completion:(ItemListCarshop)-> Void){
        
        let uid = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
        var carShop: Dictionary = [String: Any]()
        
        var arrayDetail : [[String : Any]] =  [[String : Any]]()
        var arrayProductos : [[String : Any]] =  [[String : Any]]()
        
        let itemDetail = listItemCarShop.filter({ $0.itemProdProm.first?.principal == true })
        var itemsProd = listItemCarShop.filter({ $0.itemProdProm.first?.principal == false })
        
        var itemAddProd : Dictionary = [String : Any]()
        
        var productApiRequest : Dictionary = [String : Any]()
        var assistance : Dictionary = [String : Any]()
        var photopass : Dictionary = [String : Any]()
        var transport : Dictionary = [String : Any]()
        
        var addPriceFotoSub = 0.0
        var addPriceFotoAhorro = 0.0
        var addPriceIkeSub = 0.0
        var addPriceIkeAhorro = 0.0
        var cantidadVisitantesIKE = 0
        
        arrayDetail.removeAll()
        arrayProductos.removeAll()
        
        if itemsProd.count == 0 {
            itemsProd.append(contentsOf : itemDetail)
        }
        
        
        for itemP in itemsProd {
            
            let photoPass = itemP.itemComplementos.fotos.status
            if photoPass ?? false {
                addPriceFotoSub = addPriceFotoSub + itemP.itemComplementos.fotos.amount//itemD.itemComplementos.fotos.amount
                addPriceFotoAhorro = addPriceFotoSub + (itemP.itemComplementos.fotos.normalAmount - itemP.itemComplementos.fotos.amount)  //itemD.itemComplementos.fotos.amount - itemD.itemComplementos.fotos.normalAmount
            }
            
            let seguroIKE = itemP.itemComplementos.seguroIKE.status
            if seguroIKE ?? false {
                let visitantesCount = itemP.itemVisitantes.adulto + itemP.itemVisitantes.adulto + itemP.itemVisitantes.adulto
                if visitantesCount > cantidadVisitantesIKE {
                    cantidadVisitantesIKE = visitantesCount
                    
                    addPriceIkeSub = itemP.itemComplementos.seguroIKE.amount
                    addPriceIkeAhorro = itemP.itemComplementos.seguroIKE.normalAmount - itemP.itemComplementos.seguroIKE.amount
                }
            }
            
            assistance = [
                "addOnId" : itemP.itemComplementos.seguroIKE.id ?? 0,
                "addOnName" : itemP.itemComplementos.seguroIKE.name ?? "",
                "adults" : itemP.itemComplementos.seguroIKE.adultAmount ?? 0,
                "amount" : itemP.itemComplementos.seguroIKE.amount ?? 0,
                "normalAdults" : itemP.itemComplementos.seguroIKE.normalAdultAmount ?? 0,
                "normalAmount" : itemP.itemComplementos.seguroIKE.normalAmount ?? 0
            ]
            
            photopass = [
                "amount" : itemP.itemComplementos.fotos.amount,
                "individual" : itemP.itemComplementos.fotos.individual,
                "itineraryId" : itemP.itemComplementos.fotos.itineraries.itineraryId!,
                "itineraryName" : itemP.itemComplementos.fotos.name,
                "normalAmount" : itemP.itemComplementos.fotos.normalAmount,
                "normalIndividual" : itemP.itemComplementos.fotos.normalIndividual,
                "optionId" : itemP.itemComplementos.fotos.rateKey!,
                "packageId" : itemP.itemComplementos.fotos.itineraries.packageId!,
                "packageName" : itemP.itemComplementos.fotos.packageName
            ]
            
            transport = [
                "geographicName" : itemP.itemComplementos.transporte.nameLoc ?? "",
                "hotelId" : itemP.itemComplementos.transporte.id ?? 0,
                "hotelPickupId" : itemP.itemComplementos.transporte.pickUps.id ?? 0,
                "nameHotel" : itemP.itemComplementos.transporte.name ?? "",
                "timePickup" : itemP.itemComplementos.transporte.pickUps.time ?? ""
            ]
            
            productApiRequest = [
                "activitiesRateKey" : itemP.itemDiaCalendario.rateKey.first!.rateKey!,
                "addons_Ratekey" : itemP.itemComplementos.seguroIKE.rateKey!,
                "assistance" : assistance,
                "transport" : transport,
                "photopass" : photopass,
            ]
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyyHH:mm:ssZ"
            print(dateFormatter.string(from: date))
            
            itemAddProd = [
                "dateOrder" : dateFormatter.string(from: date),
                "businessCode" : itemP.itemProdProm.first?.code_park ?? "",
                "productAllotment" : itemP.productAllotment,
                "productApiRequest" : productApiRequest,
                "productDate" : itemP.itemDiaCalendario.date,
                "availabilityStatus" : true,
                "productId" : itemP.itemProdProm.first?.idProducto ?? 0,
                "productIke" : itemP.itemComplementos.seguroIKE.status!,
                "productName" : itemP.itemProdProm.first!.descripcionEn!,
                "productFood" : itemP.itemProdProm.first?.food == 0 ? false : true,
                "productPhotopass" : photoPass!,//itemP?.itemProdProm.first?.photopass == 0 ? false : true,
                "productTransport" : itemP.itemProdProm.first?.transportation == 0 ? false : true,
                "productVisitor" : [
                    "productAdult" : itemP.itemVisitantes.adulto,
                    "productChild" : itemP.itemVisitantes.ninio,
                    "productInfant" : itemP.itemVisitantes.infantes
                ]
            ] as [String : Any]
            arrayProductos.append(itemAddProd)
        }
        
        
        for itemD in itemDetail {
            
            let subtotal = itemD.itemDiaCalendario.amount//((Double(itemD.itemVisitantes.adulto) * itemD.itemDiaCalendario.subtotalAdulto) + (Double(itemD.itemVisitantes.ninio) * itemD.itemDiaCalendario.subtotalChildren))
            let ahorro = itemD.itemDiaCalendario.normalAmount - itemD.itemDiaCalendario.amount//((Double(itemD.itemVisitantes.adulto) * itemD.itemDiaCalendario.ahorroAdulto) + (Double(itemD.itemVisitantes.ninio) * itemD.itemDiaCalendario.ahorroChildren))
            
            let datail = itemD.itemProdProm.first
            let itemAddDetail : [String : Any]! = [
                "familyId" : itemD.itemDiaCalendario.family.id,
                "uid" : itemD.itemProdProm.first?.uid ?? "",
                "promotionId" : datail?.cupon_promotion ?? "",
                "promotionName" : datail?.descripcionEn ?? "",
                "price" : (subtotal ?? 0.0) + addPriceFotoSub + addPriceIkeSub,
                "discountPrice" : ahorro + addPriceFotoAhorro + addPriceIkeAhorro,
                "saving" : ahorro + addPriceFotoAhorro + addPriceIkeAhorro,
                "status" : 1
            ]
            arrayDetail.append(itemAddDetail)
        }
        
        if appDelegate.listItemListCarshop.count > 0{
            
            if editId != "" {
                
                for arrp in arrayProductos {
                    let productId : Int? = arrp["productId"] as? Int ?? 0
                    let itemCarShopIdEdit = listItemCarShop.filter({ $0.itemProdProm.first?.idProducto == productId })
                    let idEdit = itemCarShopIdEdit.first?.keyItemEditCarShop
                    
                    let aux3 = "/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editId)/products/\(idEdit ?? "")"
                    if arrayDetail.count > 0 {
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editId)").updateChildValues(arrayDetail.first!)
                    }
                     
                    self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(editId)/products/\(idEdit ?? "")/").updateChildValues(arrp)
                }
//                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/").childByAutoId().updateChildValues(arrp)
            }else{
//                let aux = "/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(appDelegate.listItemListCarshop.first?.detail.first?.key ?? "")/products/\(editId)"
                if let keyValueProd =  self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/").childByAutoId().key{
                    self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)").updateChildValues(arrayDetail.first!)
                    for arrp in arrayProductos {
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(appDelegate.listItemListCarshop.first?.key ?? "")/detail/\(keyValueProd)/products/").childByAutoId().updateChildValues(arrp)
                    }
                }
            }
        }else{
            let date = Date()
            let calendario = Calendar.current
            let anio = calendario.component(.year, from: date)
            let day = calendario.component(.day, from: date)
            let mes = calendario.component(.month, from: date)
            let calendar = Calendar(identifier: .gregorian)
            let components = DateComponents(year: anio, month: mes, day: day, hour: 0, minute: 0, second: 0)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es")
            formatter.dateFormat = "yyyy-MM-dd"
            let fechaHoy = formatter.string(from: calendar.date(from: components)!)
            carShop = [
                "creationDate": fechaHoy,
                "currency" : Constants.CURR.current,
                "status": 1,
                "totalDiscountPrice": 0.0,
                "totalPrice" : 0.0
            ]
            if let keyValue = self.refCarShop.child("/productusers/\(uid)/cartProduct/").childByAutoId().key {
                self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)").updateChildValues(carShop)
                for arr in arrayDetail {
                    if let keyValueProd =  self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/").childByAutoId().key{
                        self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)").updateChildValues(arr)//.childByAutoId().updateChildValues(arr)
                        for arrp in arrayProductos {
                            self.refCarShop.child("/productusers/\(uid)/cartProduct/\(keyValue)/detail/\(keyValueProd)/products/").childByAutoId().updateChildValues(arrp)
                        }
                    }
                }
            }
        }
        
        completion(ItemListCarshop())
    }
    
    func getListTituloES(completion : @escaping ([ItemLangTitle]) -> Void){
        
        var listItemLangTitle: [ItemLangTitle]!
        
        self.refInfo.child("/i18n/es/LangTitle/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listItemLangTitle.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listItemLangTitle = [ItemLangTitle]()
                for snap in snapshots  {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let events = ItemLangTitle(key : key, dictionary: postDictionary)
                        listItemLangTitle.append(events)
                    }
                }
            }
            self.appDelegate.listItemLangTitle.append(contentsOf: listItemLangTitle)
            completion(listItemLangTitle)
        }
    }
    
    func getListTituloEN(completion : @escaping ([ItemLangTitle]) -> Void){
        
        var listItemLangTitle: [ItemLangTitle]!
        
        self.refInfo.child("/i18n/en/LangTitle/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listItemLangTitle = self.appDelegate.listItemLangTitle.filter({$0.langCode == "es"})
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listItemLangTitle = [ItemLangTitle]()
                    for snap in snapshots  {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let events = ItemLangTitle(key : key, dictionary: postDictionary)
                            listItemLangTitle.append(events)
                        }
                    }
                }
                self.appDelegate.listItemLangTitle.append(contentsOf: listItemLangTitle)
                completion(listItemLangTitle)
            }
    }
    
    func getListPhoneCode(completion : @escaping ([ItemPhoneCode]) -> Void){
        
        var listItemPhoneCode: [ItemPhoneCode]!
        
        self.refInfo.child("/clasificators/phonecode/").observe(.value) { [self] (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listItemPhoneCode = [ItemPhoneCode]()
                    for snap in snapshots  {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let events = ItemPhoneCode(key : key, dictionary: postDictionary)
                            listItemPhoneCode.append(events)
                        }
                    }
                }
                self.appDelegate.listItemPhoneCode.append(contentsOf: listItemPhoneCode)
                completion(listItemPhoneCode)
            }
    }
    
    func getListLangCountryES(completion : @escaping ([ItemLangCountry]) -> Void){
        
        var listLangCountry: [ItemLangCountry]!
        
        self.refInfo.child("/i18n/es/LangCountry/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listItemLangCountry.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                listLangCountry = [ItemLangCountry]()
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let events = ItemLangCountry(key : key, lang: "es", dictionary: postDictionary)
                        listLangCountry.append(events)
                    }
                }
            }
            self.appDelegate.listItemLangCountry.append(contentsOf: listLangCountry)
            completion(listLangCountry)
        }
    }
    
    func getListLangCountryEN(completion : @escaping ([ItemLangCountry]) -> Void){
        
        var listLangCountry: [ItemLangCountry]!
        
        self.refInfo.child("/i18n/en/LangCountry/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listItemLangCountry = self.appDelegate.listItemLangCountry.filter({ $0.lang == "es" })
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listLangCountry = [ItemLangCountry]()
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let events = ItemLangCountry(key : key, lang: "en", dictionary: postDictionary)
                            listLangCountry.append(events)
                        }
                    }
                }
                self.appDelegate.listItemLangCountry.append(contentsOf: listLangCountry)
                completion(listLangCountry)
            }
    }
    
    func getListLangTabOptionES(completion : @escaping ([langTabOption]) -> Void){
        
        var listLangTabOption: [langTabOption]!
        
        self.refInfo.child("/i18n/es/LangTabOption/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listLangTabOption.removeAll()
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listLangTabOption = [langTabOption]()
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let tabOption = langTabOption(key : key, lang: "es", dictionary: postDictionary)
                            listLangTabOption.append(tabOption)
                        }
                    }
                }
                self.appDelegate.listLangTabOption.append(contentsOf: listLangTabOption)
                completion(listLangTabOption)
            }
    }
    
    func getListLangTabOptionEN(completion : @escaping ([langTabOption]) -> Void){
        var listLangTabOption: [langTabOption]!
        self.refInfo.child("/i18n/en/LangTabOption/").observe(.value) { [self] (snapshot) in
            self.appDelegate.listLangTabOption = self.appDelegate.listLangTabOption.filter({ $0.lang == "es"})
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    listLangTabOption = [langTabOption]()
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let tabOption = langTabOption(key : key, lang: "en", dictionary: postDictionary)
                            listLangTabOption.append(tabOption)
                        }
                    }
                }
                self.appDelegate.listLangTabOption.append(contentsOf: listLangTabOption)
                completion(listLangTabOption)
            }
    }
    
    
    func getListlangCatopcprom(completion : @escaping ([ItemsCatopcprom]) -> Void){
        let promotionTabOption = appDelegate.listPromotionTabOption.filter({ $0.status == 1 })
        var listlangCatopcprom = [ItemsCatopcprom]()
        
        for itemTabOption in promotionTabOption {
            let listTabOption = appDelegate.listTabOption.filter({ $0.uid == itemTabOption.key_tabOption})
            let listLangTabOption = appDelegate.listLangTabOption.filter({ $0.key_tab_option == itemTabOption.key_tabOption})
            
            for itemLangTabOption in listLangTabOption {
                let itemlangCatopcprom = ItemsCatopcprom()
                itemlangCatopcprom.identifier = listTabOption.first?.code
                itemlangCatopcprom.uid = itemTabOption.uid
                itemlangCatopcprom.key = itemLangTabOption.lang
                itemlangCatopcprom.lang_Promo = itemTabOption.key_promotion
                itemlangCatopcprom.name = itemLangTabOption.name
                itemlangCatopcprom.order = listTabOption.first?.showOrder
                itemlangCatopcprom.status = listTabOption.first?.status == 1 ? true : false
                
                listlangCatopcprom.append(itemlangCatopcprom)
            }
        }
        appDelegate.listlangCatopcprom = listlangCatopcprom
        
        
        
        completion(listlangCatopcprom)
    }
    
}


