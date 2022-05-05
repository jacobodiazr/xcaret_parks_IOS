//
//  ItemAlbumTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 4/2/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemAlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblVisit: UILabel!
    @IBOutlet weak var lblPhoto: UILabel!
    @IBOutlet weak var lblVisitDate: UILabel!
    @IBOutlet weak var lblTotalMedia: UILabel!
    @IBOutlet weak var viewShadowBlock: UIView!
    @IBOutlet weak var viewShadowUnblock: GradientView!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewIncluded: UIView!
    @IBOutlet weak var imgStatusLock: UIImageView!
    @IBOutlet weak var lblIncluded: UILabel!
    @IBOutlet weak var viewBreak: UIView!
    @IBOutlet weak var imgWarning: UIImageView!
    
    @IBOutlet weak var viewAllCell: UIView!
    @IBOutlet weak var viewMesage: UIView!
    @IBOutlet weak var lblDownload: UILabel!
    @IBOutlet weak var lblLeyendAlbum: UILabel!
    @IBOutlet weak var lblDateVigency: UILabel!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var heightViewMessageConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configureCell(isBook: Bool,itemAlbum : ItemAlbum, itemDetail : ItemAlbumDetail){
        self.lblPhoto.text = "lbl_no_photos".getNameLabel()//"lblNoPhotos".localized()
        self.lblVisit.text = "lbl_visit_date".getNameLabel()//"lblVisitDate".localized()
        self.lblIncluded.text = "lbl_included".getNameLabel()//"lblIncluded".localized().uppercased()
        self.viewShadowBlock.isHidden = true
        self.viewShadowUnblock.isHidden = true
        self.viewBlock.isHidden = true
        self.viewIncluded.isHidden = true
        self.imgLogo.image = UIImage(named: "Photo/logo/logo\(itemDetail.parkId ?? 1)")
        self.imgBackground.image = UIImage(named: "Photo/album/album_\(itemDetail.parkId ?? 1)")
        self.lblVisitDate.text = itemDetail.visitDate.dateFormat(format: "yyyy/MM/dd")
        self.lblTotalMedia.text = String(itemDetail.totalMedia)
        self.viewMesage.isHidden = true
        
        if itemAlbum.statusAlbum == TypeAlbumStatus.commigExpired{
            self.viewMesage.isHidden = false
            self.lblDownload.text = "lbl_validate_day_photopass_download".getNameLabel()
            self.lblLeyendAlbum.text = "lbl_validate_day_photopass".getNameLabel()
            self.lblDateVigency.text = itemAlbum.expiresDate.dateFormat(format: "yyyy-MM-dd")
            self.lblDownload.isHidden = false
            self.lblLeyendAlbum.isHidden = false
            self.lblDateVigency.isHidden = false
            self.imgWarning.isHidden = false
            self.lblDaysCount.isHidden = true
            self.viewAllCell.backgroundColor = UIColor(named: "Colors/bg_cell_comming")
            self.heightViewMessageConstraint.constant = 30
            
        }else if itemAlbum.statusAlbum == TypeAlbumStatus.recentAdd{
            self.viewMesage.isHidden = false
            let daysExpire : Int = itemAlbum.getDaysAvailable()
            let leyendA : String = "lbl_validate_photopassa".getNameLabel()
            let leyendB : String = "lbl_validate_photopassb".getNameLabel()
            self.lblDaysCount.text = "\(leyendA) \(daysExpire) \(leyendB)"
            self.lblDownload.isHidden = true
            self.lblLeyendAlbum.isHidden = true
            self.lblDateVigency.isHidden = true
            self.imgWarning.isHidden = true
            self.lblDaysCount.isHidden = false
            self.viewAllCell.backgroundColor = UIColor(named: "Colors/bg_cell_add")
            self.heightViewMessageConstraint.constant = 30
            
        }else{
            self.imgWarning.isHidden = true
            self.viewMesage.isHidden = true
            self.heightViewMessageConstraint.constant = 0
        }
        //Configuramos formato de vista
        //Si es no es hotel mostramos configuracion default
        if !isBook{
            self.viewShadowUnblock.isHidden = false
        }else{
            if (itemDetail.parkId == 8 || itemDetail.parkId == 11) && itemDetail.unlock == true{
                self.viewIncluded.isHidden = false
                self.viewShadowUnblock.isHidden = false
            }else if itemDetail.unlock{ //Si está desbloqueado
                self.viewShadowUnblock.isHidden = false
            }else{
                self.viewShadowBlock.isHidden = false
                self.viewBlock.isHidden = false
                self.imgStatusLock.image = UIImage(named: "Icons/photo/ic_lock_ios")
            }
        }
    }
}
