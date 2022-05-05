//
//  ItemLargeCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 11/14/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


class ItemLargeCollectionViewCell: UICollectionViewCell {
    let storageRef = Storage.storage().reference()
    @IBOutlet weak var btnHeart: FavoriteButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var heightViewGradient: NSLayoutConstraint!
    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var imgExtra: UIImageView!
    @IBOutlet weak var leadingLeftLblTitleContraint: NSLayoutConstraint!
    @IBOutlet weak var ViewTopImage: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }
    
    override func layoutSubviews() {
        configDarkModeCustom()
        imgActivity.layer.cornerRadius = 20
        viewGradient.layer.cornerRadius = 20
    }
    
    public func configureCell(itemActivity : ItemActivity){
        if appDelegate.itemParkSelected.code == "XS"{
            self.imgExtra.image = UIImage(named: "Icons/ico_mia")
            self.imgExtra.isHidden = !itemActivity.act_new
            self.leadingLeftLblTitleContraint.constant = !itemActivity.act_new ? -30 : 10
        }else{
            self.leadingLeftLblTitleContraint.constant = !itemActivity.act_extra ? -30 : 10
            self.imgExtra.isHidden = !itemActivity.act_extra
        }
        if appDelegate.itemParkSelected.code == "XV" && itemActivity.category.cat_code == "XTREME" {
            ViewTopImage.constant = 15
        }else{
            ViewTopImage.constant = 0
        }
        
        self.btnHeart.uid = itemActivity.uid
        self.btnHeart.name = itemActivity.nameES
        //self.btnHeart.viewClicFav = tagGr
        
        
        if (appDelegate.itemParkSelected.code == "XI" || appDelegate.itemParkSelected.code == "XA" || appDelegate.itemParkSelected.code == "FE") {
            self.imgExtra.isHidden = true
            self.btnHeart.isHidden = true
            //self.btnHeart.removeFromSuperview()
        }else{
//            self.imgExtra.isHidden = false
            self.btnHeart.isHidden = false
        }
        
        self.lblTitle.text = itemActivity.details.name
        let imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
        
        if imageName == nil{
            self.loadImageCache(imageName:"\(itemActivity.act_image ?? "")", codePark: appDelegate.itemParkSelected.code!.lowercased())
        }
        
        self.imgActivity.image = imageName
        // configDarkModeCustom()
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
                        
                        self.imgActivity.image = imageLocal
                    case .disk:
                        print("Cache Disk")
                        DispatchQueue.main.async { self.imgActivity.image = value.image }
                    case .memory:
                        print("Cache Memory")
                        DispatchQueue.main.async { self.imgActivity.image = value.image }
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
                self.imgActivity.image = UIImage(named: "Parks/\(codePark.uppercased())/Activities/ThumbsNew/\(imageName)")
                if appDelegate.itemParkSelected.code == "XV"{
                    self.imgActivity.image = UIImage(named: "Parks/\(codePark.uppercased())/Activities/\(imageName)")
                }
                if self.imgActivity.image == nil{
                    self.imgActivity.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
                }
            }else{
                //let resource = ImageResource(downloadURL: url, cacheKey: "\(url.absoluteString)")
                var urlImagePlaceholder = "Parks/\(codePark.uppercased())/Activities/ThumbsNew/\(imageName)"
                if appDelegate.itemParkSelected.code == "XV"{
                    urlImagePlaceholder = "Parks/\(codePark.uppercased())/Activities/\(imageName)"
                }
                let resource = ImageResource(downloadURL: url!, cacheKey:  "\(codePark)\(imageName)")
                //url?.absoluteString
                self.imgActivity.kf.setImage(
                    with: resource,
                    placeholder : UIImage(named: urlImagePlaceholder),
                    options: [
                        .transition(.fade(0)),
                        .cacheOriginalImage
                    ], completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print("Kingfisher Task done for: \(value.source.url?.absoluteString ?? "")")
                                
                            case .failure(let error):
                                print("Kingfisher Job failed: \(error.localizedDescription)")
                            }
                        })
            }
        }
    }
    
    public func configureCell(itemEvent : ItemEvents){
        self.imgExtra.isHidden = true
        self.btnHeart.isHidden = true
        self.leadingLeftLblTitleContraint.constant = -30
        self.lblTitle.text = itemEvent.getDetail.name
        
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemEvent.ev_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
    }
    
    
    public func configureCellIMGS(count : Int){
        self.imgExtra.isHidden = true
        self.btnHeart.isHidden = true
        self.leadingLeftLblTitleContraint.constant = -30
        self.lblTitle.isHidden = true
        
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/xo_kermes\(count)")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
    }
    
    public func configureCellXN(itemActivity : ItemActivity){
        self.imgExtra.isHidden = true
        self.btnHeart.isHidden = true
        self.leadingLeftLblTitleContraint.constant = -30
        self.lblTitle.isHidden = false
        self.lblTitle.text = itemActivity.details.name
        
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
    }
    
    public func configureCellXIStatic(){
        self.imgExtra.isHidden = true
        self.btnHeart.isHidden = true
        self.lblTitle.isHidden = true
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/xi_cenote")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
    }
    
    func configDarkModeCustom(){
        if appDelegate.itemParkSelected.code == "XF" {
            viewContentImage.dropShadow(color: UIColor.black, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.black)
        }else{
            viewContentImage.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        }
    }
}
