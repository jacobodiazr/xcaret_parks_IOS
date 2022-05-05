//
//  ItemActExtraTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/18/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemActExtraTableViewCell: UITableViewCell {
    
    weak var delegate : ManageControllersDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            self.collectionView.register(UINib.init(nibName: "ItemLargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCVLarge")
        }
    }
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    
    var sizeItem : CGSize!
    var listActivities : [ItemActivity] = [ItemActivity]()
    var tagClic : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.clipsToBounds = true
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
        imageview.image = UIImage(named: "Headers/bg_tbl")
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.zPosition = -1
        self.backgroundView = imageview
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInfoView(itemHome: ItemHome, newHeight: CGFloat){
        self.tagClic = itemHome.idEventFB
        self.lblTitle.text = itemHome.name
        self.lblDescription.text = itemHome.description
        self.listActivities = itemHome.listActivities
        self.heightCollectionViewConstraint.constant = itemHome.heightCV
        self.sizeItem = itemHome.sizeCell
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension ItemActExtraTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listActivities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath as IndexPath) as! ItemLargeCollectionViewCell
        cell.heightViewGradient.constant = cell.imgActivity.frame.height / 2
        cell.configureCell(itemActivity: listActivities[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendDetailActivity(activity: listActivities[indexPath.row], idEvent: tagClic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeItem
    }
}
