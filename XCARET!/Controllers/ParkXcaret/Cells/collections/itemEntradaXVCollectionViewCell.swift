//
//  itemEntradaXVCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 08/11/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit


class itemEntradaXVCollectionViewCell: UICollectionViewCell {
    weak var itemActTableViewCell : ItemActTableViewCell?
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var imageTextura: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnComprar: UIButton!
    @IBOutlet weak var lblAdmissionActivities: UILabel!
    @IBOutlet weak var lblTitleAdmissionLeadig: NSLayoutConstraint!
    @IBOutlet weak var viewImageContent: UIView!
    @IBOutlet weak var viewContentBottom: UIView!
    var itemAdmission: ItemAdmission!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContent.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        viewContent.layer.cornerRadius = 20
        
    }
    
    override func layoutSubviews() {
        viewImage.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        viewContentBottom.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        viewGradient.layer.cornerRadius = 10
    }

    public func configureCell(itemAdmission : ItemAdmission){
        self.itemAdmission = itemAdmission
        let primaryColor:UIColor = UIColor().parseSplitedStringToColor(separatedBy: "|", colorText: itemAdmission.ad_primary_RGB)
        let secundaryColor:UIColor = UIColor().parseSplitedStringToColor(separatedBy: "|", colorText: itemAdmission.ad_secundary_RGB)
        
        viewContentBottom.backgroundColor = primaryColor
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Entradas/\(itemAdmission.ad_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.viewImage.image = imageName
        
        //Configuramos image textura
        if appDelegate.itemParkSelected.code == "XV"{
            imageTextura.image = UIImage(named: "Headers/\(appDelegate.itemParkSelected.code ?? "XV")/textura")
            imageTextura.setImageColor(color: primaryColor)
        }else{
            imageTextura.image = UIImage(named: "Headers/\(appDelegate.itemParkSelected.code ?? "XV")/textura_azul")
        }
        
        
        
        btnComprar.borderColor = secundaryColor
        btnComprar.setTitleColor(secundaryColor, for: .normal)
        btnComprar.setTitle("lbl_buy".getNameLabel(), for: .normal)
        
        self.lblTitle.text = itemAdmission.getDetail.name
        self.lblSubTitle.text = itemAdmission.getDetail.description
        var admissionActivitiesText = ""
        for admissionActivitie in itemAdmission.listAdmissionsActivities.sorted(by: { $0.order < $1.order }){
            admissionActivitiesText = "\(admissionActivitiesText) - \(appDelegate.listActivitiesByPark.filter({ $0.uid == admissionActivitie.key_activity }).first?.details.name ?? "")\n"
        }
        lblAdmissionActivities.text = admissionActivitiesText
        
        let intoThePark = LocationSingleton.shared.inThePark()
        FirebaseBR.shared.getCodePromo(inPark: intoThePark) { (cupon) in
            //Valida que exista cupon y que este habilitado el boton
            if !cupon.code.isEmpty && itemAdmission.ad_buy == 1 {
                self.btnComprar.isHidden = false
            }else{
                self.btnComprar.isHidden = true
                self.lblTitleAdmissionLeadig.constant = -50
                //self.lblMarginLeading.constant = 10
            }
        }
    }
    
    
    @IBAction func btnCompra(_ sender: Any) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goBooking.rawValue)
        itemActTableViewCell?.goBookingXV(typeItemBuyXV: itemAdmission.ad_code)
    }
}
