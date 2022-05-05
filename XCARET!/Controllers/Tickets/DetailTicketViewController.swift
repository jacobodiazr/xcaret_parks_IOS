//
//  DetailTicketViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 02/10/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import UIKit

class DetailTicketViewController: UIViewController {
    //var itemComponent : ItemComponent = ItemComponent()
    var itemProduct : ItemProduct = ItemProduct()
    var listInfoPark : [ItemDetInfoTicket] = [ItemDetInfoTicket]()
    
    @IBOutlet weak var ViewPage: UIView!
    @IBOutlet weak var viewInformation: UIView!
    @IBOutlet weak var lblAdmission: UILabel!
    @IBOutlet weak var lblDateEvent: UILabel!
    @IBOutlet weak var llbNoAdults: UILabel!
    @IBOutlet weak var lblNoChildrens: UILabel!
    @IBOutlet weak var lblNoInfants: UILabel!
    @IBOutlet weak var tableInfo: UITableView!
    
    @IBOutlet weak var lblIncludeAyB: UILabel!
    @IBOutlet weak var lblIncludePhotopass: UILabel!
    @IBOutlet weak var lblIncludeTranslate: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblPickupHotel: UILabel!
    
    @IBOutlet weak var viewInfoTranslate: UIView!
    @IBOutlet weak var topTableInfoConstraint: NSLayoutConstraint!
    //Titles
    @IBOutlet weak var lblTitleDateVisit: UILabel!
    @IBOutlet weak var lblTitleAdults: UILabel!
    @IBOutlet weak var lblTitleChild: UILabel!
    @IBOutlet weak var lblTitleInfants: UILabel!
    @IBOutlet weak var lblTitleAyB: UILabel!
    @IBOutlet weak var lblTitlePhotopass: UILabel!
    @IBOutlet weak var lblTitleTransportation: UILabel!
    @IBOutlet weak var lblTitlePickup: UILabel!
    @IBOutlet weak var lblTitlePickupHotel: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var viewLineTitle: UIView!
    @IBOutlet weak var viewLineInfo: UIView!
    @IBOutlet weak var viewLinePickup: UIView!
    
    var colorCard : UIColor!
    var strImgCard : String = ""
    var titleMonth : String = ""
    var codeIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewHeader.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
    }

    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadInfo(){
        let aux = itemProduct
        switch itemProduct.un {
        case "XC":
            colorCard = Constants.COLORS.TICKETS.ticketXC
            strImgCard = "Photo/logo/logo1"
        case "XH":
            colorCard = Constants.COLORS.TICKETS.ticketXH
            strImgCard = "Photo/logo/logo2"
        case "XS":
            colorCard = Constants.COLORS.TICKETS.ticketXS
            strImgCard = "Photo/logo/logo7"
        case "XP" :
            colorCard = Constants.COLORS.TICKETS.ticketXP
            strImgCard = "Photo/logo/logo4"
        case "XPF", "XF" :
            colorCard = Constants.COLORS.TICKETS.ticketXPF
            strImgCard = "Photo/logo/logo5"
        case "XV" :
            colorCard = Constants.COLORS.TICKETS.ticketXV
            strImgCard = "Photo/logo/logo9"
        case "XN" :
            colorCard = Constants.COLORS.TICKETS.ticketDEF
            strImgCard = "Photo/logo/logo3"
        case "XO", "XON" :
            colorCard = Constants.COLORS.TICKETS.ticketXO
            strImgCard = "Photo/logo/logo6"
        case "XT" :
            colorCard = Constants.COLORS.TICKETS.ticketXT
            strImgCard = "Photo/logo/logo10"
        case "XY" :
            colorCard = Constants.COLORS.TICKETS.ticketXY
            strImgCard = "Photo/logo/logo12"
        default:
            colorCard = Constants.COLORS.TICKETS.ticketOff
            strImgCard = "Logos/logoGroup"
            break
        }
        
        
        
        self.lblTitleDateVisit.text = "lbl_ticket_date".getNameLabel()//"lblDateOfVisit".localized()
        self.lblTitleAdults.text = "lbl_ticket_adults".getNameLabel()//"lblAdults".localized()
        self.lblTitleChild.text = "lbl_ticket_childrens".getNameLabel()//"lblChildrens".localized()
        self.lblTitleInfants.text = "lbl_ticket_infants".getNameLabel()//"lblInfants".localized()
        self.lblTitleAyB.text = "lbl_food_and_beverages".getNameLabel()//"lblAyB".localized()
        self.lblTitlePhotopass.text = "lbl_ticket_photopass".getNameLabel()//"lblPhotopass".localized()
        self.lblTitleTransportation.text = "lbl_ticket_transportation".getNameLabel()//"lblTransportation".localized()
        self.lblTitlePickup.text = "\("lbl_location_pickup".getNameLabel()):"//"lblLocationPickup".localized()
        self.lblTitlePickupHotel.text = "\("lbl_schedules".getNameLabel()):"//"lblSchedulePickup".localized()
        self.viewHeader.backgroundColor = colorCard
        self.imgHeader.image = UIImage(named: strImgCard)!
        self.viewLineInfo.backgroundColor = colorCard
        self.viewLineTitle.backgroundColor = .clear//colorCard
        self.viewLinePickup.backgroundColor = colorCard
        let aux2 = itemProduct.productName
        let aux1 = itemProduct
        lblAdmission.text = itemProduct.productName
        lblDateEvent.text = Tools.shared.castDateTicket(dateStr: itemProduct.visitDate)
        llbNoAdults.text = "\(itemProduct.adults)"
        lblNoChildrens.text = "\(itemProduct.childrens)"
        lblNoInfants.text = "\(itemProduct.infants)"
        lblIncludeAyB.text = itemProduct.hasAYB ? "lbl_included".getNameLabel() : "lbl_Title_not_include".getNameLabel()
        lblIncludePhotopass.text = itemProduct.hasPhotopass ? "lbl_included".getNameLabel(): "lbl_Title_not_include".getNameLabel()
        lblIncludeTranslate.text = itemProduct.hasPickup ? "lbl_included".getNameLabel() : "lbl_Title_not_include".getNameLabel()
        lblAdmission.adjustsFontSizeToFitWidth = true
        //Si tiene pickup mostramos la info
        if itemProduct.hasPickup{
            self.lblPickup.text = itemProduct.locationPickup
            self.lblPickupHotel.text = Tools.shared.getFormatHours(hour: itemProduct.timePickup, format: "HH:mm:ss")
        }else{
            self.viewInfoTranslate.isHidden = true
            self.topTableInfoConstraint.constant = -(self.viewInfoTranslate.frame.size.height + 10)
        }
        
        loadInfoPark()
    }
    
    func loadInfoPark(){
        FirebaseBR.shared.getParkBySivexCode(sivexCode: itemProduct.un, promotion: itemProduct.promocion) { (InfoPark) in
            self.listInfoPark = InfoPark
            if self.listInfoPark.count > 0 {
                self.tableInfo.delegate = self
                self.tableInfo.dataSource = self
            }
        }
    }
}

extension DetailTicketViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listInfoPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let item = listInfoPark[indexPath.row]
        
        if item.typeInfo == "DEF"{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let item = listInfoPark[indexPath.row]
            cell.textLabel?.textColor = Constants.COLORS.TICKETS.colorCancel
            cell.detailTextLabel?.textColor = Constants.COLORS.TICKETS.colorCancel
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.desc
        }else if item.typeInfo == "PROMO" {
            if itemProduct.promocion.dsCodigoPromocion.contains("HSBCXC"){
                let cellHsbc = tableView.dequeueReusableCell(withIdentifier: "cellHsbc", for: indexPath) as! CellHsbcTableViewCell
                cellHsbc.titleHsbc?.text = item.title
                cellHsbc.subTitleHsbc?.text = item.desc
                return cellHsbc
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.desc
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.desc
            cell.textLabel?.textColor = UIColor.darkGray
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
