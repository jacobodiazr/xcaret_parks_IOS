//
//  ItemAwardTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 07/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ItemAwardTableViewCell: UITableViewCell {
    var listAwards : [ItemAward] = [ItemAward]()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.register(UINib.init(nibName: "itemReconocimientosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellItemAward")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setInfoView(itemHome: ItemHome){
        self.listAwards = itemHome.listAwards
        self.lblTitle.text = itemHome.name
    }
}

extension ItemAwardTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAwards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItemAward", for: indexPath) as! itemReconocimientosCollectionViewCell
        cell.configCell(itemAward: listAwards[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 145)
    }
    
}
