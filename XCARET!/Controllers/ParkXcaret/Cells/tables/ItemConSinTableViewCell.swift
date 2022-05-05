//
//  ItemConSinTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/16/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class ItemConSinTableViewCell: UITableViewCell {
    weak var delegate : GoRoadDelegate?
    
    @IBOutlet weak var lblRehilete: UILabel!
    @IBOutlet weak var viewRehilete: UIView!
    @IBOutlet weak var collectSinSen: UICollectionView! {
        didSet{
            self.collectSinSen.register(UINib.init(nibName: "ItemLargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCVLarge")
        }
    }
    @IBOutlet weak var collectConSen: UICollectionView! {
        didSet{
            self.collectConSen.register(UINib.init(nibName: "ItemLargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCVLarge")
        }
    }
    @IBOutlet weak var lblSinSentido: UILabel!
    @IBOutlet weak var lblConSentido: UILabel!
    
    @IBOutlet weak var lblDescSinSentido: UILabel!
    @IBOutlet weak var lblDescConSentido: UILabel!
    
    
    
    @IBOutlet weak var viewContentAnimation: UIView!
    let animationView = AnimationView()
    
    var listActivitiesCon : [ItemActivity] = [ItemActivity]()
    var listActivitiesSin : [ItemActivity] = [ItemActivity]()
    var listActivitiesGen : [ItemActivity] = [ItemActivity]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Config de collection Sin Sentido
        let flowLayoutSin = UICollectionViewFlowLayout()
        flowLayoutSin.scrollDirection = .horizontal
        flowLayoutSin.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayoutSin.minimumLineSpacing = 0.0
        flowLayoutSin.minimumInteritemSpacing = 0.0
        self.collectSinSen.collectionViewLayout = flowLayoutSin
        self.collectSinSen.showsHorizontalScrollIndicator = false
        
        
        let flowLayoutCon = UICollectionViewFlowLayout()
        flowLayoutCon.scrollDirection = .horizontal
        flowLayoutCon.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayoutCon.minimumLineSpacing = 0.0
        flowLayoutCon.minimumInteritemSpacing = 0.0
        self.collectConSen.collectionViewLayout = flowLayoutCon
        self.collectConSen.showsHorizontalScrollIndicator = false
        
        self.viewRehilete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goDetail)))
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func goDetail(){
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goPinWheel.rawValue)
        delegate?.goToRoadActivities(itemSelected: 0, listActivities: listActivitiesGen)
    }
    
    func setInfoView(listActCon : [ItemActivity], listActSin: [ItemActivity], listActGen : [ItemActivity]){
        self.lblConSentido.text = "lbl_downtown".getNameLabel()//"lblDowntown".localized()
        self.lblSinSentido.text = "lbl_xensatorium".getNameLabel()//"lblXensatorium".localized()
        self.lblDescSinSentido.text = "lbl_desc_xensatorium".getNameLabel()//"lblDescXensatorium".localized()
        self.lblDescConSentido.text = "lbl_desc_downtown".getNameLabel()//"lblDescDowntown".localized()
        self.lblRehilete.text = "lbl_rehilete".getNameLabel().uppercased()//"lblRehilete".localized().uppercased()
        self.lblConSentido.transform  = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.lblDescConSentido.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.lblSinSentido.transform = CGAffineTransform(rotationAngle: 0)
        self.lblDescSinSentido.transform = CGAffineTransform(rotationAngle: 0)
        self.listActivitiesCon = listActCon
        self.listActivitiesSin = listActSin
        self.listActivitiesGen = listActGen
        if listActCon.count > 0 {
            collectConSen.delegate = self
            collectConSen.dataSource = self
        }
        
        if listActSin.count > 0 {
            collectSinSen.delegate = self
            collectSinSen.dataSource = self
        }
        
        let av = Animation.named("rehilete")
        self.animationView.animation = av
        self.animationView.loopMode = .loop
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.play()

        //print("Cuando mide la celda \(self.frame.height)")
        //print("Cuando mide la celda \(self.bounds.height)")
        self.addSubview(animationView)
        self.sendSubviewToBack(animationView)
        self.animationView.backgroundBehavior = .pauseAndRestore
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView.topAnchor.constraint(equalTo: viewContentAnimation.layoutMarginsGuide.topAnchor).isActive = true
        self.animationView.leadingAnchor.constraint(equalTo: viewContentAnimation.leadingAnchor).isActive = true
        self.animationView.bottomAnchor.constraint(equalTo: viewContentAnimation.layoutMarginsGuide.bottomAnchor).isActive = true
        self.animationView.trailingAnchor.constraint(equalTo: viewContentAnimation.trailingAnchor).isActive = true
        self.animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        
        UIView.animate(withDuration: 3) {
            self.lblSinSentido.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.lblDescSinSentido.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.lblConSentido.transform  = CGAffineTransform(rotationAngle: 0)
            self.lblDescConSentido.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

extension ItemConSinTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectSinSen {
            return listActivitiesSin.count
        }else if collectionView == collectConSen {
            return listActivitiesCon.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectSinSen {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath) as! ItemLargeCollectionViewCell
            cell.configureCell(itemActivity: listActivitiesSin[indexPath.row])
            return cell
        }else if collectionView == collectConSen {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath) as! ItemLargeCollectionViewCell
            cell.configureCell(itemActivity: listActivitiesCon[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var listActivities : [ItemActivity] = [ItemActivity]()
        if collectionView == collectSinSen {
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.listPathDoing.rawValue)
            listActivities = listActivitiesSin
        }else{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.listPathFeeling.rawValue)
            listActivities = listActivitiesCon
        }
        delegate?.goToRoadActivities(itemSelected: indexPath.row, listActivities: listActivities)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 150, height: 260)
    }
}
