//
//  HeaderXensesView.swift
//  XCARET!
//
//  Created by Angelica Can on 7/30/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class HeaderXensesView: UIView {
    let storageRef = Storage.storage().reference()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var btnHeart: FavoriteSimpleButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnMIA: UIImageView!
    @IBOutlet weak var viewShadowGradient: GradientView!
    @IBOutlet weak var heightGradientViewConstraint: NSLayoutConstraint!
    var heightGradient : CGFloat = 0.0 {
        didSet {
            self.heightGradientViewConstraint.constant = heightGradient / 3
        }
    }
    
    let pathLocalImage = "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew"
    weak var dataViewController : DataActivityViewController?
    var galleryActivity : [ItemPicture] = [ItemPicture]()
    
    var imageName: String = "ok" {
        didSet{
            self.imageView.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(imageName)")
            self.loadImageCache(imageName: imageName, codePark: appDelegate.itemParkSelected.code!.lowercased())
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.btnGallery.imageView!.setImageColor(color: UIColor.white)
        self.cornerDropShadowView.setTrapecioShadow()
        UIView.animate(withDuration: 3) {
            self.btnGallery.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 30)
        }
    }
    
    func setInformation(item: ItemActivity){
        print(imageName)
        //self.imageView.image = UIImage(named: "\(pathLocalImage)/\(item.act_image!)")
        //btnHeart.typeStyle = "XEN"
        btnHeart.uid = item.uid
        btnHeart.name = item.nameES
        //btnHeart.viewClicFav = tag
        galleryActivity = item.gallery
        btnGallery.isHidden = item.gallery.count > 0 ? false : true
        btnMIA.isHidden = !item.act_new
        //heightGradientViewConstraint.constant = self.bounds.height/2
        //Animamos los elementos del header
    }
    
    @IBAction func btnSendDetail(_ sender: UIButton) {
        //Agregar funcion de Analitycs
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.goGallery.rawValue)
        self.dataViewController?.openGalleryActivity(gallery: galleryActivity)
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
                        var imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(imageName)")
                        if imageLocal == nil{
                            imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
                        }
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
            }else{
                //let resource = ImageResource(downloadURL: url, cacheKey: "\(url.absoluteString)")
                let resource = ImageResource(downloadURL: url!, cacheKey:  "\(codePark)\(imageName)")
                //url?.absoluteString
                self.imageView.kf.setImage(
                    with: resource,
                    placeholder : UIImage(named: "Parks/\(codePark.uppercased())/Activities/ThumbsNew/\(imageName)"),
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
