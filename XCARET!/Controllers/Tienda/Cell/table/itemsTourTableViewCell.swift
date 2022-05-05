//
//  itemsTourTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 18/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemsTourTableViewCell: UITableViewCell {
    weak var delegate : GoToPromBar?
    var typeCell : TypeCellShop?
    var itemsShop : ItemShop?
    
    var typeLayout : String!
    var countItems = 0
    
    var timer = Timer()
    var counter = 0
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constraintH: NSLayoutConstraint!
    @IBOutlet weak var collectionTours: UICollectionView! {
        didSet{
            self.collectionTours.register(UINib.init(nibName: "itemTxPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemTxP")
            self.collectionTours.register(UINib.init(nibName: "itemPromocionesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPromosTienda")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionTours.delegate = self
        collectionTours.dataSource = self
    
    }
    
    func setInfo(itemsShop: ItemShop){
        self.itemsShop = itemsShop
        typeCell = itemsShop.typeCell
        switch itemsShop.typeCell {
        case .cellTours:
            lblTitle.isHidden = false
            lblTitle.text = "lbl_tours_shop".getNameLabel()//itemsShop.name
            constraintH.constant = itemsShop.heightCV
            constraintTop.constant = 15
        case .cellPacks:
            lblTitle.isHidden = false
            lblTitle.text = "lbl_paks_shop".getNameLabel()
            constraintH.constant = itemsShop.heightCV
            constraintBottom.constant = 15
        default:
            print("ok..")
        }
        self.collectionTours.reloadData()
    }
    
}

extension itemsTourTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeCell == .cellTours{
            return self.itemsShop?.tours.count ?? 0
        }else if typeCell == .cellPacks{
            return self.itemsShop?.packs.count ?? 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if typeCell == .cellTours{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemTxP", for: indexPath as IndexPath) as! itemTxPCollectionViewCell
            cell.config(items: (itemsShop?.tours[indexPath.row])!,sizeConstraintHimg: UIScreen.main.bounds.height * 0.17, sizeConstraintWView: UIScreen.main.bounds.width * 0.62)
            return cell
        }else if typeCell == .cellPacks{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemTxP", for: indexPath as IndexPath) as! itemTxPCollectionViewCell
            cell.config(items: (itemsShop?.packs[indexPath.row])!, sizeConstraintHimg: UIScreen.main.bounds.height * 0.24, sizeConstraintWView: UIScreen.main.bounds.width * 0.92, shadow: true)
            return cell
        }else{
            let cell = UICollectionViewCell()
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if typeCell == .cellTours{
            if self.itemsShop?.tours.count ?? -1 > indexPath.row{
                self.collectionTours.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                counter = indexPath.row
                appDelegate.idAction = (self.itemsShop?.tours[indexPath.row].code)!
                appDelegate.itemParkSelected = (self.itemsShop?.tours[indexPath.row])!
                self.delegate?.goToPromBar(item : indexPath.row)
            }
        }else if typeCell == .cellPacks{
            if self.itemsShop?.packs.count ?? -1 > indexPath.row{
                self.collectionTours.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                counter = indexPath.row
                appDelegate.idAction = (self.itemsShop?.packs[indexPath.row].code)!
                self.delegate?.goToPromBar(item : indexPath.row)
            }
        }
            
    }
    
    
}
