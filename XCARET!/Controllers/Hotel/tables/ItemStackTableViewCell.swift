//
//  ItemStackTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 6/27/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemStackTableViewCell: UITableViewCell {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            self.collectionView.register(UINib(nibName: "ItemRoomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellRoom")
            self.collectionView.register(UINib(nibName: "ItemAllFunCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellAFI")
        }
    }
    
    var listDetail : [ItemDetailImages] = [ItemDetailImages]()
    var sizeItem : CGSize!
    var itemInfo : ItemInfoHotel!
    
    @IBOutlet weak var heightCVConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func configTableCell(itemInfo : ItemInfoHotel){
        self.heightCVConstraint.constant = itemInfo.heighView.height + 10
        self.itemInfo = itemInfo
        self.txtTitle.text = itemInfo.title
        self.txtDescription.text = itemInfo.subtitle
        self.listDetail = itemInfo.listDetailImages
        self.sizeItem = itemInfo.heighView
        self.collectionView.reloadData()
        if itemInfo.typeCellHotel == .cellAFI{
            self.txtTitle.textColor = Constants.COLORS.HOTEL.mexicanPink
        }else{
            self.txtTitle.textColor = Constants.COLORS.GENERAL.colorLine
        }
    }
}

extension ItemStackTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if itemInfo.typeCellHotel == .cellStack{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellRoom", for: indexPath) as! ItemRoomCollectionViewCell
            cell.configureCell(itemDetail: listDetail[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAFI", for: indexPath) as! ItemAllFunCollectionViewCell
            cell.configureCell(itemDetail: listDetail[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeItem
    }
}
