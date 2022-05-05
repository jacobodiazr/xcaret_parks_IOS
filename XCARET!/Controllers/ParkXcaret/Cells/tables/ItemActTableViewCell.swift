//
//  ItemActTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/17/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit


class ItemActTableViewCell: UITableViewCell {
    weak var delegate : ManageControllersDelegate?
    weak var delegateHome : ManageControllersDelegateHome?
    weak var delegateXO : ManageControllersDelegateXO?
    weak var delegateXV : GoBookingXVDelegate?
    //@IBOutlet weak var topLblDescConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDescriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var topCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopLine: UIView!
    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet weak var bottonConstLine: NSLayoutConstraint!
    @IBOutlet weak var contentViewBG: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            self.collectionView.register(UINib.init(nibName: "ItemLargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCVLarge")
            self.collectionView.register(UINib.init(nibName: "ItemCircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCVCircle")
            self.collectionView.register(UINib.init(nibName: "itemEntradaXVCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellTipoEntrada")
            self.collectionView.register(UINib.init(nibName: "itemXO_KermesMexicanaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellXOKermesMexicana")
            self.collectionView.register(UINib.init(nibName: "itemXO_KermesTourCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellXOKermesTour")
            self.collectionView.register(UINib.init(nibName: "itemXO_FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellXOMenu")
            self.collectionView.register(UINib.init(nibName: "ItemActExtraTableViewCell", bundle: nil), forCellWithReuseIdentifier: "cellActExtra")
            self.collectionView.register(UINib.init(nibName: "parkPrefHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "parkPrefHomeCell")
            self.collectionView.register(UINib.init(nibName: "parkHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "parkHomeCell")
            
        }
    }
    
    var sizeItem : CGSize!
    var listActivities : [ItemActivity] = [ItemActivity]()
    var listAdmissions : [ItemAdmission] = [ItemAdmission]()
    var listEvents : [ItemEvents] = [ItemEvents]()
    var listXO : [ItemActivity] = [ItemActivity]()
    var listXNStaticData : [ItemActivity] = [ItemActivity]()
    var listpaksHome : [ItemPark] = [ItemPark]()
    var kerMexNumbeItems : Int!
    var tagClic : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.lblTitle.isHidden = false
        self.lblTitle.font = UIFont.boldSystemFont(ofSize: 24.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInfoView(itemHome: ItemHome){
        self.tagClic = itemHome.idEventFB
        self.lblTitle.text = itemHome.name
        self.lblDescription.text = itemHome.description
        self.listActivities = itemHome.listActivities
        self.listAdmissions = itemHome.listAdmissions
        self.listEvents = itemHome.listEvents
        
        self.listXO = itemHome.listActivities
        
        self.listXNStaticData = itemHome.listActivities
        self.listpaksHome = itemHome.parksHome
        self.heightCollectionViewConstraint.constant = itemHome.heightCV
        self.sizeItem = itemHome.sizeCell
        self.viewTopLine.isHidden = true
        self.viewBottomLine.isHidden = true
        self.bottonConstLine.constant = 0
        if collectionView.tag == 104{
            self.viewTopLine.isHidden = false
            self.viewBottomLine.isHidden = false
            self.bottonConstLine.constant = 15
        }else if collectionView.tag == 106 {
            self.bottonConstLine.constant = 15
        }else if collectionView.tag == 105 {
//            self.topTitleConstraint.constant = 50
        }
        self.collectionView.reloadData()
    }
}

extension ItemActTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func goBookingXV(typeItemBuyXV: String) {
        delegateXV?.goBookingXV(typeItemBuyXV: typeItemBuyXV)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView.tag == 102 {
            count = listAdmissions.count
        }else if collectionView.tag == 103{
            count = listEvents.count
        }else if collectionView.tag == 104{
            count = listXO.count
        }else if collectionView.tag == 106{
            count = kerMexNumbeItems
        }else if collectionView.tag == 107{
            count = listXNStaticData.count
        }else if collectionView.tag == 108{
            count = listActivities.count
        }else if collectionView.tag == 109{
            count = 1
        }else if collectionView.tag == 110{
            count = listpaksHome.count
        }else if collectionView.tag == 111{
            count = listpaksHome.count
        }else{
            count = listActivities.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 101 {
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height))
            imageview.image = UIImage(named: "Parks/XV/bg_actividadesAllInclusive")
            imageview.contentMode = .scaleToFill
            imageview.clipsToBounds = true
            imageview.layer.zPosition = -1
            self.backgroundView = imageview
            lblTitle.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.00)
            lblDescription.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 1.00)
            topTitleConstraint.constant = 30
            topDescriptionConstraint.constant = -10
        }else{
            topTitleConstraint.constant = 14
            lblTitle.textColor = Constants.COLORS.ITEMS_CELLS.titleCell
            lblDescription.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 1.00)
            topDescriptionConstraint.constant = 10
            self.backgroundView = UIImageView()
            contentView.backgroundColor = .white
            if appDelegate.itemParkSelected.code == "XF" {
                lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
                lblDescription.textColor = .white
                contentView.backgroundColor = Constants.COLORS.GENERAL.customDarkMode
            }
            
        }
        
        if collectionView.tag == 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVCircle", for: indexPath as IndexPath) as! ItemCircleCollectionViewCell
            cell.configureCell(itemActivity: listActivities[indexPath.row])
            cell.imgActivity.layer.borderColor = collectionView.tag == 10 ? Constants.COLORS.ITEMS_CELLS.circleRed.cgColor : Constants.COLORS.ITEMS_CELLS.circleYellow.cgColor
            return cell
        }else if collectionView.tag == 102{
            topTitleConstraint.constant = 10
            topDescriptionConstraint.constant = 10
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTipoEntrada", for: indexPath as IndexPath) as! itemEntradaXVCollectionViewCell
            cell.configureCell(itemAdmission: listAdmissions[indexPath.row])
            cell.itemActTableViewCell = self
            return cell
        }else if collectionView.tag == 103{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath as IndexPath) as! ItemLargeCollectionViewCell
            cell.heightViewGradient.constant = cell.imgActivity.frame.height / 2
            cell.configureCell(itemEvent: listEvents[indexPath.row])
            return cell
        }else if collectionView.tag == 104{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellXOKermesMexicana", for: indexPath as IndexPath) as! itemXO_KermesMexicanaCollectionViewCell
            cell.configureCell(itemActivity: listXO[indexPath.row])
            return cell
        }else if collectionView.tag == 105{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellXOMenu", for: indexPath as IndexPath) as! itemXO_FoodCollectionViewCell
            cell.configureCell(itemActivity: listActivities[indexPath.row])
            topTitleConstraint.constant = 20
            topDescriptionConstraint.constant = 0
            return cell
        }else if collectionView.tag == 106{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellXOKermesTour", for: indexPath as IndexPath) as! itemXO_KermesTourCollectionViewCell
            
            if !listXO.isEmpty {
                cell.configureCellIMGS(count: indexPath.row, item: listXO[indexPath.row])
            }
            topDescriptionConstraint.constant = 5
            return cell
        }else if collectionView.tag == 107{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath as IndexPath) as! ItemLargeCollectionViewCell
            cell.heightViewGradient.constant = cell.imgActivity.frame.height / 2
            cell.configureCellXN(itemActivity: listXNStaticData[indexPath.row])
            return cell
        }else if collectionView.tag == 109{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath as IndexPath) as! ItemLargeCollectionViewCell
            cell.heightViewGradient.constant = cell.imgActivity.frame.height / 2
            cell.configureCellXIStatic()
            return cell
        }else if collectionView.tag == 110{
            self.lblTitle.text = ""
            self.lblTitle.isHidden = true
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parkPrefHomeCell", for: indexPath as IndexPath) as! parkPrefHomeCollectionViewCell
            cell.configureCell(itemPark: listpaksHome[indexPath.row])
            return cell
        }else if collectionView.tag == 111{
            self.lblTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.lblTitle.text = "lbl_other_experiences_from".getNameLabel()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parkHomeCell", for: indexPath as IndexPath) as! parkHomeCollectionViewCell
            cell.configureCell(itemPark: listpaksHome[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCVLarge", for: indexPath as IndexPath) as! ItemLargeCollectionViewCell
            cell.heightViewGradient.constant = cell.imgActivity.frame.height / 2
            cell.configureCell(itemActivity: listActivities[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 102{
            delegate?.sendDetailAdmission(admission: listAdmissions[indexPath.row])
        }else{
            if listActivities.count > indexPath.row{
                delegate?.sendDetailActivity(activity: listActivities[indexPath.row], idEvent: tagClic)
            }
            if listEvents.count > indexPath.row{
                delegateXO?.sendDetailBasicActivity(activity: listEvents[indexPath.row], idEvent: tagClic)
            }
            if listpaksHome.count > indexPath.row{
                delegateHome?.sendItemPark(itemPark: listpaksHome[indexPath.row])
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeItem
    }
    
}
