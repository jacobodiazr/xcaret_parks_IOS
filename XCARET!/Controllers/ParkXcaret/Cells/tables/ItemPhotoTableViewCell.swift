//
//  ItemPhotoTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 3/27/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie


protocol OpenPhotopassDelegate : class {
    func getAction(type: String)
}

class ItemPhotoTableViewCell: UITableViewCell {
    weak var delegate : OpenPhotopassDelegate?
    
    @IBOutlet weak var topsizeHome: NSLayoutConstraint!
    @IBOutlet weak var lblTitlePhoto: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblTitleTickets: UILabel!
    
    @IBOutlet weak var animationTicket: AnimationView!
    @IBOutlet weak var ViewPhotos: UIView!
    @IBOutlet weak var viewTickets: UIView!
    
    @IBOutlet weak var animationCarrito: AnimationView!
    @IBOutlet weak var titleCarritoLbl: UILabel!
    @IBOutlet weak var viewCarrito: UIView!
    @IBOutlet weak var poinrCS: UIView!
    
    
    
    @IBOutlet weak var rightViewPhotoConstraint: NSLayoutConstraint!
    var itemBooking : ItemBookingConfig!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        poinrCS.isHidden = true
        
        if appDelegate.itemParkSelected.code == "XF" {
            ViewPhotos.shadowColor = .black
            viewTickets.shadowColor = .black
        }
        if appDelegate.optionsHome{
            self.topsizeHome.constant = UIDevice().getHeightViewCode()
        }
        
        
    }
    
    func pointCarShop(){
        if appDelegate.listItemListCarshop.count > 0 {
            if (appDelegate.listItemListCarshop.first?.detail.count ?? 0) > 0 {
                poinrCS.isHidden = false
            }else{
                poinrCS.isHidden = true
            }
        }else{
            poinrCS.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.ViewPhotos.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:))))
        self.viewTickets.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.someTickets(_:))))
        self.viewCarrito.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.someCarrito(_:))))
    }
    
    
    func setInfoView(){
        self.itemBooking = appDelegate.bookingConfig
        self.lblTitlePhoto.text = "lbl_title_photos_by_album".getNameLabel()
        self.lblTitleTickets.text = "lbl_title_tickets".getNameLabel()
        self.titleCarritoLbl.text = "lbl_cart_title".getNameLabel()
        //Cargamos animacion
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
        self.animationView.addGestureRecognizer(gesture)
        let filename = "camara_ios"
        let av = Animation.named(filename)
        self.animationView.animation = av
        self.animationView.loopMode = .loop
        self.animationView.play()
        
        let filenameTicket = "ticket"
        let avTicket = Animation.named(filenameTicket)
        self.animationTicket.animation = avTicket
        self.animationTicket.loopMode = .loop
        self.animationTicket.play()
        self.viewTickets.isHidden = false
        
        
        let filenameCarrito = "canasta"
        let avCarrito = Animation.named(filenameCarrito)
        self.animationCarrito.animation = avCarrito
        self.animationCarrito.loopMode = .loop
        self.animationCarrito.play()
        
        pointCarShop()
        
//        let intoThePark = LocationSingleton.shared.inThePark()
//        FirebaseBR.shared.getCodePromo(inPark: intoThePark) { (cupon) in
//            if !cupon.code.isEmpty{
//                self.viewTickets.isHidden = false
//            }else{
//
//            }
//        }
    }
    
    @objc func someAction(_ sender : UITapGestureRecognizer){
        print("Enviar al delegate")
        delegate?.getAction(type: "P")
    }
    
    @objc func someTickets(_ sender : UITapGestureRecognizer){
        print("Enviar al delegate")
        delegate?.getAction(type: "T")
    }
    
    @objc func someCarrito(_ sender : UITapGestureRecognizer){
        print("Enviar al delegate")
        delegate?.getAction(type: "C")
    }
}
