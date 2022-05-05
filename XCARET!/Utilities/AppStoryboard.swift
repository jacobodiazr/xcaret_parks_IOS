//
//  AppStoryboard.swift
//  XCARET!
//
//  Created by Angelica Can on 11/6/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main
    case SignUp
    case ParkXcaret
    case Photo
    case HomeParks
    case Hotel
    case ParkXenses
    case Tickets
    case Xafety
    case Promociones
    case Tienda
    case Cotizador
    case Compra
    case AlertDefault
    
    var instance: UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}


//USAGE
//let greenScene = GreenVC.instantiate(fromAppStoryboard: .Main)
//let greenScene = AppStoryboard.Main.viewController(viewControllerClass: GreenVC.self)
//let greenScene = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: GreenVC.storyboardID)
