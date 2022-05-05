//
//  CardCarShopTableViewCell.swift
//  XCARET!
//
//  Created by Yeik on 31/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class CardCarShopTableViewCell: UITableViewCell {
    
    weak var delegateGoBooking: GoBooking?
    
    @IBOutlet weak var nameProdLbl: UILabel!
    @IBOutlet weak var descripProdLbl: UILabel!
    @IBOutlet weak var openVloseBtn: UIImageView!
    @IBOutlet weak var priceProdLbl: UILabel!
    @IBOutlet weak var opneCloseView: UIView!
    @IBOutlet weak var tableConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBuyPark: UIButton!
    @IBOutlet weak var faltaInfoLbl: UILabel!
    @IBOutlet weak var SeguroIkeView: UIView!
    @IBOutlet weak var seguroIkeConstraint: NSLayoutConstraint!
    @IBOutlet weak var fotoView: UIView!
    @IBOutlet weak var fotoContraint: NSLayoutConstraint!
    @IBOutlet weak var priceIke: UILabel!
    @IBOutlet weak var sizeClosePhoto: NSLayoutConstraint!
    @IBOutlet weak var sizeButtons: NSLayoutConstraint!
    @IBOutlet weak var packsPhotopassLbl: UILabel!
    @IBOutlet weak var addIkeButton: UIButton!
    @IBOutlet weak var infoIKEBtn: UIView!
    @IBOutlet weak var contraintMensajeError: NSLayoutConstraint!
    @IBOutlet weak var exclusivoMXN: UIView!
    @IBOutlet weak var btnBuyConstraintM: NSLayoutConstraint!
    @IBOutlet weak var btnConstraintM: NSLayoutConstraint!
    @IBOutlet weak var promotionAppliedLbl: UILabel!
    @IBOutlet weak var ikeTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoBtnIkeConstraint: NSLayoutConstraint!
    @IBOutlet weak var IkeBtnSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var seguriIKELabel: UILabel!
    @IBOutlet weak var removeCardPark: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    
    var caducado = true
    var close = true
    var dataPark : ItemProdProm!
    var dataInfo : ItemCarshop!
    var dataCarShop : [ItemCarShoop]!
    var spaceDataProducts = 244.0
    var sizeCardClose = 180.0
    var spaceDataProductsConstraint = 0
    var addIke = false
    
    @IBOutlet weak var itemsCarProductsTbl: UITableView!{
        didSet{
            itemsCarProductsTbl.register(UINib(nibName: "InfoCardCarShopTableViewCell", bundle: nil), forCellReuseIdentifier: "infoCardCarShop")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        seguriIKELabel.text = "lbl_cart_ike_assistance".getNameLabel()
        btnBuyPark.setTitle("lbl_cart_pay_park".getNameLabel(), for: .normal)
        removeCardPark.setTitle("lbl_cart_remove".getNameLabel(), for: .normal)
        photoLabel.text = "lbl_cart_digital_photo_package".getNameLabel()
        
        itemsCarProductsTbl.delegate = self
        itemsCarProductsTbl.dataSource = self
        
        faltaInfoLbl.isHidden = true
        contraintMensajeError.constant = 0
        
        exclusivoMXN.isHidden = true
        
//        contentConstraint.constant = 635.0
        
        let imagen = UIImage(named: "Icons/dropdown2")
        self.openVloseBtn.image = imagen
        openVloseBtn.image = openVloseBtn.image?.withRenderingMode(.alwaysTemplate)
        openVloseBtn.tintColor = UIColor.white
        //        tableConstraint.constant = 0
        //        contentConstraint.constant = CGFloat(sizeCardClose)
        
        //        contentImgHeight.constant = (UIScreen.main.bounds.width - 30) / 3
        //        contentImgWidht.constant = (UIScreen.main.bounds.width - 30) / 3
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeOpenClose))
        self.opneCloseView.addGestureRecognizer(gesture)
        
        let gestureinfoIKE = UITapGestureRecognizer(target: self, action:  #selector(self.infoIKE))
        self.infoIKEBtn.addGestureRecognizer(gestureinfoIKE)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        delegateGoBooking?.deleteItem(deleteItem: dataInfo)
    }
    
    @objc func infoIKE(){
        delegateGoBooking?.infoIKE()
    }
    
    @objc func changeOpenClose(){
        
        //        if close {
        //            let imagen = UIImage(named: "Icons/ico_dropdown")
        //            self.openVloseBtn.image = imagen
        //            tableConstraint.constant = 0
        //            contentConstraint.constant = CGFloat(sizeCardClose)
        //            close = !close
        //        }else{
        //            let imagen = UIImage(named: "Icons/dropdown2")
        //            self.openVloseBtn.image = imagen
        //            tableConstraint.constant = CGFloat(spaceDataProducts) * CGFloat(dataInfo.products.count)
        //            contentConstraint.constant = CGFloat(sizeCardClose) + ( CGFloat(spaceDataProducts) * CGFloat(dataInfo.products.count))
        //            close = !close
        //        }
        //        openVloseBtn.image = openVloseBtn.image?.withRenderingMode(.alwaysTemplate)
        //        openVloseBtn.tintColor = UIColor.white
        //        itemsCarProductsTbl.reloadData()
        
        delegateGoBooking?.closeItem(closeItem: !dataInfo.close, item: dataInfo)
        
//        delegateGoBooking?.closeItem(closeItem: false, item: dataInfo)
    }
    
    func configCard(item : ItemCarshop, itemCarShop : [ItemCarShoop]){
        dataInfo = item
        dataCarShop = itemCarShop
        priceIke.text = "\("lbl_add_plus_per_person".getNameLabel()) \(item.products.first?.productApiRequest.assistanceCarShop.adults.currencyFormat() ?? "")"
        
        var sizeExcMXN = 0.0
        exclusivoMXN.isHidden = true
        btnBuyConstraintM.constant = 0.0
        btnConstraintM.constant = 0.0
        if itemCarShop.first?.itemDiaCalendario.promotionApplied.status.lowercased() == "notapplied" {
            exclusivoMXN.isHidden = false
            sizeExcMXN = 45.0
            btnBuyConstraintM.constant = -7.5
            btnConstraintM.constant = -7.5
            if itemCarShop.first?.itemDiaCalendario.promotionApplied.detailStatus.status.lowercased() == "currency" {
                promotionAppliedLbl.text = "\("lbl_cart_exclusively_pesos".getNameLabel()) \(itemCarShop.first?.itemDiaCalendario.promotionApplied.detailStatus.status.description ?? "")"
            }else{
                promotionAppliedLbl.text = itemCarShop.first?.itemDiaCalendario.promotionApplied.detailStatus.status.description ?? ""
            }
        }
        
        var priceProdLblHidden = false
        close = item.close
        if close {
            let imagen = UIImage(named: "Icons/ico_dropdown")
            self.openVloseBtn.image = imagen
            tableConstraint.constant = 0
            contentConstraint.constant = CGFloat(sizeCardClose) + sizeExcMXN
            sizeButtons.constant = 80.0
            SeguroIkeView.isHidden = true
            seguroIkeConstraint.constant = 0
            fotoView.isHidden = true
            fotoContraint.constant = 0
            sizeClosePhoto.constant = 0
            
            if item.products.count > 1 {
                for itemProd in item.products {
                    if itemProd.availabilityStatus == false {
                        if itemProd.availabilityStatus == false || item.products.first?.productTransport == false ||  item.products.first?.productApiRequest.transportCarShop.geographicName == "" {
                            priceProdLblHidden = true
//                            contentConstraint.constant = CGFloat(sizeCardClose) + 50
//                            sizeButtons.constant = 130.0
                        }
                    }
                }
            }else{
                if (!(item.products.first?.availabilityStatus)!) || ((item.products.first?.productTransport ?? false) && item.products.first?.productApiRequest.transportCarShop.geographicName == "") {
//                    contentConstraint.constant = CGFloat(sizeCardClose) + 50
//                    sizeButtons.constant = 130.0
                }
            }
            
            close = !close
        }else{
            let imagen = UIImage(named: "Icons/dropdown2")
            self.openVloseBtn.image = imagen
            tableConstraint.constant = CGFloat(spaceDataProducts) * CGFloat(dataInfo.products.count)
            contentConstraint.constant = CGFloat(sizeCardClose) + ( CGFloat(spaceDataProducts) * CGFloat(dataInfo.products.count)) + 60 + (sizeExcMXN)
            sizeClosePhoto.constant = 5
            SeguroIkeView.isHidden = false
            seguroIkeConstraint.constant = 60
            fotoView.isHidden = true
            fotoContraint.constant = 0
            var countPacksPhotopass = 0
            var countPacksIke = 0
            for itemdatafoto in dataInfo.products {
                if itemdatafoto.productPhotopass == true {
                    countPacksPhotopass = countPacksPhotopass + 1
                    fotoView.isHidden = false
                    fotoContraint.constant = 50
                    contentConstraint.constant = CGFloat(sizeCardClose) + ( CGFloat(spaceDataProducts) * CGFloat(dataInfo.products.count)) + 110 + sizeExcMXN
                    if countPacksPhotopass > 1{
                        packsPhotopassLbl.text = "\(countPacksPhotopass) \(Constants.LANG.current == "es" ? "Paquetes" : "Packages")"
                    }else{
                        packsPhotopassLbl.text = "1 \(Constants.LANG.current == "es" ? "Paquete" : "Package")"
                    }
                }
                
//                addIkeButton.setTitle("Agregar", for: .normal)
//                addIkeButton.setTitleColor(.systemBlue, for: .normal)
//                addIkeButton.borderColor = .systemBlue
                if itemCarShop.first?.itemComplementos.seguroIKE.id != 0 && itemCarShop.first?.itemComplementos.seguroIKE.productKey != "" {
                    priceIke.isHidden = false
                    ikeTitleConstraint.constant = -10
                    infoBtnIkeConstraint.constant = -10
                    IkeBtnSizeConstraint.constant = 80
                    addIkeButton.setTitle("lbl_btn_cart_ike_add".getNameLabel(), for: .normal)
                    addIkeButton.setTitleColor(.systemBlue, for: .normal)
                    addIkeButton.borderWidth = 1
                    addIkeButton.borderColor = .systemBlue
                    priceIke.text = "\("lbl_add_plus_per_person".getNameLabel()) \(item.products.first?.productApiRequest.assistanceCarShop.adults.currencyFormat() ?? "")"
                }else{
                    IkeBtnSizeConstraint.constant = 100
                    addIkeButton.setTitle("lbl_add_plus_not_available".getNameLabel(), for: .normal)
                    addIkeButton.setTitleColor(.systemGray, for: .normal)
                    addIkeButton.isUserInteractionEnabled = false
                    addIkeButton.borderWidth = 0
                    priceIke.isHidden = true
                    ikeTitleConstraint.constant = 0
                    infoBtnIkeConstraint.constant = 0
                    
                }
                
                if itemdatafoto.productIke == true {
                    countPacksIke = countPacksIke + 1
                    addIkeButton.setTitle("lbl_btn_cart_ike_remove".getNameLabel(), for: .normal)
                    addIkeButton.setTitleColor(.systemRed, for: .normal)
                    addIkeButton.borderColor = .systemRed
                }
            }
            
            
            if item.products.count > 1 {
                for itemProd in item.products {
                    if itemProd.availabilityStatus == false {
                        if itemProd.availabilityStatus == false || item.products.first?.productTransport == false ||  item.products.first?.productApiRequest.transportCarShop.geographicName == "" {
                            priceProdLblHidden = true
//                            contentConstraint.constant = contentConstraint.constant + 50
                        }
                    }
                }
            }else{
                if (!(item.products.first?.availabilityStatus)!) || ((item.products.first?.productTransport ?? false) && item.products.first?.productApiRequest.transportCarShop.geographicName == "") {
//                    contentConstraint.constant = contentConstraint.constant + 50
                }
                
                
            }
            close = !close
            
        }
        
        openVloseBtn.image = openVloseBtn.image?.withRenderingMode(.alwaysTemplate)
        openVloseBtn.tintColor = UIColor.white
        
        btnBuyPark.isEnabled = true
        btnBuyPark.alpha = 1
        
        caducado = (item.products.first?.availabilityStatus)!
        
        self.nameProdLbl.text = item.promotionName.replacingOccurrences(of: "_", with: " ")
        
        if item.products.count > 1 {
            descripProdLbl.text = ""
            
            if priceProdLblHidden {
                btnBuyPark.isEnabled = false
                btnBuyPark.alpha = 0.5
//                faltaInfoLbl.isHidden = false
//                contraintMensajeError.constant = 31.5
            }
            
            if (item.products.first?.productTransport ?? false) && item.products.first?.productApiRequest.transportCarShop.geographicName == "" {
                //                btnBuyPark.borderWidth = 0
                //                btnBuyPark.setTitleColor(.systemBlue, for: .normal)
                //                btnBuyPark.setTitle("Agregar Transportación", for: .normal)
                
                btnBuyPark.isEnabled = false
                btnBuyPark.alpha = 0.5
//                faltaInfoLbl.isHidden = false
//                contraintMensajeError.constant = 31.5
            }
            let subtotal = item.discountPrice.currencyFormat()
            self.priceProdLbl.text = subtotal
            self.priceProdLbl.isHidden = priceProdLblHidden
            
        }else{
            let subtotal = item.discountPrice.currencyFormat()
            self.priceProdLbl.text = subtotal
            descripProdLbl.text = item.products.first?.productName.capitalized
            
            self.priceProdLbl.isHidden = !(item.products.first?.availabilityStatus)!
            
            if !(item.products.first?.availabilityStatus)! {
                btnBuyPark.isEnabled = false
                btnBuyPark.alpha = 0.5
//                faltaInfoLbl.isHidden = false
//                contraintMensajeError.constant = 31.5
            }
            if (item.products.first?.productTransport ?? false) && item.products.first?.productApiRequest.transportCarShop.geographicName == "" {
                
                btnBuyPark.isEnabled = false
                btnBuyPark.alpha = 0.5
//                faltaInfoLbl.isHidden = false
//                contraintMensajeError.constant = 31.5
            }
            
            if itemCarShop.first?.itemDiaCalendario.allotmentAvail.activityAvail.status.lowercased() != "open" && itemCarShop.first?.itemDiaCalendario.allotmentAvail.activityAvail.status != "" {
                btnBuyPark.isEnabled = false
                btnBuyPark.alpha = 0.5
            }
//            itemDiaCalendario.allotmentAvail.activityAvail.status
//            itemCarShop.itemDiaCalendario.allotmentAvail.activityAvail.status.lowercased() == "open" && itemCarShop.itemDiaCalendario.allotmentAvail.activityAvail.status.lowercased() != "" {
            //            var foto = 0.0
            //            var ike = 0.0
            //            let price = item.price
            //            if item.products.first?.productPhotopass ?? false {
            //                foto = item.products.first?.productApiRequest.photopassCarShop.amount ?? 0.0
            //            }
            //
            //            if item.products.first?.productIke ?? false {
            //                ike = item.products.first?.productApiRequest.assistanceCarShop.amount ?? 0.0
            //            }
            //
            
            
        }
        itemsCarProductsTbl.reloadData()
    }
    
    @IBAction func goBooking(_ sender: Any) {
        delegateGoBooking?.goTermsBooking(buyItem : dataInfo, dataCarShop: dataCarShop)
    }
    
    @IBAction func addIke(_ sender: Any) {
        let status = !(dataInfo.products.first?.productIke ?? false)
        delegateGoBooking?.AddIKE(prodAddIKE : dataInfo, status: status)
    }
    
}

extension CardCarShopTableViewCell: GoBookingInfo{
    func editItemInfo(IdItem : String) {
        delegateGoBooking?.editItem(editItem: dataInfo, IdItem : IdItem)
    }
}

extension CardCarShopTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataInfo.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataInfo.products[indexPath.row]
        let itemKey = dataCarShop.filter({ $0.keyItemEditCarShop == item.key})
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCardCarShop", for: indexPath) as! InfoCardCarShopTableViewCell
        cell.configInfoCard(item : item, itemCarShop: itemKey.first ?? ItemCarShoop() )
        cell.delegateGoBookingInfo = self
        return cell
    }
    
}
