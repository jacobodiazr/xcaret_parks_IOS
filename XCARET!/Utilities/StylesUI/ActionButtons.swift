//
//  FavoriteButton.swift
//  XCARET!
//
//  Created by Angelica Can on 11/23/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ButtonDetComponent : UIButton {
    var itemComponent : ItemComponent!
    var itemProduct: ItemProduct!
}

class GoServButton : UIButton{
    var itemServiceLocation : ItemServicesLocation!
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.imageView?.setImageColor(color: Constants.COLORS.GENERAL.btnGo)
    }
    
    override func awakeFromNib() {
        let img = UIImage.init(named: "Icons/ico_go")
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
    }
}

class GoButton: UIButton {
    var itemActivity: ItemActivity!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.imageView?.setImageColor(color: Constants.COLORS.GENERAL.btnGo)
    }
    
    override func awakeFromNib() {
        let img = UIImage.init(named: "Icons/ico_go")
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
    }
}

class FavoriteSimpleButton: UIButton {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let imageFavOFF: String! = "Icons/ico_heart_contour"
    private let imageFavON: String! = "Icons/ic_favoritos_active_red"
    private var styleTransform : CGAffineTransform = .identity
    var typeStyle : String = "STD"
    var name: String!
    
    var uid: String! {
        didSet{
            setIsFavorite()
        }
    }
    
    override func awakeFromNib() {
        self.typeStyle = appDelegate.itemParkSelected.code
        let img = UIImage.init(named: imageFavOFF)
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        if typeStyle == "XF"{
            self.imageView?.setImageColor(color: UIColor.white)
        }
        self.addTarget(self, action: #selector(self.makePressFavorite), for: .touchUpInside)
    }
    
    @objc private func makePressFavorite() {
        print("Press buttonFavorite")
        self.changeValueFav()
    }
    
    private func setIsFavorite(){
        setBackground(isFavorite: validateFav())
    }
    
    private func changeValueFav(){
        if validateFav(){
            if typeStyle == "XS"{
                Vibration.error.vibrate()
            }
            //Si es favorito, removemos de la base de datos, actualizamos la lista y cambiamos background
            FirebaseDB.shared.removeFavorite(fav: self.uid, name: self.name) { (success) in
                if success {
                    if let index = self.appDelegate.listFavoritesByPark.firstIndex(where: {$0.uid == self.uid}){
                        self.appDelegate.listFavoritesByPark.remove(at: index)
                        self.setBackground(isFavorite: false)
                    }
                }
            }
        }else{
            if typeStyle == "XS"{
                Vibration.success.vibrate()
            }
            /*SF*/
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_addFavortite": true]
            (AppDelegate.getKruxTracker()).trackPageView("ActivityDetail", pageAttributes:pageAttr, userAttributes:nil)
            /**/
            FirebaseDB.shared.saveFavorite(fav: self.uid, name: self.name) { (success) in
                if success{
                    let newFav = ItemFavorite(uid: self.uid)
                    self.appDelegate.listFavoritesByPark.append(newFav)
                    self.setBackground(isFavorite: true)
                }
            }
        }
    }
    
    private func validateFav() -> Bool{
        //Obtenemos lista de favoritos
        let listFav = appDelegate.listFavoritesByPark
        if listFav.first(where: {$0.uid == self.uid}) != nil{
            return true
        }else{
            return false
        }
    }
    
    private func setBackground(isFavorite: Bool){
        if isFavorite{
            let img = UIImage.init(named: imageFavON)
            self.setImage(img, for: .normal)
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }else{
            let img = UIImage.init(named: imageFavOFF)
            self.setImage(img, for: .normal)
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        if self!.typeStyle == "XS"{
                            self?.transform = self!.styleTransform.rotated(by: -CGFloat.pi / 30)
                        }else{
                             self?.transform = CGAffineTransform.identity
                        }
            },
                       completion: nil
        )
        
    }
    
}

class FavoriteButton: UIButton {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var uid: String! {
        didSet{
            setIsFavorite()
        }
    }
    var typeStyle : String = "STD" {
        didSet{
            setStyle()
        }
    }
    var isFavorite: Bool!
    var colorA : UIColor = UIColor.red
    var colorB : UIColor = UIColor.white.withAlphaComponent(0.5)
    var name: String!
    private let imageFav: String! = "Icons/ico_heart"
    private let imageFavOver: String = "Icons/ico_heart_contour"
    private var styleTransform : CGAffineTransform = .identity
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
 
    override func awakeFromNib() {
        self.typeStyle = appDelegate.itemParkSelected.code
        let img = UIImage.init(named: imageFav)
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        //self.imageView?.setImageColor(color: UIColor.white)
        self.addTarget(self, action: #selector(self.makePressFavorite), for: .touchUpInside)
    }

    @objc private func makePressFavorite() {
        print("Press buttonFavorite")
        self.changeValueFav()
    }
    
    private func setStyle(){
        
        styleTransform = .identity
        colorB = UIColor.white.withAlphaComponent(0.5)
        
        /*switch typeStyle {
        case "XS":
            colorB = UIColor.white
            styleTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 30)
        default:
           
        }*/
    }
    
    private func setIsFavorite(){
        setBackground(isFavorite: validateFav())
    }
    
    private func changeValueFav(){
        if validateFav(){
            if typeStyle == "XS"{
                Vibration.error.vibrate()
            }
            //Si es favorito, removemos de la base de datos, actualizamos la lista y cambiamos background
            FirebaseDB.shared.removeFavorite(fav: self.uid, name: self.name) { (success) in
                if success {
                    if let index = self.appDelegate.listFavoritesByPark.firstIndex(where: {$0.uid == self.uid}){
                        self.appDelegate.listFavoritesByPark.remove(at: index)
                        self.setBackground(isFavorite: false)
                    }
                }
            }
        }else{
            if typeStyle == "XS"{
                Vibration.success.vibrate()
            }
            FirebaseDB.shared.saveFavorite(fav: self.uid, name: self.name) { (success) in
                if success{
                    let newFav = ItemFavorite(uid: self.uid)
                    self.appDelegate.listFavoritesByPark.append(newFav)
                    self.setBackground(isFavorite: true)
                }
            }
        }
    }

    private func validateFav() -> Bool{
        //Obtenemos lista de favoritos
        let listFav = appDelegate.listFavoritesByPark
        if listFav.first(where: {$0.uid == self.uid}) != nil{
            return true
        }else{
            return false
        }
    }
    
    private func setBackground(isFavorite: Bool){
        var bckColor : UIColor! = UIColor()
        if isFavorite{
            bckColor = colorA
            self.setImage(UIImage(named: imageFav), for: .normal)
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }else{
            bckColor = colorB
            self.setImage(UIImage(named: imageFavOver), for: .normal)
            self.imageView?.setImageColor(color: UIColor.white)
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        
        
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.transform = .identity
                        self?.backgroundColor = bckColor
            },
                       completion: nil
        )
    }
}
