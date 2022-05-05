//
//  FirebaseBR.swift
//  XCARET!
//
//  Created by Angelica Can on 12/6/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftyJSON
//import MarketingCloudSDK

open class FirebaseBR {
    static let shared = FirebaseBR()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let ref: DatabaseReference? = Database.database().reference()
    
   
        
    func getParksGroup(completion:@escaping () -> Void){
        FirebaseDB.shared.getLangLabelES(completion:{ (listLanguage) in
            FirebaseDB.shared.getLangLabelEN(completion:{ (listLanguage) in
                FirebaseDB.shared.getAwards { (listAwards) in
                    FirebaseDB.shared.getParks { (listParks) in
                        FirebaseDB.shared.getLegals(completion: { (listLegals) in
                            FirebaseDB.shared.getCalendarDF(completion: { (listSeasonDF) in
                                FirebaseDB.shared.getSchedulesDF(completion: { (listSchedulesDF) in
                                    FirebaseDB.shared.getSeason { (listSeasons) in
                                        FirebaseDB.shared.getSchedules(completion: { (listSchedules) in
                                            FirebaseDB.shared.getCatRestrictions(completion: { (listRestrictions) in
                                                FirebaseDB.shared.getRestrictionsByActivity(completion: { (listRestByAct) in
                                                    FirebaseDB.shared.getCatCategories(completion: { (listCategories) in
                                                        FirebaseDB.shared.getCatSubcategories(completion: { (listSubcategories) in
                                                            FirebaseDB.shared.getSubcategoryByActivity(completion: { (listSubByAct) in
                                                                FirebaseDB.shared.getCategoryByActivity(completion: { (listCatByAct) in
                                                                    FirebaseDB.shared.getCatTags(completion: { (listTags) in
                                                                        FirebaseDB.shared.getTagsActivity(completion: { (listTagsByActivity) in
                                                                            FirebaseDB.shared.getCatServices(completion: { (listServices) in
                                                                                FirebaseDB.shared.getCatRoutes(completion: { (listRoutes) in
                                                                                    FirebaseDB.shared.getPictures {
                                                                                        FirebaseDB.shared.getGalleries {
                                                                                            FirebaseDB.shared.getActivities(completion: { (listActivities) in
                                                                                                FirebaseDB.shared.getServicesLocation(completion: { (listServLocation) in
                                                                                                    FirebaseDB.shared.getCatFiltersMap(completion: { (listFilters) in
                                                                                                        FirebaseDB.shared.getMaps {
                                                                                                            FirebaseDB.shared.getInfoContact {
//                                                                                                                FirebaseDB.shared.getCupons {
                                                                                                                    FirebaseDB.shared.getBookingConfig(completion: {
                                                                                                                        FirebaseDB.shared.getAdmissionsActivities(completion: {
                                                                                                                            FirebaseDB.shared.getAdmission(completion: {
                                                                                                                                FirebaseDB.shared.getEvents(completion: {
//                                                                                                                                    FirebaseDB.shared.getNetworkParamsConfig {
                                                                                                                                        FirebaseDB.shared.getcontentPrograms {
                                                                                                                                            FirebaseDB.shared.getPrograms {
                                                                                                                                                FirebaseDB.shared.getListLang{ (listLanguage) in
                                                                                                                                                    FirebaseDB.shared.getlistPromotions(completion:{ (listPromotions) in
//                                                                                                                                                    FirebaseDB.shared.getListPrecios(completion:{ (listPrecios) in
                                                                                                                                                        FirebaseDB.shared.getListLangsPromotionsES(completion:{ (listlangsES) in
                                                                                                                                                            FirebaseDB.shared.getListLangsPromotionsEN(completion:{ (listlangs) in
                                                                                                                                                                FirebaseDB.shared.getListLangsCatopcpromES(completion:{ (listlangsProm) in
                                                                                                                                                                    FirebaseDB.shared.getListLangsCatopcpromEN(completion:{ (listlangsProm) in
                                                                                                                                                                        FirebaseDB.shared.getListLangBenefitES(completion:{ (listlangsBenefit) in
                                                                                                                                                                            FirebaseDB.shared.getListLangBenefitEN(completion:{ (listlangsBenefit) in
//                                                                                                                                                                                FirebaseDB.shared.getCurrency(completion:{ (listCurrency) in
                                                                                                                                                                                    FirebaseDB.shared.getDestinations {
                                                                                                                                                                                        FirebaseDB.shared.getScheduleDestination { listScheduleAdmission in
                                                                                                                                                                                                completion()
                                                                                                                                                                                        }
                                                                                                                                                                                    }
//                                                                                                                                                                                })
                                                                                                                                                                            })
                                                                                                                                                                            })
                                                                                                                                                                        })
                                                                                                                                                                    })
                                                                                                                                                                })
                                                                                                                                                            })
//                                                                                                                                                        })
                                                                                                                                                    })
                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
//                                                                                                                                    }
                                                                                                                                })
                                                                                                                            })
                                                                                                                        })
                                                                                                                    })
//                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    })
                                                                                                })
                                                                                            })
                                                                                        }
                                                                                    }
                                                                                })
                                                                            })
                                                                        })
                                                                    })
                                                                })
                                                            })
                                                        })
                                                    })
                                                })
                                            })
                                        })
                                    }
                                    
                                })
                            })
                        })
                    }
                }
            })//0
        })//0
    }
    
    
    
    
    
    func getCodesalesforce(completion : @escaping () -> Void){
        FirebaseDB.shared.getBookingConfig{
            completion()
        }
    }
    
//    func getLabelsDataLang(completion : @escaping () -> Void){
//
//            FirebaseDB.shared.getLangLabel{
//                completion()
//            }
//    }
    
    
    func getCodesAyB(completion : @escaping () -> Void){
        FirebaseDB.shared.getProductoAyB {
            completion()
        }
    }
    
    func getInfoByParkSelected(completion : @escaping () -> Void){
        
        if !self.appDelegate.itemParkSelected.uid.isEmpty {
            let parkSelected = self.appDelegate.itemParkSelected
            //Obtenemos el params del booking
            if let bookingParam = self.appDelegate.listNetworkParams.first(where: { $0.key_park == parkSelected.code}) {
                self.appDelegate.itemParkSelected.bookingParams = bookingParam.params
            }else{
                self.appDelegate.itemParkSelected.bookingParams = appDelegate.bookingConfig.params
            }
            
            FirebaseDB.shared.getFavoritesByPark(codePark: parkSelected.uid) { (listFavPark) in
                self.appDelegate.listFavoritesByPark = listFavPark
                self.appDelegate.listEventsByPark = self.appDelegate.listEvents.filter({ $0.key_park == parkSelected.uid})
                self.getFiltersMapByPark { (listFilter) in
                    self.appDelegate.listFilterMapByPark = listFilter
                    self.getListImagesRestByPark(codePark: parkSelected.code, completion: { (listImages) in
//                        FirebaseDB.shared.getStaticDataByPark(codePark: parkSelected.code) { (listStaticData) in
                        self.appDelegate.listImgRestaurantsByPark = listImages
                        self.appDelegate.listActivitiesByPark = self.appDelegate.listAllActivities.filter({ $0.act_keyPark == parkSelected.uid})
                        self.appDelegate.listServicesLocationByPark = self.appDelegate.listAllServicesLocation.filter({ $0.s_keyPark == parkSelected.uid})
//                        self.appDelegate.listEventsByPark = self.appDelegate.listEvents.filter({ $0.key_park == parkSelected.uid})
                        if  let mapSelected : ItemMapInfo = self.appDelegate.listAllMaps.first(where: { $0.m_keyPark == parkSelected.uid}){
                            self.appDelegate.itemMapSelected = mapSelected
                        }
                        completion()
//                        }
                    })
                }
            }
        }
        completion()
    }
    
    func getResetInformation(){
        self.appDelegate.itemParkSelected = ItemPark()
        self.appDelegate.listActivitiesByPark = [ItemActivity]()
        self.appDelegate.listServicesLocationByPark = [ItemServicesLocation]()
        self.appDelegate.itemMapSelected = ItemMapInfo()
        self.appDelegate.listFavoritesByPark = [ItemFavorite]()
        self.appDelegate.listFilterMapByPark = [ItemFilterMap]()
        self.appDelegate.listImgRestaurantsByPark = [UIImage]()
    }
    
    func getListImagesRestByPark(codePark: String, completion:([UIImage]) -> Void) {
        var listImages = [UIImage]()
        switch codePark {
        case "XC":
            listImages = [ UIImage(named: "Parks/XC/Restaurants/carnes")!,
                           UIImage(named: "Parks/XC/Restaurants/desayuno")!,
                           UIImage(named: "Parks/XC/Restaurants/internacional")!,
                           UIImage(named: "Parks/XC/Restaurants/mariscos")!,
                           UIImage(named: "Parks/XC/Restaurants/tradicional")!]
        case "XS":
            listImages = [ UIImage(named: "Parks/XS/Restaurants/xs_comida")!,
                           UIImage(named: "Parks/XS/Restaurants/xs_comida1")!,
                           UIImage(named: "Parks/XS/Restaurants/xs_comida2")!,
                           UIImage(named: "Parks/XS/Restaurants/xs_comida3")!,
                           UIImage(named: "Parks/XS/Restaurants/xs_comida4")!]
        default:
            listImages = [ UIImage(named: "Parks/XH/Restaurants/bebidas")!,
                           UIImage(named: "Parks/XH/Restaurants/buffet")!,
                           UIImage(named: "Parks/XH/Restaurants/postres")!,
                           UIImage(named: "Parks/XH/Restaurants/snacks")!]
        }
        
        completion(listImages)
    }
    
    func getInfoHotel(completion: ([ItemInfoHotel]) -> Void){
        var listInfo : [ItemInfoHotel] = [ItemInfoHotel]()
        
        //Ir APP Hotel
        let itemAppHotel = ItemInfoHotel()
        itemAppHotel.title = "lbl_title_house".getNameLabel()//"titleHouse".localized()
        itemAppHotel.typeCellHotel = .cellGoHotel
        
        //Casas
        let itemInfoCasas = ItemInfoHotel()
        var listView = [ItemDetailImages]()
        itemInfoCasas.title = "lbl_title_house".getNameLabel()//"titleHouse".localized()
        itemInfoCasas.subtitle = "lbl_subtitle_house".getNameLabel()//"subtitleHouse".localized()
        listView = [ItemDetailImages(name: "Viento", urlImage: "viento"),
                    ItemDetailImages(name: "Tierra", urlImage: "tierra"),
                    ItemDetailImages(name: "Agua", urlImage: "agua"),
                    ItemDetailImages(name: "Fuego", urlImage: "fuego"),
                    ItemDetailImages(name: "Espiral", urlImage: "espiral")]
        itemInfoCasas.listDetailImages = listView
        itemInfoCasas.typeCellHotel = .cellStack
        itemInfoCasas.heighView = CGSize(width: 250, height: 250)
        
        //Habitaciones
        let itemInfoRooms = ItemInfoHotel()
        var listViewRooms = [ItemDetailImages]()
        itemInfoRooms.title = "lbl_title_rooms".getNameLabel()//"titleRooms".localized()
        itemInfoRooms.subtitle = "lbl_subtitle_rooms".getNameLabel()//"subtitleRooms".localized()
        listViewRooms = [ItemDetailImages(name: "SUITES", urlImage: "Hotel/hxc_suite"),
                    ItemDetailImages(name: "JR SUITES", urlImage: "Hotel/hxc_junior"),
                    ItemDetailImages(name: "SWIM UP", urlImage: "Hotel/hxc_swim_up"),
                    ItemDetailImages(name: "MASTER SUITE", urlImage: "Hotel/hxc_master_suite")]
        itemInfoRooms.listDetailImages = listViewRooms
        itemInfoRooms.typeCellHotel = .cellRooms
        itemInfoRooms.heighView = CGSize(width: 170, height: 190)
        
        //AllFunInclusive
        let itemInfoAFI = ItemInfoHotel()
        var listViewAFI = [ItemDetailImages]()
        itemInfoAFI.title = "lbl_title_AFI".getNameLabel()//"titleAFI".localized()
        itemInfoAFI.subtitle = "lbl_subtitle_AFI".getNameLabel()//"subtitleAFI".localized()
        listViewAFI = [ItemDetailImages(name: "", urlImage: "Logos/Hotel/xc"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xa"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xe"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xh"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xo"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xpf"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xp"),
                         ItemDetailImages(name: "", urlImage: "Logos/Hotel/xs")]
                         //Se Deshabilitaron x temas de que hotel ya no ofrece tours
                         //ItemDetailImages(name: "", urlImage: "Logos/Hotel/co"),
                         //ItemDetailImages(name: "", urlImage: "Logos/Hotel/xi")
        
        itemInfoAFI.listDetailImages = listViewAFI
        itemInfoAFI.typeCellHotel = .cellAFI
        itemInfoAFI.heighView = CGSize(width: 150, height: 50)
        
        //Address
        let itemInfoAddress = ItemInfoHotel()
        var listViewAddress = [ItemDetailImages]()
        itemInfoAddress.title = "lbl_title_location".getNameLabel()//"titleLocation".localized()
        itemInfoAddress.subtitle = appDelegate.itemParkSelected.detail.address
        listViewAddress = [ItemDetailImages(name: "Xcaret", urlImage: "Hotel/mapa")]
        itemInfoAddress.listDetailImages = listViewAddress
        itemInfoAddress.typeCellHotel = .cellAddress
        
        //Gastronomia
        let itemInfoGastronomy = ItemInfoHotel()
        var listViewGastronomy = [ItemDetailImages]()
        itemInfoGastronomy.title = "lbl_title_gastronomy".getNameLabel()//"titleGastronomy".localized()
        itemInfoGastronomy.subtitle = "lbl_subtitle_gastronomy".getNameLabel()//"subtitleGastronomy".localized()
        listViewGastronomy = [ItemDetailImages(name: "", urlImage: "Hotel/hxc_rest"),
                              ItemDetailImages(name: "", urlImage: "Hotel/hxc_rest1"),
                              ItemDetailImages(name: "", urlImage: "Hotel/hxc_rest2"),
                              ItemDetailImages(name: "", urlImage: "Hotel/hxc_rest3")]
        itemInfoGastronomy.listDetailImages = listViewGastronomy
        itemInfoGastronomy.typeCellHotel = .cellRooms
        itemInfoGastronomy.heighView = CGSize(width: 100, height: 50)
        
        //360
        let itemInfo360 = ItemInfoHotel()
        var listView360 = [ItemDetailImages]()
        itemInfo360.title = "lbl_title_spa".getNameLabel()//"titleSpa".localized()
        itemInfo360.subtitle = "lbl_subtitle_spa".getNameLabel()//"subtitleSpa".localized()
        listView360 = [ItemDetailImages(name: "", urlImage: "360/HX/spa")]
        itemInfo360.listDetailImages = listView360
        itemInfo360.typeCellHotel = .cell360
        itemInfo360.heighView = CGSize(width: 170, height: 170)
        
        //CallCenter
        let itemInfoCallCenter = ItemInfoHotel()
        itemInfoCallCenter.title = "lbl_title_contact_us".getNameLabel()//"titleContactUs".localized()
        itemInfoCallCenter.typeCellHotel = .cellCallCenter
        itemInfoCallCenter.heighView = CGSize(width: 0, height: 70)
        
        listInfo.append(contentsOf: [itemAppHotel, itemInfoCasas, itemInfoRooms, itemInfoAFI, itemInfoAddress, itemInfoGastronomy, itemInfo360, itemInfoCallCenter])
        
        completion(listInfo)
    }
    
    func getFiltersMapByPark(completion: ([ItemFilterMap]) -> Void){
        var listFMPark = [ItemFilterMap]()
        let filtersMapPark = appDelegate.listAllFilters.filter({ $0.f_keyPark == appDelegate.itemParkSelected.uid})
        
        for itemFMP in filtersMapPark {
            if (itemFMP.f_code.uppercased().contains("REST") || itemFMP.f_code.uppercased().contains("ALL")
                || itemFMP.f_code.uppercased().contains("ROUTES") || itemFMP.f_code.uppercased().contains("FAV")){
                itemFMP.typeEntity = .activities
            }else {
                itemFMP.typeEntity = .services
            }
            
            print("Parque = \(itemFMP.f_keyPark ?? "-") / Name: \(itemFMP.langs[0].name) / Tipo :  \(itemFMP.f_code!) - \(itemFMP.f_type!)")
            itemFMP.subFilter = [ItemSubFilter]()
            
            if itemFMP.f_type.uppercased().contains("BRANCH"){
                //Añadir los subfiltros correspondientes
                if itemFMP.f_code.uppercased().contains("ROUTES"){
                    for item in appDelegate.listAllRoutes {
                        if !item.r_code.contains("GENERAL"){
                            itemFMP.subFilter.append(ItemSubFilter(name: item.getName.name, sf_code: item.r_code, sf_icon: item.r_icon))
                        }
                    }
                }else{
                    //Vamos las subcategorias
                    if let item = appDelegate.listAllCategories.first(where: {$0.cat_code == itemFMP.f_code}){
                        print("-> Categorias \(item.uid!) \(item.cat_code!)")
                        let services = appDelegate.listAllServices.filter({$0.key_category == item.uid && $0.serv_keyPark == itemFMP.f_keyPark})
                        for serv in services {
                            print("Service Nombre : \(serv.getDetail.name) \(serv.serv_code!)")
                            itemFMP.subFilter.append(ItemSubFilter(name: serv.getDetail.name, sf_code: serv.serv_code, sf_icon: serv.serv_icon))
                        }
                    }
                }
            }
            print("--> SubFiltros: \(itemFMP.subFilter.count)")
            listFMPark.append(itemFMP)
        }
        completion(listFMPark)
    }
    
    func getCodePromo(inPark: Bool, completion: @escaping (ItemCupon) -> Void){
        print("InPark : \(inPark)")
        var itemCupon : ItemCupon = ItemCupon()
        
        if let currentCode = appDelegate.listCupons.first(where: { $0.insidePark == inPark}){
            itemCupon = currentCode
        }else{
            if let currentCodeOut = appDelegate.listCupons.first(where: { $0.insidePark == true}){
                itemCupon = currentCodeOut
            }
        }
        appDelegate.itemCuponActive = itemCupon
        completion(itemCupon)
    }
    
    func getRestaurants(completion: @escaping ([ItemActivity]) -> Void){
        var listRestaurants : [ItemActivity] = [ItemActivity]()
        let listAllactivities : [ItemActivity] = appDelegate.listActivitiesByPark
        let filterRest : [ItemActivity] = listAllactivities.filter({ $0.category.cat_code == "REST"})
        if filterRest.count > 0 {
            listRestaurants = filterRest
        }
        completion(listRestaurants)
    }
    
    func getFavorites(completion: @escaping ([ItemActivity]) -> Void){
        var listActFavorites : [ItemActivity] = [ItemActivity]()
        let listFavorites = appDelegate.listFavoritesByPark
        let listActivities = appDelegate.listActivitiesByPark
        
        for itemFav in listFavorites {
            if let act = listActivities.first(where: {$0.uid == itemFav.uid}){
                listActFavorites.append(act)
            }
        }
        completion(listActFavorites)
    }
    
    func getActivitiesByCategory(activity: ItemActivity, completion: @escaping (ItemHome) -> Void){
        let listAllActivities = appDelegate.listActivitiesByPark
        var esentialActivities = [ItemActivity]()
        let itemDetailAct = ItemHome()
        if activity.category.cat_code == "REST"{
            itemDetailAct.name = String(format: "lblTitleSubcategory".localized(), activity.getSubcategory.name)
            esentialActivities = listAllActivities.filter({$0.subcategory.scat_code == activity.subcategory.scat_code && $0.category.cat_code == "REST" && $0.uid != activity.uid})
        }else{
            itemDetailAct.name = String(format: "lblTitleSubcategory".localized(), activity.getCategory.name)
            esentialActivities = listAllActivities.filter({$0.category.cat_code == activity.category.cat_code && $0.uid != activity.uid})
        }
        
        
        itemDetailAct.description = ""
        itemDetailAct.listActivities = esentialActivities
        itemDetailAct.sizeCell = CGSize(width: 150, height: 260)
        itemDetailAct.heightCV = 260
        itemDetailAct.typeCell = .cellActivity
        itemDetailAct.lineisHide = true
        
        completion(itemDetailAct)
    }
    
    func searchActivitiesByName(searchText: String, completion: ([ItemActivity]) -> Void){
        var listSearchActivities : [ItemActivity] = [ItemActivity]()
        var listAllActivities : [ItemActivity] = [ItemActivity]()
        if appDelegate.optionsHome{
            listAllActivities = appDelegate.listAllActivities
        }else{
            listAllActivities = appDelegate.listActivitiesByPark
        }
        
        if !searchText.isEmpty {
            AnalyticsBR.shared.search(query: searchText)
            listSearchActivities = listAllActivities.filter({ $0.details.name.lowercased().contains(searchText) || $0.getRoute.name.lowercased().contains(searchText) || $0.getRoute.color.lowercased().contains(searchText) || $0.act_tagsSearch.lowercased().contains(searchText) || $0.numberMap.contains(searchText) })
        }
        completion(listSearchActivities)
    }
    
    
    func searchActivitiesHome(searchText: String, completion: ([ItemActivity]) -> Void){
        var listSearchActivities : [ItemActivity] = [ItemActivity]()
        let listAllActivities = appDelegate.listAllActivities
        if !searchText.isEmpty {
            AnalyticsBR.shared.search(query: searchText)
            listSearchActivities = listAllActivities.filter({ $0.details.name.lowercased().contains(searchText) || $0.getRoute.name.lowercased().contains(searchText) || $0.getRoute.color.lowercased().contains(searchText) || $0.act_tagsSearch.lowercased().contains(searchText) || $0.numberMap.contains(searchText) })
        }
        completion(listSearchActivities)
    }
    
    func getInfoByPark(key: String, completion: @escaping (ItemPark) -> Void){
        var itemPark: ItemPark = ItemPark()
        let listAllParks = appDelegate.listAllParksEnabled
        if !key.isEmpty {
            if let item = listAllParks.first(where: {$0.code == key}){
                itemPark = item
            }
        }
        completion(itemPark)
    }
    
    func getLegalByCode(code: String, completion: @escaping (ItemLegal) -> Void){
        var itemLegal : ItemLegal = ItemLegal()
        let listAllLegals = appDelegate.listLegals
        if let item = listAllLegals.first(where: {$0.code == code}){
            itemLegal = item
        }
        completion(itemLegal)
    }
    
    
    func getAlbums(completion:@escaping () -> Void){
        FirebaseDB.shared.getAlbumByUser { (listAlbum) in
            completion()
        }
    }
    
    func getStatusAlbumDetail(code: String, uidAlbumDet: String, totalMediaReal: Int, completion: @escaping (ItemAlbumDetail) -> Void){
        FirebaseDB.shared.getItemAlbum(code: code, uidAlbumDet: uidAlbumDet) { (albumDetail) in
            if albumDetail.totalMedia != totalMediaReal {
                FirebaseDB.shared.updateTotalMedia(codeAlbum: code, uidAlbumDet: uidAlbumDet, totalmedia: totalMediaReal, completion: { (save) in
                    print("mas fotos")
                    completion(albumDetail)
                })
            }else{
                completion(albumDetail)
            }
        }
    }
    
    func validateAlbum(album : ItemAlbum, completion: (Bool)-> Void){
        let listAllAlbum = appDelegate.listAlbum
        if let item = listAllAlbum.first(where: {$0.code == album.code}){
            print("Ya está registrado el album \(item.code!)")
            FirebaseDB.shared.updatePhotoAlbum(itemAlbum: album, listAllAlbumFB: item) { (sucess) in
                completion(true)
            }
        }else{
            FirebaseDB.shared.saveAlbumByUser(itemAlbum: album) { (save) in
                if save{
                    print("Se guardó en Firebase")
                }
                completion(save)
            }
        }
    }
    
    func updateStatusAlbum(album : ItemAlbum, completion: (Bool)-> Void){
        let listAllAlbum = appDelegate.listAlbum
        if let item = listAllAlbum.first(where: {$0.code == album.code}){
            print("Ya está registrado el album \(item.code!)")
            FirebaseDB.shared.updatePhotoAlbum(itemAlbum: album, listAllAlbumFB: item) { (sucess) in
                completion(true)
            }
        }else{
            FirebaseDB.shared.saveAlbumByUser(itemAlbum: album) { (save) in
                if save{
                    print("Se guardó en Firebase")
                }
                completion(save)
            }
        }
    }
    
    func getSectionsGeneral(completion: @escaping ([ItemMenu]) -> Void){
        
        
            var listMenu = [ItemMenu]()
            listMenu.append(ItemMenu(name: "titlePhotos", code: "photopass", icon: "", listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_change_lang".getNameLabel()/*"lblChangeLang".localized()*/, code: "change", icon: "Icons/svg/ic_idioma", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_phone".getNameLabel()/*"lblPhone".localized()*/, code: "phone", icon: "Icons/svg/ico_telefono", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_email".getNameLabel()/*"lblEmail".localized()*/, code: "email", icon: "Icons/svg/ico_correo", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_review_app".getNameLabel()/*"lblReviewApp".localized()*/, code: "review", icon: "Icons/svg/ico_rate", separatorHidden: false, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_hotel_app".getNameLabel()/*"lblReviewApp".localized()*/, code: "download_hotel", icon: "Icons/svg/ic_app_hotel", separatorHidden: false, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_terms".getNameLabel()/*"lblTerms".localized()*/, code: "terms", icon: "Icons/svg/ico_terminos_uso", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_policies".getNameLabel()/*"lblPolicies".localized()*/, code: "policy", icon: "Icons/svg/ico_politicas_privacidad", listSubmenu: [ItemSubmenu]()))
            listMenu.append(ItemMenu(name: "lbl_return_parks".getNameLabel()/*"lblReturnParks".localized()*/, code: "home", icon: "Icons/svg/ic_parques", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            /*let updateApp = AppUserDefaults.value(forKey: .ExistUpdateApp).boolValue
            if updateApp {
                let itemUpdate = ItemMenu(name: "lblUpdate".localized(), code: "update", icon: "Icons/svg/ico_logout", listSubmenu: [ItemSubmenu]())
                listMenu.append(itemUpdate)
            }*/
            //Validamos si es un usuario anonimo
            let provider = AppUserDefaults.value(forKey: .UserProvider, fallBackValue: "Firebase")
            if provider != "Firebase" {
                listMenu.append(ItemMenu(name: "lbl_logout".getNameLabel()/*"lblLogout".localized()*/, code: "logout", icon: "Icons/svg/ico_logout", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            }else{
                listMenu.append(ItemMenu(name: "btn_create_account".getNameLabel()/*"lblSignup".localized()*/, code: "signup", icon: "Icons/svg/ic_cuenta", separatorHidden: true, listSubmenu: [ItemSubmenu]()))
            }
            completion(listMenu)
    
        
    }
    
    func getListInfoHome(keyPark: String, completion: @escaping ([ItemHome]) -> Void){
        
        let itemParkSelect = appDelegate.itemParkSelected
        let listAllActivities = self.appDelegate.listAllActivities.filter({ $0.act_keyPark == itemParkSelect.uid})//appDelegate.listActivitiesByPark
//        let aux = appDelegate.listEvents
        let listAllEvents = appDelegate.listEvents//appDelegate.listEvents.filter({ $0.key_park == keyPark})
        let listAllParks = appDelegate.listAllParksEnabled//appDelegate.listAllParks
        var listHome = [ItemHome]()
        
        //Creamos los más nuevos
        let newActivities = listAllActivities.filter({ $0.act_new == true}).sorted(by: { $0.act_order < $1.act_order })
        let itemNews = ItemHome()                                           
        itemNews.name = "\(keyPark.lowercased())_lbl_new".getNameLabel()//"lblNew\(keyPark)".localized()
        if keyPark.lowercased() == "xs"{
            itemNews.name = "xs_lbl_new_icon".getNameLabel()//"lblNew\(keyPark)".localized()
        }
        itemNews.listActivities = newActivities
        itemNews.sizeCell = CGSize(width: 150, height: 170)
        itemNews.heightCV = 170
        itemNews.typeCell = .cellActivity
        itemNews.idEventFB = "listNew"
        
        //Creamos itemMapa
        let itemMap = ItemHome()
        itemMap.isMap = true
        itemMap.typeCell = .cellMap
        itemMap.itemPark.code = keyPark.lowercased()
        
        //Creamos actividades escenciales
        let itemEscentials = ItemHome()
        let esentialActivities = listAllActivities.filter({ $0.category.cat_code == "AESEN"}).sorted(by: { $0.act_order < $1.act_order })
        itemEscentials.name = "lbl_act_essentials".getNameLabel()//"lblActEssentials".localized()
        itemEscentials.description = "lbl_desc_act_essentials".getNameLabel()//"descActEssentials".localized()
        itemEscentials.listActivities = esentialActivities
        itemEscentials.sizeCell = CGSize(width: 130, height: 220)
        itemEscentials.heightCV = 220
        itemEscentials.typeCell = .cellActivity
        itemEscentials.idEventFB = "listMustDo"
        
        //Creamos Restaurantes
        let itemRestaurants = ItemHome()
        let restActivities = listAllActivities.filter({ $0.category.cat_code == "REST"}).sorted(by: { $0.act_order < $1.act_order })
        itemRestaurants.name = "lbl_restaurant".getNameLabel()
        itemRestaurants.description = ""
        itemRestaurants.listActivities = restActivities
        itemRestaurants.sizeCell = CGSize(width: 150, height: 160)
        itemRestaurants.heightCV = 190
        itemRestaurants.typeCell = .cellRestaurants
        itemRestaurants.idEventFB = "goRestaurant"
        
        //Atractivos por descubrir
        let itemDiscover = ItemHome()
        let discoverActivities = listAllActivities.filter({ $0.category.cat_code == "ADISC"}).sorted(by: { $0.act_order < $1.act_order })
        itemDiscover.name = "lbl_act_descubrir".getNameLabel()//"lblActDescubrir".localized()
        itemDiscover.description = ""
        itemDiscover.listActivities = discoverActivities
        itemDiscover.sizeCell = CGSize(width: 130, height: 220)
        itemDiscover.heightCV = 230
        itemDiscover.typeCell = .cellActivity
        itemDiscover.idEventFB = "listAttractions"
        
        //Actividades extraordinarias
        let itemExtra = ItemHome()
        let extraActivities = listAllActivities.filter({ $0.category.cat_code == "AEXT"}).sorted(by: { $0.act_order < $1.act_order })
        itemExtra.name = "lbl_act_extra".getNameLabel()//"lblActExtra".localized()
        itemExtra.description = "\(keyPark)_desc_act_extra".lowercased().getNameLabel()//"descActExtra\(keyPark)".localized()
        itemExtra.listActivities = extraActivities
        itemExtra.sizeCell = CGSize(width: 170, height: 230)
        itemExtra.heightCV = 240
        itemExtra.typeCell = .cellExtra
        itemExtra.idEventFB = "listExtraordinary"
        
        //Actividades para Xenses
        let itemConSin = ItemHome()
        let conSinActivities = listAllActivities.filter({ $0.category.cat_code == "SINSENT" || $0.category.cat_code == "CONSENT" || $0.category.cat_code == "GENERAL"}).sorted(by: { $0.act_order < $1.act_order }) // Cambiar por el codigo correspondiente
        itemConSin.listActivities = conSinActivities
        itemConSin.sizeCell = CGSize(width: 100, height: 220)
        itemConSin.heightCV = 240
        itemConSin.typeCell = .cellConSin
        
        //Actividades extraordinarias
        let itemPresentations = ItemHome()
        let presentationsActivities = listAllActivities.filter({ $0.category.cat_code == "SHOWS"}).sorted(by: { $0.act_order < $1.act_order })
        itemPresentations.name = "lbl_presentations".getNameLabel()//"lblPresentations".localized()
        itemPresentations.description = "lbl_desc_presentations".getNameLabel()//"descPresentations".localized()
        itemPresentations.listActivities = presentationsActivities
        itemPresentations.sizeCell = CGSize(width: 130, height: 220)
        itemPresentations.heightCV = 230
        itemPresentations.typeCell = .cellActivity
        itemPresentations.idEventFB = "listPerformance"
        
        //Creamos actividades basicas Xavage
        let itemActBasics = ItemHome()
        let actBasicsActivities = listAllActivities.filter({ $0.category.cat_code == "BASIC"}).sorted(by: { $0.act_order < $1.act_order })
        itemActBasics.name = "lbl_basic_activities".getNameLabel()//"lblBasicActivities".localized()
        itemActBasics.description = "lbl_basic_activities_desc".getNameLabel()//"lblBasicActivitiesDesc".localized()
        itemActBasics.listActivities = actBasicsActivities
        itemActBasics.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 3) * 0.98, height: 230)
        itemActBasics.heightCV = 230
        itemActBasics.typeCell = .cellbasicXV
        itemActBasics.idEventFB = "listMustDo"
        
        //Creamos Restaurantes para Xavage
        let itemRestaurantes = ItemHome()
        let restaurantes = listAllActivities.filter({ $0.category.cat_code == "REST"}).sorted(by: { $0.act_order < $1.act_order })
        itemRestaurantes.name = "lbl_food_and_beverages".getNameLabel()//lblFoodAndBeverages".localized()
        itemRestaurantes.listActivities = restaurantes
        itemRestaurantes.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2) * 0.97, height: (UIScreen.main.bounds.width / 2) * 0.97)
        itemRestaurantes.heightCV = (UIScreen.main.bounds.width / 2) * 0.98
        itemRestaurantes.typeCell = .cellActivity
        itemRestaurantes.idEventFB = "listMustDo"
        
        //Actividades All Inclusive Xavage
        let itemAllInclusiveXavage = ItemHome()
        let AllInclusiveXavageActivities = listAllActivities.filter({ $0.category.cat_code == "XTREME"}).sorted(by: { $0.act_order < $1.act_order })
        itemAllInclusiveXavage.name = "lbl_more_exciting_activities".getNameLabel()//"lblMoreExcitingActivities".localized()
        itemAllInclusiveXavage.description = "lbl_more_exciting_activities_desc".getNameLabel()//"lblMoreExcitingActivitiesDesc".localized()
        itemAllInclusiveXavage.listActivities = AllInclusiveXavageActivities
        itemAllInclusiveXavage.sizeCell = CGSize(width: 220, height: 235)
        itemAllInclusiveXavage.heightCV = 240
        itemAllInclusiveXavage.typeCell = .cellAllInclusiveXV
        itemAllInclusiveXavage.idEventFB = "listMustDo"
        
        //Creamos Tipos de entrada
        let itemTipoEntrada = ItemHome()
        if listAllActivities.count > 0{
            let TipoEntradaActivities = appDelegate.listAdmissions.filter({ $0.key_park == listAllActivities[0].act_keyPark}).sorted(by: { $0.ad_order < $1.ad_order })
            itemTipoEntrada.listAdmissions = TipoEntradaActivities
        }
        itemTipoEntrada.name = "lbl_choose_your_admissio_titlen".getNameLabel()//"lblChooseYourAdmissioTitlen".localized()
//        guard itemTipoEntrada.listAdmissions = appDelegate.listAdmissions.filter({ $0.key_park == listAllActivities[0].act_keyPark}).sorted(by: { $0.ad_order < $1.ad_order }) else { return }
        itemTipoEntrada.sizeCell = CGSize(width: UIScreen.main.bounds.width * 0.90, height: 550)
        itemTipoEntrada.heightCV = 550
        itemTipoEntrada.typeCell = .cellTipoEntrada
        itemTipoEntrada.idEventFB = "listMustDo"
        
        
        //Creamos actividades aereas de XP
        let itemActAir = ItemHome()
        let actAirActivities = listAllActivities.filter({ $0.category.cat_code == "AIR"}).sorted(by: { $0.act_order < $1.act_order })
        itemActAir.name = "lbl_aerial_activities".getNameLabel()//"lblAerialTitle\(keyPark)".localized()
        itemActAir.description = "\(keyPark.lowercased())_lbl_aerial_activities_des".getNameLabel()//"lblAerialDesc\(keyPark)".localized()
        itemActAir.listActivities = actAirActivities
        itemActAir.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2) * 0.97, height: 230)
        itemActAir.heightCV = 230
        itemActAir.typeCell = .cellbasicXV
        itemActAir.idEventFB = "listMustDo"
        
        //Creamos actividades terrestres de XP
        let itemActLand = ItemHome()
        let actLandActivities = listAllActivities.filter({ $0.category.cat_code == "LAND"}).sorted(by: { $0.act_order < $1.act_order })
        itemActLand.name = "lbl_land_activities".getNameLabel()//"lblLandTitle\(keyPark)".localized()
        itemActLand.description = "\(keyPark.lowercased())_lbl_land_activities_des".getNameLabel()//"lblLandDesc\(keyPark)".localized()
        itemActLand.listActivities = actLandActivities
        itemActLand.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2) * 0.97, height: 230)
        itemActLand.heightCV = 230
        itemActLand.typeCell = .cellbasicXV
        itemActLand.idEventFB = "listMustDo"
        
        //Creamos actividades Subterráneas de XP
        let itemActUnderground = ItemHome()
        let actUndergroundActivities = listAllActivities.filter({ $0.category.cat_code == "UNDERGROUND"}).sorted(by: { $0.act_order < $1.act_order })
        itemActUnderground.name = "lbl_underground_activities".getNameLabel()//"lblUndergroundTitle\(keyPark)".localized()
        itemActUnderground.description = "\(keyPark.lowercased())_lbl_underground_activities_des".getNameLabel()//"lblUndergroundDesc\(keyPark)".localized()
        itemActUnderground.listActivities = actUndergroundActivities
        itemActUnderground.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2) * 0.97, height: 230)
        itemActUnderground.heightCV = 230
        itemActUnderground.typeCell = .cellbasicXV
        itemActUnderground.idEventFB = "listMustDo"
        
        //Creamos Eventos
        let itemEvents = ItemHome()
        itemEvents.name = "xo_lbl_events".getNameLabel()//"lblTitlEventsKMXO".localized()
        itemEvents.listEvents = listAllEvents.sorted(by: { $0.ev_order < $1.ev_order })
        itemEvents.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2) * 0.97, height: (UIScreen.main.bounds.width / 2) * 0.97)
        itemEvents.heightCV = (UIScreen.main.bounds.width / 2) * 0.97
        itemEvents.typeCell = .cellEvents
        itemEvents.idEventFB = "listMustDo"
        
        //Creamos Kermes con fotos para XO
        let itemKerMexIMG = ItemHome()
        itemKerMexIMG.listActivities = listAllActivities.filter({$0.category.cat_code == "KERMES"}).sorted(by: { $0.act_latitude < $1.act_latitude })
        itemKerMexIMG.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.93, height: 350)
        itemKerMexIMG.heightCV = 350
        itemKerMexIMG.typeCell = .cellXOKerMexIMG
        itemKerMexIMG.idEventFB = "listMustDo"
        
        
        let itemKermesMexicana = ItemHome()
        itemKermesMexicana.listActivities = listAllActivities.filter({$0.category.cat_code == "COMPONENT"}).sorted(by: { $0.act_latitude < $1.act_latitude })
        itemKermesMexicana.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.70, height: 290)
        itemKermesMexicana.heightCV = 290
        itemKermesMexicana.typeCell = .cellXOKermesMexicana
        itemKermesMexicana.idEventFB = "listMustDo"
        
        let itemXoMenu = ItemHome()
        itemXoMenu.name = "lbl_food_and_beverages".getNameLabel()//"lblFoodAndBeverages".localized()
        itemXoMenu.listActivities = listAllActivities.filter({$0.category.cat_code != "COMPONENT" && $0.category.cat_code != "KERMES"}).sorted(by: { $0.act_latitude < $1.act_latitude })
        itemXoMenu.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.90, height: 520)
        itemXoMenu.heightCV = 520
        itemXoMenu.typeCell = .cellXOMenu
        itemXoMenu.idEventFB = "listMustDo"
        
        //Titulo Xenotes
        let itemTitleXenotes  = ItemHome()
        itemTitleXenotes.name = itemParkSelect.name
        itemTitleXenotes.subTitle = itemParkSelect.detail.slogan
        itemTitleXenotes.description = itemParkSelect.detail.description
        itemTitleXenotes.sizeCell = CGSize(width: 0, height: 70)
        itemTitleXenotes.typeCell = .cellTitleXN
        
        //Actividades Xenotes
        let itemActividadesXenotes = ItemHome()
        itemActividadesXenotes.name = "xn_lbl_activities_title".getNameLabel()//"lblTitleActividadesXN".localized()
        itemActividadesXenotes.description = "xn_lbl_activities_des".getNameLabel()//"lblTitleDescriptionXN".localized()
        itemActividadesXenotes.listActivities = listAllActivities.filter({$0.category.cat_code == "ACTIVITY"}).sorted(by: { $0.act_order < $1.act_order })
        itemActividadesXenotes.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.70, height: (UIScreen.main.bounds.width) * 0.81)
        itemActividadesXenotes.heightCV = (UIScreen.main.bounds.width) * 0.81
        itemActividadesXenotes.typeCell = .cellActivityBasic
        itemActividadesXenotes.idEventFB = "listMustDo"
        
        //Tipos Xenotes
        let itemTiposXenotes = ItemHome()
        itemTiposXenotes.name = "xn_lbl_cenotes_title".getNameLabel()//"lblTitleTiposXN".localized()
        itemTiposXenotes.description = "xn_lbl_cenotes_des".getNameLabel()//"lblTitleTiposDescriptionXN".localized()
        itemTiposXenotes.listActivities = listAllActivities.filter({$0.category.cat_code == "CENOTE"}).sorted(by: { $0.act_order < $1.act_order })
        itemTiposXenotes.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.70, height: (UIScreen.main.bounds.width) * 0.82)
        itemTiposXenotes.heightCV = (UIScreen.main.bounds.width) * 0.82
        itemTiposXenotes.typeCell = .cellActivityBasic
        itemTiposXenotes.idEventFB = "listMustDo"
        
        //Awards Xenotes
        let itemAwardXenotes = ItemHome()
        itemAwardXenotes.name = "lbl_title_awards".getNameLabel()//"lblTitleAwards".localized()
        if itemParkSelect.listAwards != nil{
           itemAwardXenotes.listAwards = itemParkSelect.listAwards
        }
        itemAwardXenotes.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.80, height: (UIScreen.main.bounds.width) * 0.80)
        itemAwardXenotes.heightCV = (UIScreen.main.bounds.width) * 0.80
        itemAwardXenotes.typeCell = .cellAwardXenotes
        itemAwardXenotes.idEventFB = "listMustDo"
        
        //Recomendaciones Xenotes
        let itemRecomendacionesXenotes  = ItemHome()
        itemRecomendacionesXenotes.itemPark = itemParkSelect
        itemRecomendacionesXenotes.sizeCell = CGSize(width: (UIScreen.main.bounds.width), height: 230)
        itemAwardXenotes.heightCV = 230
        itemRecomendacionesXenotes.typeCell = .cellRecomendacionesXN
        
        //Creamos Eventos Xichen
        let itemEventsXI = ItemHome()
        itemEventsXI.name = "xi_lbl_activities_titlle".getNameLabel()//"lblTitleActivitiesXI".localized()
        itemEventsXI.description = "xi_lbl_activities_des".getNameLabel()//"lblDescriptionActivitiesXI".localized()
        itemEventsXI.listActivities = listAllActivities.filter({$0.category.cat_code != "VALLADOLID"}).sorted(by: { $0.act_order < $1.act_order })
        itemEventsXI.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.85, height: (UIScreen.main.bounds.width) * 0.70)
        itemEventsXI.heightCV = (UIScreen.main.bounds.width) * 0.70
        itemEventsXI.typeCell = .cellEventsXI
        itemEventsXI.idEventFB = "listMustDo"
        
        //Creamos Cenotes Xichen
        let itemCenotesXI = ItemHome()
        itemCenotesXI.name = "xi_lbl_cenotes_title".getNameLabel()//"lblTitleCenotesXI".localized()
        itemCenotesXI.description = "xi_lbl_cenotes_des".getNameLabel()//"lblDescriptionCenotesXI".localized()
        itemCenotesXI.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.976, height: (UIScreen.main.bounds.width) * 0.70)
        itemCenotesXI.heightCV = (UIScreen.main.bounds.width) * 0.70
        itemCenotesXI.typeCell = .cellCenoteXI
        itemCenotesXI.idEventFB = "listMustDo"
        
        //Creamos Valladolid Xichen
        let itemValladolidXi = ItemHome()
        itemValladolidXi.name = "xi_lbl_valladolid_title".getNameLabel()//"lblTitleValladolidXI".localized()
        itemValladolidXi.description = "xi_lbl_valladolid_des".getNameLabel()//"lblDescriptionValladolidXI".localized()
        itemValladolidXi.listActivities = listAllActivities.filter({$0.category.cat_code == "VALLADOLID"}).sorted(by: { $0.act_order < $1.act_order })
        itemValladolidXi.sizeCell = CGSize(width: (UIScreen.main.bounds.width) * 0.85, height: (UIScreen.main.bounds.width) * 0.70)
        itemValladolidXi.heightCV = (UIScreen.main.bounds.width) * 0.70
        itemValladolidXi.typeCell = .cellActivityBasic
        itemValladolidXi.idEventFB = "listMustDo"
        
        
        //Address Xichen
        let itemInfoAddress = ItemHome()
        itemInfoAddress.name = "lbl_title_location".getNameLabel()//"titleLocation".localized()
        itemInfoAddress.description = itemParkSelect.detail.address
        itemInfoAddress.itemPark = itemParkSelect
        itemInfoAddress.typeCell = .cellAddress
        itemInfoAddress.sizeCell = CGSize(width: 0, height: 300)
        
        //Recomendaciones Xenotes
        let itemRecomendacionesXI  = ItemHome()
        itemRecomendacionesXI.subTitle = "lbl_recommendations".getNameLabel()//"lblRecommendations".localized()
        itemRecomendacionesXI.description = itemParkSelect.detail.recomendations
        itemRecomendacionesXI.sizeCell = CGSize(width: 0, height: 70)
        itemRecomendacionesXI.typeCell = .cellTitleXN
        
        //Boton ver todos
        let itemSeeAll  = ItemHome()
        itemSeeAll.name = "lbl_see_all".getNameLabel()//"lblAll".localized()
        itemSeeAll.typeCell = .cellSeeAll
        
        let itemCallCenter = ItemHome()
        itemCallCenter.name = "HolaMundo"
        itemCallCenter.typeCell = .cellCallCenter
        itemCallCenter.sizeCell = CGSize(width: 0, height: 100)
        if keyPark == "XV"{
            itemCallCenter.sizeCell = CGSize(width: 0, height: 70)
        }
        
        let itemInfoPark = ItemHome()
        itemInfoPark.name = "\("lbl_booking".getNameLabel())"//"lblBooking".localized()
        itemInfoPark.typeCell = .cellInfoPark
        itemInfoPark.sizeCell = CGSize(width: 0, height: 70)
        if keyPark == "XV" {
            itemInfoPark.sizeCell = CGSize(width: 0, height: 80)
        }
        if keyPark == "XO" {
            itemInfoPark.sizeCell = CGSize(width: 0, height: 67)
        }
        
        let itemSwichXP = ItemHome()
        itemSwichXP.name = "lbl_booking".getNameLabel()//"lblBooking".localized()
        itemSwichXP.typeCell = .cellSwichXP
        itemSwichXP.sizeCell = CGSize(width: 0, height: 200)
        
        /*Creamos Programa de mano*/
        let itemProgramaDeMano = ItemHome()
//        itemProgramaDeMano.name = "lblBooking".localized()
        itemProgramaDeMano.typeCell = .cellProgramaMano
        itemProgramaDeMano.sizeCell = CGSize(width: UIScreen.main.bounds.width, height: 200)
        
        let itemTitleDescCerrado  = ItemHome()
        itemTitleDescCerrado.itemPark = itemParkSelect
        itemTitleDescCerrado.name = "lbl_close_title_enjoy_our_park".getNameLabel()//"titleDescCerradoName".localized()
        itemTitleDescCerrado.description = "lbl_close_description_enjoy_our_park".getNameLabel()//"titleDescCerradoDescription".localized()
        itemTitleDescCerrado.sizeCell = CGSize(width: 0, height: 70)
        itemTitleDescCerrado.typeCell = .cellTitleXN
        
        let itemTitleDescAbierto  = ItemHome()
        itemTitleDescAbierto.itemPark = itemParkSelect
        itemTitleDescAbierto.name = "lbl_title_enjoy_our_park".getNameLabel()//"titleDescAbiertoName".localized()
        itemTitleDescAbierto.description = "lbl_description_enjoy_our_park".getNameLabel()//"titleDescAbiertoDescription".localized()
        itemTitleDescAbierto.sizeCell = CGSize(width: 0, height: 70)
        itemTitleDescAbierto.typeCell = .cellTitleXN
        
        
        //HOME
        let itemPrefPark = listAllParks.filter({ $0.home_preference == true}).sorted(by: {$0.order < $1.order})
        let parksPref = ItemHome()
        parksPref.name = "\(keyPark)_lbl_new".getNameLabel()
        parksPref.parksHome = itemPrefPark
        parksPref.sizeCell = CGSize(width: UIScreen.main.bounds.width * 0.92, height: (UIScreen.main.bounds.height - 60) * 0.68)
        parksPref.heightCV = (UIScreen.main.bounds.height - 60.0) * 0.68
        parksPref.typeCell = .cellPrefHome
        parksPref.idEventFB = "cellPrefHome"
        
        
        let itemPark = listAllParks.filter({ $0.home_preference == false}).sorted(by: {$0.order < $1.order})
        let parks = ItemHome()
        parks.name = "\(keyPark)_lbl_new".getNameLabel()
        parks.parksHome = itemPark
        parks.sizeCell = CGSize(width: 105, height: 140)
        parks.heightCV = 140
        parks.typeCell = .cellHome
        parks.idEventFB = "cellHome"
        
        //Items Xailing
        
        let itemInfoParkXA = ItemHome()
        itemInfoParkXA.name = "\("lbl_booking".getNameLabel())"
        itemInfoParkXA.typeCell = .cellInfoParkShort
        itemInfoParkXA.sizeCell = CGSize(width: 0, height: 70)
        
        let itemAddmisionXA = ItemHome()
        let listAddmisionXA = appDelegate.listAdmissions.filter({ $0.key_park == itemParkSelect.uid }).sorted(by: { $0.ad_order < $1.ad_order })
        itemAddmisionXA.listAdmissions = listAddmisionXA
        itemAddmisionXA.sizeCell = CGSize(width: UIScreen.main.bounds.width * 0.90, height: 550)
        itemAddmisionXA.heightCV = 550
        itemAddmisionXA.name = "xa_lbl_travel_withus".getNameLabel()
        itemAddmisionXA.typeCell = .cellTipoEntrada
        itemAddmisionXA.idEventFB = "listAdmission"
        
        //MustDo Xailing
        let itemActBasicsXA = ItemHome()
        let actBasicsActivitiesXA = listAllActivities.filter({ $0.category.cat_code == "BASIC"}).sorted(by: { $0.act_order < $1.act_order })
        itemActBasicsXA.name = "xa_lbl_activities".getNameLabel()//"lblBasicActivities".localized()
        itemActBasicsXA.description = "xa_lbl_activities_desc".getNameLabel()//"lblBasicActivitiesDesc".localized()
        itemActBasicsXA.listActivities = actBasicsActivitiesXA
        itemActBasicsXA.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2.3) , height: (UIScreen.main.bounds.width / 2.3))
        itemActBasicsXA.heightCV = (UIScreen.main.bounds.width / 2.3)
        itemActBasicsXA.typeCell = .cellbasicXV
        itemActBasicsXA.idEventFB = "listMustDo"
        
        // Items Ferries
        let listAddmisionFE = appDelegate.listAdmissions.filter({ $0.key_park == itemParkSelect.uid }).sorted(by: { $0.ad_order < $1.ad_order })
        
        let itemInfoParkFE = ItemHome()
        itemInfoParkFE.listAdmissions = listAddmisionFE
        itemInfoParkFE.name = "\("lbl_booking".getNameLabel())"
        itemInfoParkFE.typeCell = .cellInfoParkShort
        itemInfoParkFE.sizeCell = CGSize(width: 0, height: 70)
        
        let itemTablePriceFE = ItemHome()
        itemTablePriceFE.listAdmissions = listAddmisionFE
        itemTablePriceFE.name = "\("lbl_booking".getNameLabel())"
        itemTablePriceFE.typeCell = .cellPriceTableFE
        itemTablePriceFE.sizeCell = CGSize(width: 0, height: 70)
        
        let itemInfoBuy = ItemHome()
        itemInfoBuy.itemPark = itemParkSelect
        itemInfoBuy.name = "fe_ticket_sale_title".getNameLabel()
        itemInfoBuy.description = "fe_ticket_sale_desc".getNameLabel()
        itemInfoBuy.typeCell = .cellTitleXN
        itemInfoBuy.sizeCell = CGSize(width: 0, height: 70)
        
        let itemScheduleFerry = ItemHome()
        let actBasicsFerries = listAllActivities.filter({ $0.category.cat_code == "BASIC"}).sorted(by: { $0.act_order < $1.act_order })
        itemScheduleFerry.listAdmissions = listAddmisionFE
        itemScheduleFerry.name = "xa_lbl_activities".getNameLabel()//"lblBasicActivities".localized()
        itemScheduleFerry.description = "xa_lbl_activities_desc".getNameLabel()//"lblBasicActivitiesDesc".localized()
        itemScheduleFerry.listActivities = actBasicsFerries
        itemScheduleFerry.sizeCell = CGSize(width: (UIScreen.main.bounds.width / 2.3) , height: (UIScreen.main.bounds.width / 2.3))
        itemScheduleFerry.heightCV = (UIScreen.main.bounds.width / 2.3)
        itemScheduleFerry.typeCell = .cellScheduleAdmission
        itemScheduleFerry.idEventFB = "listMustDo"
        
        let itemLocationFerry = ItemHome()
        itemLocationFerry.name = "fe_lbl_activities".getNameLabel()
        itemLocationFerry.description = "fe_activities_desc".getNameLabel()
        itemLocationFerry.typeCell = .cellLocation
        
        switch keyPark {
        case "HOME":
            listHome.append(contentsOf: [parksPref, parks])
        case "XC":
            listHome.append(contentsOf: [itemNews, itemInfoPark, itemMap, itemProgramaDeMano,itemEscentials, itemRestaurants, itemDiscover, itemExtra, itemPresentations, itemSeeAll, itemCallCenter])
        case "XH":
            listHome.append(contentsOf: [itemEscentials, itemInfoPark, itemMap, itemDiscover, itemRestaurants, itemExtra, itemSeeAll, itemCallCenter])
        case "XS":
            let XSPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XS"}).first
            if XSPark!.buy_status {
                listHome.append(contentsOf: [itemTitleDescAbierto, itemNews, itemInfoPark, itemMap, itemConSin, itemRestaurants, itemSeeAll, itemCallCenter])
            }else{
                listHome.append(contentsOf: [itemTitleDescCerrado, itemNews, itemInfoPark, itemMap, itemConSin, itemRestaurants, itemSeeAll, itemCallCenter])
            }
            
        case "XV":
            let XVPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XV"}).first
            if XVPark!.buy_status {
                listHome.append(contentsOf: [itemTitleDescAbierto, itemTipoEntrada, itemCallCenter, itemActBasics, itemInfoPark, itemRestaurantes, itemAllInclusiveXavage, itemSeeAll])
            }else {
                listHome.append(contentsOf: [itemTitleDescCerrado, itemTipoEntrada, itemCallCenter, itemActBasics, itemInfoPark, itemRestaurantes, itemAllInclusiveXavage, itemSeeAll])
            }
        case "XP":
            if getStatusBuyXPFF() {
                listHome.append(contentsOf: [itemSwichXP, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
            }else{
                let XPPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XP"}).first
                if XPPark!.buy_status {
                   listHome.append(contentsOf: [itemTitleDescAbierto, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
                }else{
                    listHome.append(contentsOf: [itemTitleDescCerrado, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
                }
            }
        case "XF":
            if getStatusBuyXPFF() {
                listHome.append(contentsOf: [itemSwichXP, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
            }else{
                let XFPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XF"}).first
                if XFPark!.buy_status {
                    listHome.append(contentsOf: [itemTitleDescAbierto, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
                }else{
                    listHome.append(contentsOf: [itemTitleDescCerrado, itemActAir, itemInfoPark, itemRestaurantes, itemActLand, itemActUnderground, itemCallCenter])
                }
            }
        case "XO":
            let XOPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XO"}).first
            if XOPark!.buy_status {
                listHome.append(contentsOf: [itemTitleDescAbierto, itemEvents, itemInfoPark, itemKerMexIMG, itemKermesMexicana, itemXoMenu, itemCallCenter])
            }else{
                listHome.append(contentsOf: [itemTitleDescCerrado, itemEvents, itemInfoPark, itemKerMexIMG, itemKermesMexicana, itemXoMenu, itemCallCenter])
            }
            
        case "XN":
            listHome.append(contentsOf: [itemTitleXenotes, itemActividadesXenotes, itemTiposXenotes, itemAwardXenotes, itemRecomendacionesXenotes, itemCallCenter])
        case "XI":
            listHome.append(contentsOf: [itemTitleXenotes, itemEventsXI, itemCenotesXI, itemValladolidXi, itemInfoAddress, itemRecomendacionesXI, itemCallCenter])
        case "XA":
            let park = self.appDelegate.listAllParksEnabled.filter({$0.code == "XA"}).first
            if park!.buy_status {
                listHome.append(contentsOf: [itemInfoParkXA, itemAddmisionXA, itemActBasicsXA, itemInfoAddress, itemCallCenter])
            }else {
                listHome.append(contentsOf: [itemInfoParkXA, itemAddmisionXA, itemActBasicsXA, itemInfoAddress, itemCallCenter])
            }
        case "FE":
            let park = self.appDelegate.listAllParksEnabled.filter({$0.code == "FE"}).first
            if park!.buy_status {
                listHome.append(contentsOf: [itemInfoParkFE, itemTablePriceFE, itemInfoBuy, itemScheduleFerry, itemLocationFerry, itemActBasicsXA, itemCallCenter])
            }else {
                listHome.append(contentsOf: [itemInfoParkFE, itemTablePriceFE, itemInfoBuy, itemScheduleFerry, itemLocationFerry, itemActBasicsXA, itemCallCenter])
            }
        default:
            listHome.append(contentsOf: [itemNews, itemInfoPark, itemMap, itemEscentials, itemRestaurants, itemDiscover, itemExtra, itemPresentations, itemSeeAll, itemCallCenter])
        }
        
        completion(listHome)
    }
    
    func getListInfoShop(completion: @escaping ([ItemShop]) -> Void){
        var listShop = [ItemShop]()
        
        let itemPromotions = ItemShop()
        itemPromotions.promotion = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true}).sorted(by: {$0.order < $1.order})
        itemPromotions.sizeCell = CGSize(width: 130, height: 220)
        itemPromotions.heightCV = UIScreen.main.bounds.height * 0.24
        itemPromotions.typeCell = .cellPromotions
        itemPromotions.idEventFB = "listPromotions"
        
        let itemParks = ItemShop()
        itemParks.parkPref = appDelegate.listAllParksEnabled.filter({$0.order == 2})
        itemParks.park = appDelegate.listAllParks.filter({$0.code != itemParks.parkPref.first?.code && $0.status == true && $0.p_type == "P"}).sorted(by: { $0.order < $1.order })
        itemParks.sizeCell = CGSize(width: 130, height: 220)
        itemParks.heightCV = 220
        itemParks.typeCell = .cellParks
        itemParks.idEventFB = "listParkShop"
        
        let itemBtnAllPromotions = ItemShop()
        itemBtnAllPromotions.typeCell = .cellBtnAllPromotions
        itemBtnAllPromotions.idEventFB = "listBtnAllPromotionsShop"
        
        let itemTour = ItemShop()
        itemTour.name = "Tours"
        itemTour.tours = appDelegate.listAllParks.filter({$0.status == true && $0.p_type == "T"}).sorted(by: { $0.order < $1.order })
        itemTour.sizeCell = CGSize(width: 130, height: 220)
        itemTour.heightCV = (UIScreen.main.bounds.height * 0.17) + 55
        itemTour.typeCell = .cellTours
        itemTour.idEventFB = "listTour"
        
        let itemPack = ItemShop()
        itemPack.name = "Packs"
        itemPack.packs = appDelegate.listAllParks.filter({$0.status == true && $0.p_type == "T"}).sorted(by: { $0.order < $1.order })
        itemPack.sizeCell = CGSize(width: 130, height: 220)
        itemPack.heightCV = (UIScreen.main.bounds.height * 0.24) + 60
        itemPack.typeCell = .cellPacks
        itemPack.idEventFB = "listPacks"
        
//        listShop.append(contentsOf: [itemPromotions, itemParks, itemBtnAllPromotions, itemTour])
        listShop.append(contentsOf: [itemPromotions, itemParks, itemTour])
        completion(listShop)
    }
    
    func getStatusBuyXPFF() -> Bool{
        var okSwich = false
        let XPPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XP"}).first
        let XFPark = self.appDelegate.listAllParksEnabled.filter({$0.code == "XF"}).first
        
        if XPPark?.buy_status ?? false && XFPark?.buy_status ?? false{
            okSwich = true
        }
        
        return okSwich
    }
    
    func getTickets(completion: @escaping ([ItemTicket]) -> Void){
        //Vamos por los tickets a Firebase
        FirebaseDB.shared.getTicketsList(completion: { (listTicketsFB) in
            completion(listTicketsFB)
        })
    }
    
    func updateTickets(listTicketsUpdate: [ItemTicket], completion: @escaping ([ItemTicket]) -> Void){
        //Vamos por los tickets a Sivex
        XapiItinerary.shared.getItineraryByCode(listTickets: listTicketsUpdate) { listTicketsItinerary, success in
            if listTicketsItinerary.count > 0{
                FirebaseDB.shared.saveTicketList(listTickets: listTicketsItinerary, completion: { (listTicketsSaved) in
                    self.sortTicketsItinerary(listTickets: listTicketsSaved) { (listSortTickets) in
                         completion(listSortTickets)
                    }
                })
            }else{
                self.sortTicketsItinerary(listTickets: listTicketsUpdate) { (listSortTickets) in
                    completion(listSortTickets)
                  }
            }
        }
        
        /*XcaretDB.shared.getTicketsSivex(listTickets: listTicketsUpdate, completion: { (listTicketsSivex, success) in
            //Actializamos la info de Firebase si traemos los tickets,
            //si no pintamos los tickets de firebase
            if listTicketsSivex.count > 0{
                FirebaseDB.shared.saveTicketList(listTickets: listTicketsSivex, completion: { (listTicketsSaved) in
                    self.sortTicketsView(listTickets: listTicketsSaved) { (listSortTickets) in
                         completion(listSortTickets)
                    }
                })
            }else{
                self.sortTicketsView(listTickets: listTicketsUpdate) { (listSortTickets) in
                    completion(listSortTickets)
                  }
            }
        })*/
    }
    
    /*func getTicketsItinerary(listTicketsUpdate: [ItemTicket], completion: @escaping ([ItemTicket]) -> Void){
        //Vamos recorremos los tickets
        var listTicketsItinerary : [ItemTicket] = [ItemTicket]()
        //for ticket in listTicketsUpdate {
            XapiItinerary.shared.getItineraryByCode(code: "123") { listTicket, success in
                if success {
                    completion(listTicket)
                }
            }
        //}
        
    }*/
    
    func getCalendarData(listDias : [ItemProdProm] = [ItemProdProm]() , reCotizacion : Bool = false , mes : Int, year : Int, day : Int, itemProductsCarShop : ProductsCarShop = ProductsCarShop(), completion: @escaping (Bool, JSON) -> Void){
        XcaretDB.shared.getdataCalendar(producto: listDias.first!, reCotizacion : reCotizacion, mes : mes, year : year, day : day, itemProductsCarShop : itemProductsCarShop, completion: { (success, json) in
            if success {
                completion(true, json)
            }else{
                completion(false, json)
            }
        })
    }
    
    func getRateKeyAllotment(itemCarShoop : ItemCarShoop, rt : String, completion: @escaping (Bool, String, String, AllowedCustomerConfigPax) -> Void){
        XcaretDB.shared.getRateKeyAllotment(itemCarShoop : itemCarShoop, rt : rt, completion: { (success, allotment, rateKey, allowedCustomerConfigPax) in
            if success {
                completion(true, allotment, rateKey, allowedCustomerConfigPax)
            }else{
                completion(false, allotment, rateKey, allowedCustomerConfigPax)
            }
        })
    }
    
    
    func getAllotment(itemCarShoop : ItemCarShoop, completion: @escaping (Bool, AllotmentAvail) -> Void){
        XcaretDB.shared.getAllotment(itemCarShoop : itemCarShoop, completion: { (success, allotmentAvail) in
            if success {
                completion(true, allotmentAvail)
            }else{
                completion(false, allotmentAvail)
            }
        })
    }
    
    func getCancelAllotment(itemRateKey : String, mobile : Bool, completion: @escaping (Bool) -> Void){
        XcaretDB.shared.getCancelAllotment(itemRateKey : itemRateKey, mobile : mobile, completion: { (success) in
            if success {
                completion(true)
            }else{
                completion(false)
            }
        })
    }
    
    func getReservedAllotment(itemCarShoop : ItemCarShoop, rateKey : String, time : String = "minimo", completion: @escaping (Bool, ProdAllotment) -> Void){
        XcaretDB.shared.getReservedAllotment(itemCarShoop : itemCarShoop, rateKey : rateKey, time: time, completion: { (success, allotment) in
            if success {
                completion(true, allotment)
            }else{
                completion(false, allotment)
            }
        })
    }
    
    

    
    func getPackData(listItemsCarShop :  [ItemCarShoop], completion: @escaping (Bool, [ItemCarShoop]) -> Void){
        XcaretDB.shared.getdataPack(listItemsCarShop : listItemsCarShop, completion: { (success, listItemCS) in
            if success {
                completion(true, listItemCS)
            }else{
                completion(false, listItemCS)
            }
        })
    }
    
    
    func getLocations(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, [ItemLocations]) -> Void){

        XcaretDB.shared.getDataLocations(itemsCarShoop : itemsCarShoop, completion: { (success, itemLocations) in
            if success {
                completion(true, itemLocations)
            }else{
                completion(false, itemLocations)
            }
        })
    }

    func getPricePhotopass(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, Itemfotos) -> Void){
        XcaretDB.shared.getDataPricePhotopass(itemsCarShoop : itemsCarShoop, completion: { (success, itemfotos) in
            if success {
                completion(true, itemfotos)
            }else{
                completion(false, itemfotos)
            }
        })
    }
    
    func getPriceIKE(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, ItemIKE) -> Void){
        XcaretDB.shared.getDataPriceIKE(itemsCarShoop : itemsCarShoop, completion: { (success, itemIKE) in
            if success {
                completion(true, itemIKE)
            }else{
                completion(false, itemIKE)
            }
        })
    }
    
    func updateTicket(listTicketsUpdate: [ItemTicket], ticket: String, email: String, completion: @escaping ([ItemTicket], String) -> Void){
        //Vamos por los tickets a Sivex
        XcaretDB.shared.getTicketsSivex(listTickets: listTicketsUpdate, ticket: ticket, completion: { [self] (listTicketsSivex, success) in
            //Actializamos la info de Firebase si traemos los tickets,
            //si no pintamos los tickets de firebase
            if listTicketsSivex.count > 0{
                //validar correo
                if listTicketsSivex.first?.contactEmail == email{
                    FirebaseDB.shared.saveTicketList(listTickets: listTicketsSivex, completion: { (listTicketsSaved) in
                        self.sortTicketsView(listTickets: listTicketsSaved) { (listSortTickets) in
                            completion(listSortTickets, "success")
                        }
                    })
                }else{
                    self.sortTicketsView(listTickets: listTicketsUpdate) { (listSortTickets) in
                        completion(listSortTickets, "email")
                      }
                }
            }else{
                self.sortTicketsView(listTickets: listTicketsUpdate) { (listSortTickets) in
                    completion(listSortTickets, "folio")
                  }
            }
        })
    }
    
    func updateItemCarshopSencillo(itemCarShop :  [ItemCarShoop], editItem : String = "", completion: @escaping (ItemListCarshop, Bool) -> Void){
        FirebaseDB.shared.saveItemCarshopSencillo(itemCarShop: itemCarShop, editItem : editItem, completion: { (listCarshop) in
            completion(listCarshop, true)
        })
    }
    
    func updateKeyCarShop(key: String, value : Any, idDetail : String = "", idProduct : String = "", completion: @escaping (Bool) -> Void){
        FirebaseDB.shared.saveUpdateKeyCarShop(key: key, value : value, idDetail : idDetail, idProduct: idProduct, completion: { (isSuccess) in
            completion(isSuccess)
        })
    }
    
    func updateListCarshopPacks(listItemCarShop :  [ItemCarShoop], editId : String = "", completion: @escaping (ItemListCarshop, String) -> Void){
        
        
        FirebaseDB.shared.saveItemListCarshop(listItemCarShop: listItemCarShop, editId : editId, completion: { (listCarshop) in
//            self.sortTicketsView(listTickets: listTicketsSaved) { (listSortTickets) in
                completion(listCarshop, "success")
//            }
        })
        //Vamos por los tickets a Sivex
//        XcaretDB.shared.getTicketsSivex(listTickets: listTicketsUpdate, ticket: ticket, completion: { [self] (listTicketsSivex, success) in
//            //Actializamos la info de Firebase si traemos los tickets,
//            //si no pintamos los tickets de firebase
//            if listTicketsSivex.count > 0{
//                //validar correo
//                if listTicketsSivex.first?.contactEmail == email{
//                    FirebaseDB.shared.saveTicketList(listTickets: listTicketsSivex, completion: { (listTicketsSaved) in
//                        self.sortTicketsView(listTickets: listTicketsSaved) { (listSortTickets) in
//                            completion(listSortTickets, "success")
//                        }
//                    })
//                }else{
//                    self.sortTicketsView(listTickets: listTicketsUpdate) { (listSortTickets) in
//                        completion(listSortTickets, "email")
//                      }
//                }
//
//            }else{
//                self.sortTicketsView(listTickets: listTicketsUpdate) { (listSortTickets) in
//                    completion(listSortTickets, "folio")
//                  }
//            }
//        })
    }
    
    func deleteListCarshop(listItemCarShop :  ItemCarshop, completion: @escaping (Bool) -> Void){
        FirebaseDB.shared.deleteItemListCarshop(listItemCarShop: listItemCarShop, completion: { (status) in
                completion(status)
        })
    }
    
    
    func authenticateSF(user: UserApp, completion: @escaping (Bool, String) -> Void){
        print(user)
        if user.email != ""{
            print("StatusSF: \(user.provider)")
            XcaretDB.shared.getTokenSF(user: user  ,completion: { (isSuccess, token) in
                if isSuccess && token != ""{
                    print("StatusSF: P1 obtención del token getTokenSF")
                    XcaretDB.shared.checkUser(user: user, token: token, completion: { (userRegisterSF) in
                        print("StatusSF: P2 checkUser")
                        if !userRegisterSF {
                            XcaretDB.shared.authSF(user: user, token: token, completion: { (isSuccess) in
                                print("StatusSF: P3 authSF")
                                completion(isSuccess, isSuccess ? "Se registro el user en SF" : "No se pudo registrar al user en SF")
                            })
                        }else{
                            completion(false, "\(user.email) Ya está registrado en SF")
                        }
                    })
                }else{
                    print("Error al autenticar usuario en SF")
                    completion(isSuccess, "No se obtuvo el token")
                }
            })
        }else{
            completion(false, "No tiene correo")
        }
    }
    
    func authenticateUserApp(user: UserApp, completion: @escaping (Bool, UserApp) -> Void){
        //Paso 1: Verificamos la autenticación del user en Firebase y Auth de Firebase
        FirebaseDB.shared.authUserApp(user: user) { [self] (success, userApp) in
            //Paso 2: Sólo enviarémos aquellos usuarios que tengan correo, nombre y apellido
            //No entran los usuarios de apple
            if self.validateUserSaleforce(user: userApp){
                //Paso3: Enviamos a Salesforce
                FirebaseBR.shared.authenticateSF(user: userApp, completion: { (successSF, message) in
                    if success{
                        print("StatusSF: Autenticación correcta en SF -> \(message)")
                    }else{
                        print("StatusSF: Error en autenticación de SF -> \(message)")
                    }
                    completion(success, userApp)
                })
            }else{
                completion(success, userApp)
            }
        }
    }
    
    func validateUserSaleforce(user: UserApp) -> Bool{
        var isvalid: Bool = false
        //Validamos el proveedor
        FirebaseDB.shared.getTypeAuthentication { (typeProvider) in
            print("StatusSF: Proveedor \(typeProvider)")
            if typeProvider == .facebook || typeProvider == .google || typeProvider == .userPass || typeProvider == .apple{
                if !user.email.isEmpty && !user.name.isEmpty{
                    print("StatusSF: Trae datos para alta en SF")
                    isvalid = true
                }else{
                    print("StatusSF: NO trae datos para alta en SF")
                }
            }
        }
        return isvalid
    }
    
    func sortTicketsItinerary(listTickets : [ItemTicket], completion: @escaping ([ItemTicket]) -> Void){
        var sortListTickets = [ItemTicket]()
        for itemTicket in listTickets{
            for itemProd in itemTicket.listProducts {
                switch itemProd.familyProducto.lowercased() {
                case "fotos":
                    itemProd.orderSort = 6
                case "entradas":
                    itemProd.orderSort = 1
                case "tours" :
                    itemProd.orderSort = 2
                case "actividades":
                    itemProd.orderSort = 3
                case "seguro":
                    itemProd.orderSort = 5
                default:
                    itemProd.orderSort = 4
                }
                
                if itemProd.feOperacion.isEmpty{
                    itemTicket.allVisit = false
                }
            }
            
            itemTicket.listProducts = itemTicket.listProducts.sorted(by: { (id1, id2) -> Bool in
                if id1.orderSort == id2.orderSort {
                        return id1.visitDate < id2.visitDate
                }
                return id1.orderSort < id2.orderSort 
            })
            
            sortListTickets.append(itemTicket)
            
            sortListTickets = sortListTickets.sorted(by: { ticket1, ticket2 in
                return ticket1.barCode > ticket2.barCode
            })
        }
        completion(sortListTickets)
    }

            
    func sortTicketsView(listTickets : [ItemTicket], completion: @escaping ([ItemTicket]) -> Void){
        var sortListTickets = [ItemTicket]()
        for itemTicket in listTickets{
            for itemProd in itemTicket.listProducts {
                switch itemProd.familyProducto.lowercased() {
                case "fotos":
                    itemProd.orderSort = 5
                case "entradas":
                    itemProd.orderSort = 1
                case "tours" :
                    itemProd.orderSort = 2
                case "actividades":
                    itemProd.orderSort = 3
                default:
                    itemProd.orderSort = 4
                }
                
                //Si el producto no tiene complementos, lo agregamos como uno
                if itemProd.listComponents.count == 0 {
                    let addItemComplement = ItemComponent()
                    addItemComplement.dueDate = itemProd.dueDate
                    addItemComplement.familyProducto = itemProd.familyProducto
                    addItemComplement.feOperacion = itemProd.feOperacion
                    addItemComplement.hasAYB = itemProd.hasAYB
                    addItemComplement.hasPickup = itemProd.hasPickup
                    addItemComplement.hasPhotopass = itemProd.hasPhotopass
                    addItemComplement.locationPickup = itemProd.locationPickup
                    addItemComplement.productCode = itemProd.productCode
                    addItemComplement.productName = itemProd.productName
                    addItemComplement.timePickup = itemProd.timePickup
                    addItemComplement.visitDate = itemProd.visitDate
                    addItemComplement.adults = itemProd.adults
                    addItemComplement.childrens = itemProd.childrens
                    addItemComplement.infants = itemProd.infants
                    addItemComplement.un = itemProd.un
                    addItemComplement.uid = itemProd.uid
                    addItemComplement.detailComponent = getDetailComplement(familyProduct: itemProd.familyProducto)
                    if itemProd.feOperacion.isEmpty{
                        itemTicket.allVisit = false
                    }
                    addItemComplement.itemPromotion = itemProd.promocion
                    
                    itemProd.headerTable = false
                    itemProd.listComponents.append(addItemComplement)
                }else{
                    for itemComponent in itemProd.listComponents {
                        itemComponent.adults = itemProd.adults
                        itemComponent.childrens = itemProd.childrens
                        itemComponent.infants = itemProd.infants
                        itemComponent.detailComponent = getDetailComplement(familyProduct: itemComponent.familyProducto)
                    }
                }
            }
            
            itemTicket.listProducts = itemTicket.listProducts.sorted(by: { (id1, id2) -> Bool in
                return id1.orderSort < id2.orderSort
            })
            
            sortListTickets.append(itemTicket)
        }
        
        completion(sortListTickets)
    }
    
    func getDetailComplement(familyProduct: String) -> Bool{
        if familyProduct.lowercased().contains("entradas") ||
            familyProduct.lowercased().contains("tours") {
            return true
        }else{
            return false
        }
    }
    
    func getParkBySivexCode(sivexCode: String, promotion: ItemPromocion, completion: @escaping ([ItemDetInfoTicket]) -> Void){
        var listInfo : [ItemDetInfoTicket] = [ItemDetInfoTicket]()
        var titlePromo: String = ""
        var descPromo : String = ""
        //Info default
        listInfo.append(ItemDetInfoTicket(_title: "", _desc: "lbl_tickets_id".getNameLabel(), _typeIfo: "DEF"))
        
        //Info Promotion
        if !promotion.dsCodigoPromocion.isEmpty{
            if promotion.dsCodigoPromocion.contains("HSBCXC"){
                titlePromo = "lbl_title_promotion_hsbc_ticket".getNameLabel()
                descPromo = promotion.dsCodigoPromocion == "HSBCXC1" ? "lbl_description_promotion_hsbc_three_park_ticket".getNameLabel() : "lbl_description_promotion_hsbc two day_ticket".getNameLabel()
            }else{
                titlePromo = promotion.dsCodigoPromocion
                descPromo = promotion.dsNombrePromocion
            }
            
            listInfo.append(ItemDetInfoTicket(_title: titlePromo, _desc: descPromo, _typeIfo: "PROMO"))
        }
        
        //Info Parque
        if let park = appDelegate.listAllParks.first(where: { $0.code.uppercased() == sivexCode.uppercased()}){
            if !park.detail.include.isEmpty{
                listInfo.append(ItemDetInfoTicket(_title: "lbl_include_2".getNameLabel(), _desc: park.detail.include, _typeIfo: "INFO"))
            }
            if !park.detail.recomendations.isEmpty{
                listInfo.append(ItemDetInfoTicket(_title: "lbl_recommendations".getNameLabel(), _desc: park.detail.recomendations, _typeIfo: "INFO"))
            }
        }
        
        
        completion(listInfo)
    }
    
    func getNamePark(parkId: Int) -> String{
        var namePark = ""
        for parks in appDelegate.listAllParks{
            print("\(parks.photoCode!) == \(parkId)")
            if parks.photoCode! == parkId {
                namePark =  parks.name
            }
        }
        return namePark
    }
    
    func getBanksInfo(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, Banks) -> Void){
        XcaretDB.shared.getBanksInfo(itemsCarShoop : itemsCarShoop, completion: { (success, banksInfo) in
            if success {
                completion(true, banksInfo)
            }else{
                completion(false, banksInfo)
            }
        })
    }
    
    func getCardInfo(bin: String, completion: @escaping (Bool, ItemCardInfo) -> Void){
        XcaretDB.shared.getCardInfo(bin : bin, completion: { (success, cardInfo) in
            if success {
                completion(true, cardInfo)
            }else{
                completion(false, cardInfo)
            }
        })
    }
    
    
    func getCardInfo2(bin: String, completion: @escaping (Bool, ItemCardInfo, String) -> Void){
        XcaretDB.shared.getCardInfo2(bin : bin, completion: { (success, cardInfo, statusCode) in
            if success {
                completion(true, cardInfo, statusCode)
            }else{
                completion(false, cardInfo, statusCode)
            }
        })
    }
    
    
    func buyItem(itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, completion: @escaping (Bool, GetBookingTicket) -> Void){
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
                XcaretDB.shared.getInfoBuy(itemsCarShoop : itemsCarShoop, buyItem : buyItem, completion: { (success, bookingTicket) in
                    group.leave()
                    if success {
                        completion(true, bookingTicket)
                    }else{
                        completion(false, bookingTicket)
                    }
                })
            
            group.wait()
        }
    }
    
    func validateCarShop(itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, completion: @escaping (Bool, StatusValidateCarShop) -> Void){
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            XcaretDB.shared.getValidateCarShop(itemsCarShoop : itemsCarShoop, buyItem : buyItem, completion: { (success, status) in
                group.leave()
                if success {
                    completion(true, status)
                }else{
                    completion(false, status)
                }
            })
            group.wait()
        }
        
    }
}
