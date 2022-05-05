//
//  itemPromocionesCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 17/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class itemPromocionesCollectionViewCell: UICollectionViewCell {
    
    let storageRef = Storage.storage().reference()
    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var constraintH: NSLayoutConstraint!
    @IBOutlet weak var ConstraintW: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    let promotions = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true}).sorted(by: {$0.order < $1.order})

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContentImage.dropShadow(color: UIColor.gray, opacity: 0.3, offSet: CGSize(width: 2, height: 3), radius:3, scale: true, corner: 10, backgroundColor: UIColor.clear)
        
//        constraintH.constant = UIScreen.main.bounds.height * 0.10//0.24
//        ConstraintW.constant = UIScreen.main.bounds.width * 0.93
        
    }
    
    
    func config(promotion : Itemslangs){
        
        self.loadImageCache(imageName: promotion.image, codePark: "promotions")
    }
    
    func configPromotions(promotion: ItemPrecios){
        let img = promotions.filter({$0.prod_code == promotion.uid}).first
        var uidParkSelect = img?.image
        if  (uidParkSelect?.contains("mc") ?? false) && appDelegate.itemParkSelected.code != ""{
            uidParkSelect = "\(img?.image ?? "")_\(appDelegate.itemParkSelected.code.lowercased())"
        }
        self.loadImageCache(imageName: uidParkSelect ?? "", codePark: "promotions")
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
                        
                        var imageLocal = UIImage(named: "Promociones/images/promociones/default")
                        if imageLocal == nil{
                            imageLocal = UIImage(named: "Promociones/images/promociones/default")
                            if imageLocal == nil{
                                imageLocal = UIImage(named: "Promociones/images/promociones/default")
                            }
                        }
                        
//                        if appDelegate.itemParkSelected.code == "XV"{
//                            imageLocal = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(imageName)")
//                        }
                        self.img.image = imageLocal
                    case .disk:
                        print("Cache Disk")
                        DispatchQueue.main.async { self.img.image = value.image }
                    case .memory:
                        print("Cache Memory")
                        DispatchQueue.main.async { self.img.image = value.image }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }else{
            //Si no existe vamos al kingFisher
            self.loadImageFirestore(imageName: imageName, codePark: codePark)
        }
    }
    
    func loadImageFirestore(imageName: String, codePark: String){
        let imageRef = storageRef.child("/store/promotion")
        let fileRef = imageRef.child("\(imageName).jpg")
        
        //Vamos por la imagen a Firestore
        fileRef.downloadURL { (url, error) in
            if let error = error {
                print("No se obtuvo url: \(error.localizedDescription)")
                self.img.image = UIImage(named: "Promociones/images/promociones/default")
            }else{
                //let resource = ImageResource(downloadURL: url, cacheKey: "\(url.absoluteString)")
                var urlImagePlaceholder = "Promociones/images/promociones/default"
                
                let resource = ImageResource(downloadURL: url!, cacheKey:  "\(codePark)\(imageName)")
                //url?.absoluteString
                self.img.kf.setImage(
                    with: resource,
                    placeholder : UIImage(named: urlImagePlaceholder),
                    options: [
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                    ]
                ){
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
