//
//  HomeTabBarViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 6/3/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var itemImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabHome = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "HomeParksNC")
        let tabHomeBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Icons/tab/home_over"), selectedImage: UIImage(named: "Icons/tab/home"))
        tabHomeBarItem.tag = 101
        tabHome.tabBarItem = tabHomeBarItem
        
        let tabSearch = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "SearchParksVC")
        let tabSearchBarItem = UITabBarItem(title: "Búsqueda", image: UIImage(named: "Icons/tab/search_over"), selectedImage: UIImage(named: "Icons/tab/search"))
        tabSearchBarItem.tag = 102
        tabSearch.tabBarItem = tabSearchBarItem
        
        let tabMainMenu = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "MenuParksNC")
        let tabMainMenuBarItem = UITabBarItem(title: "Menú", image: UIImage(named: "Icons/tab/menu_over"), selectedImage: UIImage(named: "Icons/tab/menu"))
        tabMainMenuBarItem.tag = 103
        tabMainMenu.tabBarItem = tabMainMenuBarItem
        
        
        self.viewControllers = [tabHome, tabSearch, tabMainMenu]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected tabBar \(item.tag)")
        switch item.tag {
            case 101:
                self.tabBar.unselectedItemTintColor = UIColor.white
                self.tabBar.tintColor = UIColor.white
            default:
                self.tabBar.unselectedItemTintColor = UIColor.darkGray
                self.tabBar.tintColor = UIColor.darkGray
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(tabBarController.tabBarItem.tag)")
    }
    
}
