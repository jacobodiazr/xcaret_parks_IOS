//
//  PopUp3ParksViewController.swift
//  XCARET!
//
//  Created by Hate on 10/11/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class PopUp3ParksViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ContraintHeight: NSLayoutConstraint!
    @IBOutlet weak var ConstraintWidht: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    var itemsPrecios : [ItemPark] = [ItemPark]()
    var itemIndex = 0
    var promos = [ItemProdProm]()
    
    @IBOutlet weak var collectionTP: UICollectionView!{
        didSet{
            self.collectionTP.register(UINib.init(nibName: "buttonMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellMenuPromociones")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prom = promos.first
        if promos.first?.cupon_promotion == "HSBCXC1"{
            itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XO" || $0.code == "XC" || $0.code == "XP"}).sorted(by: { $0.order < $1.order})
        }else if prom?.cupon_promotion == "SPRING2021"{
            if prom?.key == "XTXO"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XO"}).sorted(by: { $0.order < $1.order})
            }else if prom?.key == "XTXPTI"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XP"}).sorted(by: { $0.order < $1.order})
            }else if prom?.key == "XTXEOM"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XN"}).sorted(by: { $0.order < $1.order})
            }
        }else if prom?.cupon_promotion == "SSANTA2021"{
            if prom?.key == "XTXSEP"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XS"}).sorted(by: { $0.order < $1.order})
            }else if prom?.key == "XTXPTI"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XP"}).sorted(by: { $0.order < $1.order})
            }else if prom?.key == "XTXCPL"{
                itemsPrecios = appDelegate.listAllParks.filter({ $0.code == "XH" || $0.code == "XC"}).sorted(by: { $0.order < $1.order})
            }
        }
        
        self.ConstraintWidht.constant = UIScreen.main.bounds.width * 0.85
        self.ContraintHeight.constant = UIScreen.main.bounds.height * 0.85
        
        self.collectionTP.delegate = self
        self.collectionTP.dataSource = self
        
        let indexPath = IndexPath(item: 0, section: 0)
        DispatchQueue.main.async {
            self.collectionTP.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        self.lblTitle.text = "lbl_what_your_ticket_includes".getNameLabel()
        
        getData()

    }
    
    func getData() {
        let index = itemsPrecios[itemIndex]
        self.textView.text = "\n\(index.detail.p_schelude!) \n \n\(index.detail.include!) \n \n \("lbl_recomendations".getNameLabel().uppercased()): \n\(index.detail.recomendations!)"
    }
   
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension PopUp3ParksViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPrecios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMenuPromociones", for: indexPath as IndexPath) as! buttonMenuCollectionViewCell
        cell.lblItemMenu.text = itemsPrecios[indexPath.row].name
        cell.tresParques = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if itemsPrecios.count > indexPath.row{
            
            self.collectionTP.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.itemIndex = indexPath.row
            self.getData()
        }
        
    }
    
}
