//
//  homePrefTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 21/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class homePrefTableViewCell: UITableViewCell {
    weak var delegateXafety : ManageControllersDelegateXafety?
    weak var delegateHome : ManageControllersDelegateHome?
    var listpaksHome : [ItemPark] = [ItemPark]()
    var sizeItem : CGSize!
    @IBOutlet weak var animationViewXafety: AnimationView!
    @IBOutlet weak var constraintTopDevice: NSLayoutConstraint!
    @IBOutlet weak var constraintTopAnimationDevice: NSLayoutConstraint!
    
    
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.register(UINib.init(nibName: "parkPrefHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "parkPrefHomeCell")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        constraintTopDevice.constant = UIDevice().getTopHomeCardPref()
        constraintTopAnimationDevice.constant = UIDevice().getTopHomeCardPref() + 10
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 30.0, height: collectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 1.0
        floawLayout.spacingMode = .fixed(spacing: 5.0)
        collectionView.collectionViewLayout = floawLayout
        
        let indexPath = IndexPath(item: 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        
        loadLottieXafety()

    }
    
    func loadLottieXafety(){
        //Cargamos animacion
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.goXafety))
        self.animationViewXafety.addGestureRecognizer(gesture)
        let filename = "360"
        let av = Animation.named(filename)
        self.animationViewXafety.animation = av
        self.animationViewXafety.loopMode = .loop
        self.animationViewXafety.play()
    }
    
    @objc func goXafety(){
        
        if !CheckInternet.Connection() {
            UpAlertView(type: .error, message: "lbl_err_not_network".getNameLabel()).show {
                print("Error")
            }
        }else{
            delegateXafety?.callWebXafety()
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    func setInfoView(itemHome: ItemHome){
            self.listpaksHome = itemHome.parksHome
            self.sizeItem = itemHome.sizeCell
            self.heightCollectionViewConstraint.constant = itemHome.heightCV
            self.collectionView.reloadData()
            self.animationViewXafety.play()
        }
}

extension homePrefTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listpaksHome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parkPrefHomeCell", for: indexPath as IndexPath) as! parkPrefHomeCollectionViewCell
        cell.configureCell(itemPark: listpaksHome[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listpaksHome.count > indexPath.row{
            delegateHome?.sendItemPark(itemPark: listpaksHome[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeItem
    }
    
    
    
}
