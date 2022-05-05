//
//  itemsPakTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 17/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemsPakTableViewCell: UITableViewCell {
    weak var delegate : GoToPromBar?
    @IBOutlet weak var constraintH: NSLayoutConstraint!
    @IBOutlet weak var viewContentCollection: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var colllectionItemsPark: UICollectionView! {
        didSet{
            self.colllectionItemsPark.register(UINib.init(nibName: "itemPromocionesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPromosTienda")
        }
    }
    var timer = Timer()
    var counter = 0
    var touch = false
    var promotions = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current}).sorted(by: {$0.order < $1.order}) //&& $0.status == true}).sorted(by: {$0.order < $1.order})
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aux = promotions
        print(aux)
        let aux2 =  appDelegate.listlangsPromotions
        print(aux2)
        self.colllectionItemsPark.delegate = self
        self.colllectionItemsPark.dataSource = self
        
//        if appDelegate.listlangsPromotions.count > 0 {
//            let auxProms = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true}).sorted(by: {$0.order < $1.order}).last
//            promotions.insert(auxProms!,at:0)
//            promotions.remove(at: promotions.count - 1)
//        }
        
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(item: 4, section: 0)
//            self.counter = indexPath.row
//            self.colllectionItemsPark.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//        }
        timerOn()
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.92, height : 170.0)//height: UIScreen.main.bounds.height * 0.20)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 1
        floawLayout.sideItemAlpha = 1
        floawLayout.spacingMode = .fixed(spacing: 0.0)
        colllectionItemsPark.collectionViewLayout = floawLayout
        
        titleLbl.text = "lbl_promotions_shop".getNameLabel()
    }
    
    func timerOn(){
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
    }
    
    func timerOff(){
        self.timer.invalidate()
    }
    
    @objc func changeImage(){
        if counter < promotions.count {
            UIView.animate(withDuration: 10, animations: { [weak self] in
                let index = IndexPath.init(item: self!.counter, section: 0)
                self?.colllectionItemsPark.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self?.colllectionItemsPark.layoutIfNeeded()
            })
            counter += 1
        } else {
            counter = 0
            UIView.animate(withDuration: 20, animations: { [weak self] in
                let index = IndexPath.init(item: self!.counter, section: 0)
                self?.colllectionItemsPark.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self?.colllectionItemsPark.layoutIfNeeded()
            })
            counter = 1
        }
    }

    func setPositionActivity(index : IndexPath){

        if promotions.count > index.row{
            let indexPath = IndexPath(item: index.row, section: 0)
            self.colllectionItemsPark.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

extension itemsPakTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPromosTienda", for: indexPath as IndexPath) as! itemPromocionesCollectionViewCell
        cell.config(promotion: promotions[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if promotions.count > indexPath.row{
            self.timer.invalidate()
            appDelegate.itemParkSelected = ItemPark()
            self.colllectionItemsPark.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            counter = indexPath.row
            AnalyticsBR.shared.saveEventSelectPromotion(promId: promotions[indexPath.row].uidProm, promName: promotions[indexPath.row].prod_code, creativeName: promotions[indexPath.row].image)
            appDelegate.idAction = promotions[indexPath.row].prod_code
            self.delegate?.goToPromBar(item : indexPath.row)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = colllectionItemsPark.frame.size
//        return CGSize(width: size.width, height: size.height)
//    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.timer.invalidate()
//        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
        if self.colllectionItemsPark.isDecelerating{
//            print("isDecelerating")
        }else{
//            print("Not isDecelerating")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//        print("isDecelerating = false")
        var visibleRect = CGRect()
        visibleRect.origin = colllectionItemsPark.contentOffset
        visibleRect.size = colllectionItemsPark.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = colllectionItemsPark.indexPathForItem(at: visiblePoint) else { return }
        counter = indexPath.row
        self.setPositionActivity(index: indexPath)
    }
}
