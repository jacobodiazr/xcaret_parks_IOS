//
//  ItemAllTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/31/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemAllTableViewCell: UITableViewCell {
    weak var delegate : ChangeHeightTableView?
    weak var delegateAct : GoDetailActDelegate?

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCVContraint: NSLayoutConstraint!
    
    var listActivities : [ItemActivity] = [ItemActivity]()
    var recordsArray : [ItemActivity] = [ItemActivity]()
    var limit = 20
    var totalEnteries = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if appDelegate.itemParkSelected.code == "XC"{
             self.heightCVContraint.constant = 11700
        }else if appDelegate.itemParkSelected.code == "XH"{
             self.heightCVContraint.constant = 5650
        }else{
            self.heightCVContraint.constant = 2100
        }
       
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfoView(listActivities: [ItemActivity]){
        //self.count = 0
        self.listActivities = listActivities
        self.lbltitle.text = "lbl_see_all".getNameLabel()//"lblAllActivities".localized()
        var index = 0
        self.totalEnteries = listActivities.count
        //while index < limit {
        while index < totalEnteries {
            recordsArray.append(listActivities[index])
            index = index + 1
        }
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.collectionView.reloadData()
        
    }
    
    func changeHeight(){
        self.heightCVContraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 250
        delegate?.changeHeightRow(newHeight: self.collectionView.collectionViewLayout.collectionViewContentSize.height + 250)
    }
}


extension ItemAllTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listActivities.count //recordsArray.count //55
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPinterest", for: indexPath as IndexPath) as! ItemPinterestCollectionViewCell
        cell.configureCell(itemActivity: listActivities[indexPath.row])
        //Caundo sea el ultimo elemento lo ajustamos
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegateAct?.gotoDetail(activity: listActivities[indexPath.row])
        print("Height : \(self.collectionView.collectionViewLayout.collectionViewContentSize.height)")
        self.heightCVContraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 100
        delegate?.changeHeightRow(newHeight: self.collectionView.collectionViewLayout.collectionViewContentSize.height + 100)
    }
}

extension ItemAllTableViewCell : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if listActivities[indexPath.row].act_extra {
            return 300
        }else{
            let number = Float.random(in: 180 ..< 250)
            return CGFloat(number)
        }
    }
}
