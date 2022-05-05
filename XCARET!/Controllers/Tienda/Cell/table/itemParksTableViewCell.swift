//
//  itemParksTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 18/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemParksTableViewCell: UITableViewCell {
    weak var delegate : GoToPromBar?
    @IBOutlet weak var contraintH: NSLayoutConstraint!
    @IBOutlet weak var constraintwImg: NSLayoutConstraint!
    @IBOutlet weak var constraintCollectionH: NSLayoutConstraint!
    @IBOutlet weak var viewParkPref: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVisit: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var parkPref = ItemPark()//appDelegate.listAllParksEnabled.filter({$0.order == 2}).first
    var parks = [ItemPark]()
    @IBOutlet weak var collectionParks: UICollectionView! {
        didSet{
            self.collectionParks.register(UINib.init(nibName: "itemParkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemParkS")
            self.collectionParks.register(UINib.init(nibName: "itemTxPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemTxP")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.goPromParkPref))
        self.viewParkPref.addGestureRecognizer(gesture)
        
        collectionParks.delegate = self
        collectionParks.dataSource = self
        
        
        lblTitle.text = "lbl_best_promotions_shop".getNameLabel()
        lblVisit.text = "lbl_visit_shop".getNameLabel()
        lblFrom.text = "lbl_from_shop".getNameLabel()
    }
    
    @objc func goPromParkPref(){
        let aux = parkPref
        appDelegate.itemParkSelected = parkPref
        delegate?.goToPromBar(item: 0)
    }
    
    func setInfoView(itemPark: ItemShop){
        
        self.parkPref = itemPark.parkPref.first ?? ItemPark()
        self.parks = itemPark.park
        configParkPref()
        configParks()
        self.collectionParks.reloadData()
        
    }
    
    func configParkPref(){
        
        let listPrecios = appDelegate.listPrecios
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == parkPref.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key == Constants.CURR.current})
        
        if price?.first?.precio != 0.0{
            self.lblFrom.isHidden = false
            self.lblPrice.isHidden = false
            self.lblPrice.text = price?.first?.precio.currencyFormat()
        }else{
            self.lblFrom.isHidden = true
            self.lblPrice.isHidden = true
        }
        lblName.text = parkPref.name
        var imagen = UIImage(named: "Shop/destacar/\(parkPref.code.uppercased())")
        if imagen == nil{
            imagen = UIImage(named: "Shop/destacar/default")
        }
        self.img.image = imagen
    }
    
    func configParks(){
        contraintH.constant = UIScreen.main.bounds.height * 0.15
        constraintwImg.constant = (UIScreen.main.bounds.width - 30) * 0.65
        let itemsCount = ceil(CGFloat(parks.count) / CGFloat(3))
        constraintCollectionH.constant = (((UIScreen.main.bounds.width - 60) / 3) + 52) * CGFloat(itemsCount)
    }
    
}

extension itemParksTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemTxP", for: indexPath as IndexPath) as! itemTxPCollectionViewCell
        cell.constrainLeftMargin.constant = 0
        cell.ConstraintRightMargin.constant = 0
        cell.lblName.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.lblPrice.font = UIFont.systemFont(ofSize: 13.0)
        let constraintHxW = (UIScreen.main.bounds.width - 60) / 3
        cell.config(items : parks[indexPath.row], sizeConstraintHimg : constraintHxW, sizeConstraintWView : constraintHxW)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if parks.count > indexPath.row{
            let aux = parks[indexPath.row]
            appDelegate.itemParkSelected = parks[indexPath.row]
            delegate?.goToPromBar(item: indexPath.row)

        }
        
    }
    
}


