
import UIKit

class ColoredCardView: CardView {
    weak var ticketViewController : TicketsViewController?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblMainProduct: UILabel!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblReloj: UILabel!
    @IBOutlet weak var lblCodeBar: UILabel!
    @IBOutlet weak var viewHeaderTicket: UIView!
    @IBOutlet weak var ViewInfoTicket: UIView!
    @IBOutlet weak var ViewLeyend: UIView!
    @IBOutlet weak var lblLeyend: UILabel!
    @IBOutlet weak var ViewName: UIView!
    @IBOutlet weak var tblTickets: UITableView! {
        didSet{
            tblTickets.register(UINib(nibName: "ItemTProductTableViewCell", bundle: nil), forCellReuseIdentifier: "cellProduct")
            tblTickets.register(UINib(nibName: "ItemTPhotoPassTableViewCell", bundle: nil), forCellReuseIdentifier: "cellPhoto")
            tblTickets.register(UINib(nibName: "ItemHeaderProdTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderProd")
            tblTickets.register(UINib(nibName: "ItemFooterProdTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellFooterProd")
        }
    }
    
    var colorCard : UIColor!
    var strImgCard : String = ""
    var titleMonth : String = ""
    var itemTicket : ItemTicket! = ItemTicket()
    var timer = Timer()
    var statusTicket: String = "" {
        didSet {
            /*if itemTicket.listProducts.count > 1 {
                //itemTicket.listProducts =  itemTicket.listProducts.sorted(by: {$0.visitDate < $1.visitDate})
                for item in itemTicket.listProducts {
                    print("Ordenamiento \(itemTicket.barCode!) \(item.visitDate!) \(item.orderSort) \(item.familyProducto ?? "NA")")
                }
            }*/
            //Validamos el estatus del ticket
            if itemTicket.status.isEmpty || itemTicket.barCode.isEmpty{
                self.ViewLeyend.isHidden = false
                self.tblTickets.isHidden = true
                self.lblMainProduct.text = "Offline Ticket".uppercased()
                self.lblLeyend.text = "tickets_lbl_group_desc".getNameLabel()//"lblNotConection".localized()
                self.ViewName.backgroundColor = Constants.COLORS.TICKETS.ticketOff
            }else{
                self.ViewLeyend.isHidden = true
                self.tblTickets.isHidden = false
                if itemTicket.allVisit{
                    self.lblMainProduct.text = "tickets_lbl_visit".getNameLabel()//"lblThanksVisit".localized()
                    self.imgBarCode.alpha = 0.05
                }else{
                    var reservationStatus: ReservationStatus = .unknowned
                    if let reservationStatus = ReservationStatus.init(initString: itemTicket.status){
                        if reservationStatus == .paid {
                            self.lblMainProduct.text = "tickets_lbl_show".getNameLabel()
                            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
                        }else if reservationStatus == .cancel {
                            //Cancelado
                            self.lblMainProduct.text = "tickets_lbl_cancel".getNameLabel()
                            self.imgBarCode.alpha = 0.05
                        }else if reservationStatus == .chargeBack
                                || itemTicket.status.lowercased() == "reembolso" {
                            self.lblMainProduct.text = "lblContracargoVisit".localized()
                            self.imgBarCode.alpha = 0.05
                        }else{
                            self.lblMainProduct.text = "Offline Ticket".uppercased()
                            self.lblLeyend.text = "tickets_lbl_group_desc".getNameLabel()
                            self.ViewName.backgroundColor = Constants.COLORS.TICKETS.ticketOff
                        }
                    }
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
        presentedDidUpdate()
        tblTickets.delegate = self
        tblTickets.dataSource = self
    }
    
    override var presented: Bool { didSet { presentedDidUpdate() } }
    
    func presentedDidUpdate() {
        contentView.addTransitionFade()
    }
    
    @objc func tick() {
        self.lblReloj.text = DateFormatter.localizedString(from: Date(),
                                                              dateStyle: .medium,
                                                              timeStyle: .medium)
    }
}

extension ColoredCardView : UITableViewDelegate, UITableViewDataSource, GoDetailComponent {
    func goComponent(sender: ButtonDetComponent) {
        print("Desde tabla")
        ticketViewController?.openDetailComponent(sender: sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let listComplements = itemTicket.listProducts[section]
        //return listComplements.listComponents.count
        return itemTicket.listProducts.count
    }
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        //return itemTicket.listProducts.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemProduct = itemTicket.listProducts[section]
        //Si el producto no tiene complemento,
        if itemProduct.headerTable {
            let headerView : ItemHeaderProdTableViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderProd") as! ItemHeaderProdTableViewCell
            //headerView.lblHeaderProduct.text = "Prueba"
            headerView.lblHeaderProd.text = itemProduct.productName
            return headerView
        }else{
            return nil
        }
    }*/
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let product = itemTicket.listProducts[section]
        if !product.promocion.dsNombrePromocion.isEmpty{
            if product.promocion.dsCodigoPromocion == "HSBCXC" {
                let footer  : ItemFooterProdTableViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellFooterProd") as! ItemFooterProdTableViewCell
                    footer.imagePromotion.image = UIImage(named: "Tickets/imgProms/\(product.promocion.dsCodigoPromocion.uppercased())")
                return footer
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    /*func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let product = itemTicket.listProducts[section]
        if !product.promocion.dsNombrePromocion.isEmpty{
            return "Tiene Promocion"
        }else{
            return "-"
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Verificamos que tengamos
        let product = itemTicket.listProducts[indexPath.row]
        //let component = product.listComponents[indexPath.row]
        if !product.familyProducto.lowercased().contains("fotos"){
            let cell : ItemTProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ItemTProductTableViewCell
            //cell.setInfoView(itemComponent: component)
            cell.setInfoView(itemProduct: product)
            cell.delegateComp = self
            return cell
        }else{
            let cell : ItemTPhotoPassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath) as! ItemTPhotoPassTableViewCell
            return cell
        }
    }
    
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let itemProduct = itemTicket.listProducts[section]
        if itemProduct.headerTable {
            return 40
        }else{
            return 0
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let itemProduct = itemTicket.listProducts[section]
        if !itemProduct.promocion.dsNombrePromocion.isEmpty {
            if itemProduct.promocion.dsCodigoPromocion == "HSBCXC" {
                return 150
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    
}
