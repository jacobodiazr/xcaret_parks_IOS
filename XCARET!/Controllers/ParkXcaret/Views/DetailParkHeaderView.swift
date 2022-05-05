//
//  ParkHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/27/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class DetailParkHeaderView: UIView {
    let storageRef = Storage.storage().reference()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var viewGradientContraint: NSLayoutConstraint!
    @IBOutlet weak var viewExtra: UIView!
    @IBOutlet weak var cornerDropShadowViewBottomConstraint: NSLayoutConstraint!
    
    var namedImage = "ok"
    
    var imageName: String = "ok" {
        didSet{
            if appDelegate.itemParkSelected.code == "XV" {
                namedImage = "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(imageName)"
            }else{
                namedImage = "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(imageName)"
            }
            
            if let imageTD = UIImage(named: namedImage) {
                imageView.image = imageTD
            } else {
                imageView.image = nil
            }
            
            self.loadImageCache(imageName: imageName, codePark: appDelegate.itemParkSelected.code!.lowercased())
        }
    }
    
    var isExtra : Bool! {
        didSet{
            setExtra()
        }
    }
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = nil
            }
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
        case "XV", "XA", "FE":
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            let imageName = "Headers/\(appDelegate.itemParkSelected.code.uppercased())/textura"
            let image = UIImage(named: imageName)
            let imageViewC = UIImageView(image: image!)
            imageViewC.frame = CGRect(x: 0, y: 0, width: self.cornerDropShadowView.frame.size.width, height: 70)
            cornerDropShadowViewBottomConstraint.constant = -1
            cornerDropShadowView.addSubview(imageViewC)
        case "XF":
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
        default:
            self.cornerDropShadowView.setOvalShadow()
        }
    }
    
    func setExtra(){
        viewExtra.isHidden = self.isExtra ? false : true
    }
    
    func loadImageCache(imageName: String, codePark: String){
        //Verificamos si existe en la caché
        let keyImageCache : String! = "\(codePark)\(imageName)"
        let cache = ImageCache.default
        //Preguntamos si existe en la caché
        if cache.isCached(forKey: keyImageCache) {
            cache.retrieveImage(forKey: "\(codePark)\(imageName)") { result in
                switch result {
                case .success(let value):
                    //print(value.cacheType)
                    // If the `cacheType is `.none`, `image` will be `nil`.
                    //print(value.image)
                    switch value {
                    case .none:
                        print("Caché None")
                        
                        var imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(imageName)")
                        if imageLocal == nil{
                            imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(imageName)")
                            if imageLocal == nil{
                                imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
                            }
                        }
                        
//                        if appDelegate.itemParkSelected.code == "XV"{
//                            imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(imageName)")
//                        }
                        self.imageView.image = imageLocal
                    case .disk:
                        print("Cache Disk")
                        DispatchQueue.main.async { self.imageView.image = value.image }
                    case .memory:
                        print("Cache Memory")
                        DispatchQueue.main.async { self.imageView.image = value.image }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }else{
            //Si no existe vamos al kingFisher
            self.loadImageFirestore(imageName: imageName, codePark: appDelegate.itemParkSelected.code!.lowercased())
        }
    }
    
    func loadImageFirestore(imageName: String, codePark: String){
        let imageRef = storageRef.child("\(codePark.lowercased())/activities")
        let fileRef = imageRef.child("\(imageName).jpg")
        
        //Vamos por la imagen a Firestore
        fileRef.downloadURL { (url, error) in
            if let error = error {
                print("No se obtuvo url: \(error.localizedDescription)")
                self.imageView.image = UIImage(named: "Parks/\(codePark.uppercased())/Activities/ThumbsNew/\(imageName)")
                if appDelegate.itemParkSelected.code == "XV"{
                    self.imageView.image = UIImage(named: "Parks/\(codePark.uppercased())/Activities/\(imageName)")
                }
            }else{
                //let resource = ImageResource(downloadURL: url, cacheKey: "\(url.absoluteString)")
                var urlImagePlaceholder = "Parks/\(codePark.uppercased())/Activities/ThumbsNew/\(imageName)"
                if appDelegate.itemParkSelected.code == "XV"{
                    urlImagePlaceholder = "Parks/\(codePark.uppercased())/Activities/\(imageName)"
                }
                let resource = ImageResource(downloadURL: url!, cacheKey:  "\(codePark)\(imageName)")
                //url?.absoluteString
                self.imageView.kf.setImage(
                    with: resource,
                    placeholder : UIImage(named: urlImagePlaceholder),
                    options: [
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ]
                )
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Kingfisher Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Kingfisher Job failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
