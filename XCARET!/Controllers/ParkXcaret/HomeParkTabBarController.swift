//
//  HomeParkTabBarController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/4/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class HomeParkTabBarController: UITabBarController, UITabBarControllerDelegate {
    let sizeScreenWidth = UIScreen.main.bounds.width
    let sizeScreenHeight = UIScreen.main.bounds.height
    var index = 0
    let contentViewProm = UIView()
    let viewProm = AnimationView()
    var imgPromSelect = UIImage()
    var imageView = UIImageView()
    var selectProm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        viewProm.play(fromProgress: 0, toProgress: 0.9, loopMode: LottieLoopMode.loop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tabHome = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "HomeParksNC")
        let tabHomeBarItem = UITabBarItem(title: "lbl_tb_home".getNameLabel()/*"tbHome".localized()*/, image: UIImage(named: "Icons/tab/home_over"), selectedImage: UIImage(named: "Icons/tab/home"))
        tabHomeBarItem.tag = 1
        tabHome.tabBarItem = tabHomeBarItem
        
        let tabFavs = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "FavsParksNC")
        let tabFavsBarItem = UITabBarItem(title: "lbl_tb_favorites".getNameLabel() /*"tbFavorites".localized()*/, image: UIImage(named: "Icons/tab/favs_over"), selectedImage: UIImage(named: "Icons/tab/favs"))
        tabFavsBarItem.tag = 2
        tabFavs.tabBarItem = tabFavsBarItem
        
        let tabProm = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom")
        let tabPromBarItem = UITabBarItem(title: "lbl_promotions".getNameLabel() /*"tbFavorites".localized()*/, image: UIImage(named: ""), selectedImage: UIImage(named: "Icons/tab/promociones"))
        tabPromBarItem.tag = 3
        tabProm.tabBarItem = tabPromBarItem
        
        let tabBackHome = GoToHomeViewController()
        let tabBackHomeBarItem = UITabBarItem(title: "Parques", image: UIImage(named: "Icons/tab/favs_over"), selectedImage: UIImage(named: "Icons/tab/search"))
        tabBackHomeBarItem.tag = 6
        tabBackHome.tabBarItem = tabBackHomeBarItem
        
        let tabSearch = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "SearchParksNC")
        let tabSearchBarItem = UITabBarItem(title: "lbl_tb_search".getNameLabel()/*"tbSearch".localized()*/, image: UIImage(named: "Icons/tab/search_over"), selectedImage: UIImage(named: "Icons/tab/search"))
        tabSearchBarItem.tag = 4
        tabSearch.tabBarItem = tabSearchBarItem
        
        let tabMainMenu = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "MenuParksNC")
        let tabMainMenuBarItem = UITabBarItem(title: "lbl_tb_menu".getNameLabel()/*"tbMenu".localized()*/, image: UIImage(named: "Icons/tab/menu_over"), selectedImage: UIImage(named: "Icons/tab/menu"))
        tabMainMenuBarItem.tag = 5
        tabMainMenu.tabBarItem = tabMainMenuBarItem
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
        self.tabBar.tintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
        self.tabBar.unselectedItemTintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
        if appDelegate.itemParkSelected.code == "XV" || appDelegate.itemParkSelected.code == "XP" {
            self.viewControllers = [tabHome, tabFavs, tabMainMenu]
            if !appDelegate.itemParkSelected.buy_status{
                self.viewControllers = [tabHome, tabFavs, tabMainMenu]
            }
        }else if appDelegate.itemParkSelected.code == "XF"{
            self.viewControllers = [tabHome, tabFavs, tabMainMenu]
            if !appDelegate.itemParkSelected.buy_status{
                self.viewControllers = [tabHome, tabFavs, tabMainMenu]
            }
            UITabBar.appearance().barTintColor = UIColor.black
            UITabBar.appearance().tintColor = UIColor.white
            self.tabBar.tintColor = UIColor.white
            self.tabBar.unselectedItemTintColor = UIColor.white
        }else if appDelegate.itemParkSelected.code == "XO"{
            self.viewControllers = [tabHome, tabMainMenu]
            if !appDelegate.itemParkSelected.buy_status{
                self.viewControllers = [tabHome, tabMainMenu]
            }
             
        }else if appDelegate.itemParkSelected.code == "XN" || appDelegate.itemParkSelected.code == "XI"{
             self.viewControllers = [tabHome]
        }else if appDelegate.itemParkSelected.code == "XA" || appDelegate.itemParkSelected.code == "FE"{
            self.viewControllers = [tabHome, tabMainMenu]
        }else{
            self.viewControllers = [tabHome, tabFavs, tabSearch, tabMainMenu]
            if !appDelegate.itemParkSelected.buy_status{
                self.viewControllers = [tabHome, tabFavs, tabSearch, tabMainMenu]
            }
        }
        
        if self.viewControllers?.count != 0 || (!self.viewControllers!.isEmpty) {
            
            for index in self.viewControllers!.indices {
                
                if self.viewControllers![index].tabBarItem.tag == 3 {
                    self.index = index
                    
                    let sizeLeftWidth = self.sizeScreenWidth / CGFloat(self.viewControllers!.count)
                    contentViewProm.frame = CGRect(x: sizeLeftWidth * CGFloat(index), y: 0, width: sizeLeftWidth, height: 50)
                    contentViewProm.backgroundColor = .clear

                    var path = Bundle.main.path(forResource: "tienda", ofType: "json") ?? ""
                    let imageName = "Icons/tab/promociones"
                    
                    imgPromSelect = UIImage(named: imageName)!
                    
//                    imageView = UIImageView(image: imgPromSelect)
//                    imageView.frame = CGRect(x: (contentViewProm.frame.width / 2) - 15, y: 5, width: 30, height: 30)
//
//                    if appDelegate.itemParkSelected.code == "XF"{
//                        path = Bundle.main.path(forResource: "promociones_xf",ofType: "json") ?? ""
//                        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
//                        imageView.tintColor = .white
//                    }
//
//                    viewProm.animation = Animation.filepath(path)
//                    viewProm.frame = CGRect(x: (contentViewProm.frame.width / 2) - 15, y: 5, width: 30, height: 30)
//                    viewProm.backgroundColor = .clear
//                    viewProm.play(fromProgress: 0, toProgress: 0.9, loopMode: LottieLoopMode.loop)
                    
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(goToProm))
//                    contentViewProm.addGestureRecognizer(tap)

                    
//                    contentViewProm.addSubview(imageView)
//                    imageView.isHidden = true
//                    contentViewProm.addSubview(viewProm)
                    
                    tabBar.addSubview(contentViewProm)
                    
                }
                
            }
        }
        
        if appDelegate.idAction != "" {
            
            if appDelegate.idAction == "promTicket" {
                goToProm()
            }else{
                let prom = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.prod_code == appDelegate.idAction && $0.status == true})
                if prom.count > 0 {
                    goToProm()
                }
            }
        }
    }
    
    @objc func goToProm(){
        
        let idEvent = TagsID.promotions.rawValue
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickPromotion": "prom"]
        AnalyticsBR.shared.saveEventContentFBByPark(content: "\(appDelegate.itemParkSelected.code!)_\(TagsContentAnalytics.Navigation.rawValue)", title: "\(appDelegate.itemParkSelected.code!)_\(idEvent)")
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
        (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        
        self.viewProm.isHidden = true
        self.imageView.isHidden = false
        self.selectedIndex = self.index
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.viewProm.isHidden = false
        self.imageView.isHidden = true
        print("Selected \(item.tag)")
        var pageAttr = [String : String]()
        var idEvent = ""
        switch item.tag {
        case 1:
            idEvent = TagsID.home.rawValue
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickHome": "home"]
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        case 2:
            idEvent = TagsID.fav.rawValue
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickFavorites": "favoritos"]
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: "\(idEvent)")
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        case 3:
//            self.contentViewProm.isHidden = true
            idEvent = TagsID.promotions.rawValue
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickSearch": "prom"]
//            let aux = "\(appDelegate.itemParkSelected.code!)_\(idEvent)"
            AnalyticsBR.shared.saveEventContentFBByPark(content: "\(appDelegate.itemParkSelected.code!)_\(TagsContentAnalytics.Navigation.rawValue)", title: "\(appDelegate.itemParkSelected.code!)_\(idEvent)")
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        case 4:
            idEvent = TagsID.search.rawValue
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickPromotion": "buscar"]
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        case 5:
            idEvent = TagsID.menu.rawValue
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ClickMenu": "perfil"]
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        default:
            idEvent = "Nuevo"
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Navigation.rawValue, title: idEvent)
            (AppDelegate.getKruxTracker()).trackPageView("NavigationMenu", pageAttributes:pageAttr, userAttributes:nil)
        }
    }
    
}
