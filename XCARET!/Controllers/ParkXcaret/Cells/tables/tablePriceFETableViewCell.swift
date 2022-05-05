//
//  tablePriceFETableViewCell.swift
//  XCARET!
//
//  Created by YEiK on 26/01/22.
//  Copyright © 2022 Angelica Can. All rights reserved.
//

import UIKit

class tablePriceFETableViewCell: UITableViewCell {

    @IBOutlet weak var lblViaje: UILabel!
    @IBOutlet weak var titlePriceAdulto: UILabel!
    @IBOutlet weak var titlePriceMenor: UILabel!
    @IBOutlet weak var tblHeigtSize: NSLayoutConstraint!
    
    let tblHeigtSizeConstant : CGFloat = 67.0
    
    
    var listPriceFE = [ListPriceFE]()
    
    var numberOfRows: Int = 0
    var backgroundColorRow: Bool = false
    
    @IBOutlet weak var tablaInfoPriceFE: UITableView! {
        didSet{
            tablaInfoPriceFE.register(UINib(nibName: "infoPriceFETableViewCell", bundle: nil), forCellReuseIdentifier: "cellInfoPriceFE")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tablaInfoPriceFE.delegate = self
        tablaInfoPriceFE.dataSource = self
        
        tblHeigtSize.constant = tblHeigtSizeConstant
    }
    
    func setInfoView(itemHome: ItemHome){
        lblViaje.text = "lbl_ferrie_trip".getNameLabel()
        titlePriceAdulto.text = "lbl_ferrie_price_adults".getNameLabel()
        titlePriceMenor.text = "lbl_ferrie_price_child".getNameLabel()
        tblHeigtSize.constant = 0.0
        var itemsListPriceFE = [ListPriceFE]()
        let itemsListProducts = appDelegate.listProducts.filter({ $0.uid_park == itemHome.listAdmissions.first?.key_park && $0.status_product == 1 })
        for item in itemsListProducts {
            let productPromotions = appDelegate.listProductsPromotions.filter({$0.key_product == item.uid && $0.status == 1})
            for promotion in productPromotions {
                let itemsPrices = appDelegate.listProductPrices.filter({ $0.key_product == item.uid && $0.key_promotion == promotion.key_promotion})
                
                for itemPrice in itemsPrices {
                    
                    let titleProduct = appDelegate.listDatalangProduct.filter({ $0.key_product == itemPrice.key_product && $0.uid == Constants.LANG.current.lowercased() })
                    let namePromotion = appDelegate.listPromotions.filter({ $0.uid == promotion.key_promotion })//key_promotion
                    
                    var adultoPrice = "0.00"
                    var menorPrice = "0.00"
                    if itemPrice.paxType.lowercased() == "adulto" {
                        adultoPrice = itemPrice.price == "0.00" ? itemPrice.priceDiscount : itemPrice.price
                    }else{
                        menorPrice = itemPrice.price == "0.00" ? itemPrice.priceDiscount : itemPrice.price
                    }
                    
                    let itemPriceFE = ListPriceFE()
                    itemPriceFE.uid = itemPrice.uid
                    itemPriceFE.uid_park = item.uid_park
                    itemPriceFE.key_promotion = itemPrice.key_promotion
                    itemPriceFE.key_product = itemPrice.key_product
                    itemPriceFE.title = titleProduct.first?.shortDescription
                    itemPriceFE.adultoPrice = adultoPrice
                    itemPriceFE.menorPrice = menorPrice
                    itemPriceFE.orden = item.order
                    itemPriceFE.namePromotion = namePromotion.first?.code.replacingOccurrences(of: "_", with: " ") ?? ""
                    itemPriceFE.paxType = itemPrice.paxType
                    itemsListPriceFE.append(itemPriceFE)
                }
            }
        }
        
        listPriceFE.removeAll()
        for itemListPriceFE in itemsListPriceFE {
            let itemExist = listPriceFE.filter({ $0.key_product == itemListPriceFE.key_product && $0.key_promotion == itemListPriceFE.key_promotion})

            if itemExist.count > 0 {
                print(itemExist)
                let itemIndex = listPriceFE.index(where: { $0.key_product == itemListPriceFE.key_product && $0.key_promotion == itemListPriceFE.key_promotion })
                let paxType = listPriceFE[itemIndex ?? 0].paxType ?? ""
                if paxType == "adulto" {
                    listPriceFE[itemIndex ?? 0].menorPrice = itemListPriceFE.menorPrice
                }else{
                    listPriceFE[itemIndex ?? 0].adultoPrice = itemListPriceFE.adultoPrice
                }
                print(paxType)
            }else{
                print(itemExist)
                listPriceFE.append(itemListPriceFE)
            }

            print(listPriceFE)
        }
        
        listPriceFE = listPriceFE.sorted(by: {$0.orden < $1.orden})
        numberOfRows = listPriceFE.count

        tblHeigtSize.constant = CGFloat(listPriceFE.count) * tblHeigtSizeConstant
        print(tblHeigtSize.constant)
    }
    
   
    
}

extension tablePriceFETableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellInfoPriceFE", for: indexPath) as! infoPriceFETableViewCell
        cell.configInfo(listPriceFE : listPriceFE[indexPath.row])
        if backgroundColorRow {
            backgroundColorRow = !backgroundColorRow
            cell.backgroundColor = UIColor(red: 234/255, green: 240/255, blue: 245/255, alpha: 1.0)
        }else{
            backgroundColorRow = !backgroundColorRow
        }
        
        return cell
    }
    
    
}
