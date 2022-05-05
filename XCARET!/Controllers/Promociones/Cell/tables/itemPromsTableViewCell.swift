//
//  itemPromsTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 21/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemPromsTableViewCell: UITableViewCell {
    weak var delegateOpcProm : ManageUpdateOpcPromDelegate?

    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    var myButtonsArray : [ItemsCatopcprom] = [ItemsCatopcprom]()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTyC: UILabel!
    var select : ItemsCatopcprom!
    var itemSelectOpction = 0
    var promo = ""
    var buttonsItemHeaderProm : [ItemsCatopcprom] = [ItemsCatopcprom]()
    @IBOutlet weak var lblduration: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.register(UINib.init(nibName: "ButtonOptionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ButtonOptions")
            self.collectionView.register(UINib.init(nibName: "buttonMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellMenuPromociones")
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        lblTyC.isUserInteractionEnabled = true
        lblTyC.addGestureRecognizer(tap)
        lblTyC.text = "lbl_terms_and_conditions".getNameLabel()
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        delegateOpcProm!.sendPopUpHome(typePopUp: "tyc")
    }
    
    
    func config(itemHeaderProm : [Itemslangs]){
            
            if promo != itemHeaderProm.first?.prod_code {
                promo = itemHeaderProm.first?.prod_code ?? "XC"
                itemSelectOpction = 0
            }

        
        let listCatopcprom = appDelegate.listlangCatopcprom.filter({$0.key == Constants.LANG.current})

        
        buttonsItemHeaderProm.removeAll()
        buttonsItemHeaderProm = listCatopcprom.filter({$0.lang_Promo == itemHeaderProm.first?.key_promotion})
        
        self.lblTitle.text = itemHeaderProm.first?.title
        self.lblDescription.text = itemHeaderProm.first?.title
        self.lblduration.text = itemHeaderProm.first?.duration
        var itemsButtonsmenu : [ItemsCatopcprom] = [ItemsCatopcprom]()
        
        if appDelegate.itemParkSelected.code != ""{
            let item = itemHeaderProm.first
            self.lblTitle.text = item!.title
            self.lblDescription.text = item!.description
            
        }else{
            let item = itemHeaderProm.first
            self.lblTitle.text = item!.title
            self.lblDescription.text = item!.description
        }
        
        
//        for itemslangsProm in buttonsItemHeaderProm{
//            if itemsButtonsmenu.isEmpty {
//                itemsButtonsmenu.append(itemslangsProm)
//            }else{
//                let itemP = itemsButtonsmenu.filter({$0.identifier == itemslangsProm.identifier})
//                if itemP.count == 0 {
//
//                    itemsButtonsmenu.append(itemslangsProm)
//                }
//            }
//        }
        
//        buttonsItemHeaderProm = itemsButtonsmenu
        myButtonsArray.removeAll()
        
//        let aux = appDelegate.itemParkSelected
        if appDelegate.itemParkSelected.p_type == "T" {
            myButtonsArray = buttonsItemHeaderProm.filter({ $0.identifier != "park"})
        }else{
            myButtonsArray = buttonsItemHeaderProm
        }
        
//        myButtonsArray.removeAll()
//        for index in buttonsItemHeaderProm{
//            if index.status {
//
//                if index.identifier == "tour"{
//                    let itemsPrecios = appDelegate.listPrecios.filter({$0.uid == itemHeaderProm.first?.prod_code})
//
//                    if appDelegate.itemParkSelected.code != ""{
//                        for itemPrecio in itemsPrecios.first!.productos.filter({$0.code_park == appDelegate.itemParkSelected.code.lowercased() && $0.distintivo == index.identifier }){
//
//                            let itemButton = buttonsItemHeaderProm.filter({$0.identifier == itemPrecio.distintivo})
//
//                            if !itemButton.isEmpty {
//                                myButtonsArray.append(index)
//                            }
//                        }
//                    }else{
//                        let itemButton = buttonsItemHeaderProm.filter({$0.identifier == index.identifier})
//
//                            if !itemButton.isEmpty {
//                                myButtonsArray.append(index)
//                            }
//                        }
//
//                }else{
//                    myButtonsArray.append(index)
//                }
//
//            }
//        }
        
        
        if myButtonsArray.isEmpty || myButtonsArray.count == 1{
            self.collectionView.isHidden = true
            self.bottomConstrain.constant = 19//80
        }else{
            self.collectionView.isHidden = false
            self.bottomConstrain.constant = 80//19
            myButtonsArray = myButtonsArray.sorted(by: { $0.order < $1.order })
            
        }
        
        self.collectionView.reloadData()
        
        let indexPath = IndexPath(item: itemSelectOpction, section: 0)
        if !myButtonsArray.isEmpty {
            DispatchQueue.main.async {
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
        }

        
        
    }
    
}

extension itemPromsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myButtonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonOptions", for: indexPath as IndexPath) as! ButtonOptionsCollectionViewCell
        cell.config(listButtonOpciones: myButtonsArray[indexPath.row], count : buttonsItemHeaderProm.count)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if myButtonsArray.count > indexPath.row{
            print(indexPath.row)
            itemSelectOpction = indexPath.row
            select = myButtonsArray[indexPath.row]
            delegateOpcProm?.sendItemOpcProm(select : select)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(UIScreen.main.bounds.size.width - 25) / myButtonsArray.count, height: 50)
    }
    
}
