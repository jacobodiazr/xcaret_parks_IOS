//
//  ItemDetailActivityTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/21/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemDetailActivityTableViewCell: UITableViewCell {
    weak var delegate : GoRouteMapDelegate!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblIsInclude: UILabel!
    @IBOutlet weak var lblTitleSchedule: UILabel!
    @IBOutlet weak var collSchedule: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collNotes: UICollectionView!
    @IBOutlet weak var viewSegmentControll: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var txtViewSegmentControl: UITextView!
    @IBOutlet weak var btnFavorite: FavoriteSimpleButton!
    @IBOutlet weak var btnGo: GoButton!
    @IBOutlet weak var btnCallCenter: UIButton!
    @IBOutlet weak var viewContentDetailAct: UIView!
    @IBOutlet weak var viewLineSeparador: UIView!
    let buttonBar = UIView()
    var itemActivity = ItemActivity()
    var colorBack = UIColor()
    //var tagClicFav : TagsClicTo!
    
    //Constraints
    @IBOutlet weak var toplblDescriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSegmentControl: NSLayoutConstraint!
    @IBOutlet weak var topButtonReserv: NSLayoutConstraint!
    var newTopButtonReserv: CGFloat = 0
    var textScheduleDuration : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        if appDelegate.itemParkSelected.code == "XF" {
            lblTitle.textColor = Constants.COLORS.GENERAL.customRedDarkModeXF
            lblDescription.textColor = .white
            txtViewSegmentControl.textColor = .white
            lblTitleSchedule.textColor = .white
            lblCategory.textColor = .white
            btnFavorite.backgroundColor = .clear
            viewLineSeparador.backgroundColor = Constants.COLORS.GENERAL.customRedDarkModeXF
            btnFavorite.tintColor = .white
        }else{
            lblTitle.textColor = Constants.COLORS.ITEMS_CELLS.titleCell
            lblCategory.textColor = Constants.COLORS.ITEMS_CELLS.titleCell
            viewLineSeparador.backgroundColor = Constants.COLORS.GENERAL.customRedDarkModeXF
        }
        viewContentDetailAct.backgroundColor = colorBack
        viewSegmentControll.backgroundColor = colorBack
        if #available(iOS 13, *) {
            segmentControl.setOldLayout(tintColor: colorBack)
        }else{
            self.segmentControl.backgroundColor = colorBack
            self.segmentControl.tintColor = colorBack
        }
        
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabInactive], for: .normal)
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Constants.COLORS.ITEMS_CELLS.tabActive], for: .selected)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = Constants.COLORS.ITEMS_CELLS.tabActiveOutline
        viewSegmentControll.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments)).isActive = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        //Config de collection horarios
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        self.collSchedule.collectionViewLayout = flowLayout
        self.collSchedule.showsHorizontalScrollIndicator = false
        
        let flowLayoutNotes = UICollectionViewFlowLayout()
        flowLayoutNotes.scrollDirection = .horizontal
        flowLayoutNotes.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayoutNotes.minimumLineSpacing = 5.0
        flowLayoutNotes.minimumInteritemSpacing = 5.0
        self.collNotes.collectionViewLayout = flowLayoutNotes
        self.collNotes.showsHorizontalScrollIndicator = false
        
        
    }
    
    func setInformation(itemActivity: ItemActivity, isReload: Bool){
        self.itemActivity = itemActivity
        self.textScheduleDuration = ""
        self.lblRoute.text = ""
        segmentControl.setTitle("lbl_warnings".getNameLabel()/*"lblWarnings".localized()*/, forSegmentAt: 0)
        segmentControl.setTitle("lbl_restrictions".getNameLabel()/*"lblRestrictions".localized()*/, forSegmentAt: 1)
        
        //Mostramos todos los elementos
        self.btnCallCenter.isHidden = false
        self.lblTitleSchedule.isHidden = false
        self.collSchedule.isHidden = false
        self.collNotes.isHidden = false
        self.btnCallCenter.setTitle("lbl_call_center".getNameLabel().uppercased(), for: .normal)//("lblCallCenter".localized().uppercased(), for: .normal)
        self.textScheduleDuration = "\("lbl_schedules".getNameLabel()/*"lblSchedule".localized()*/)"
        if !itemActivity.act_duration.isEmpty{
            self.textScheduleDuration += " / \("lbl_duration".getNameLabel()/*"lblDuration".localized()*/): \(itemActivity.act_duration.dropLast())"
        }
        self.lblTitleSchedule.text = self.textScheduleDuration
        
        lblTitle.text = itemActivity.details.name
        if itemActivity.category.cat_code == "REST"{
            lblCategory.text = itemActivity.getSubcategory.name
        }else{
            lblCategory.text = itemActivity.getCategory.name
        }
        if !itemActivity.getRoute.name.isEmpty && !itemActivity.getRoute.color.isEmpty{
            lblRoute.text = "\(itemActivity.getRoute.name) (\(itemActivity.getRoute.color))"
        }
        btnFavorite.uid = itemActivity.uid
        btnFavorite.name = itemActivity.nameES
        //btnFavorite.viewClicFav = tag
        btnGo.itemActivity = itemActivity
        
        if itemActivity.act_aditionalCost {
            self.lblIsInclude.text = "lbl_not_include".getNameLabel()//"lblNotInclude".localized()
            self.lblIsInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleNotInclude
            
        }else{
            self.lblIsInclude.text = "lbl_include".getNameLabel()//"lblInclude".localized()
            self.lblIsInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleInclude
            
        }
        if appDelegate.itemParkSelected.code == "XV" {
            if itemActivity.category.cat_code == "BASIC" {
                self.lblIsInclude.text = "xv_lbl_include_basic".getNameLabel()
            }else if itemActivity.category.cat_code == "XTREME"{
                self.lblIsInclude.text = "xv_lbl_lnclude_all_inclusive".getNameLabel()
            }
            self.lblIsInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleInclude
        }
        
        if itemActivity.category.cat_code == "AEXT" {
            self.btnCallCenter.isHidden = false
            newTopButtonReserv = 20
        }else{
            self.btnCallCenter.isHidden = true
            newTopButtonReserv = -40
        }
        
        var textDescription: String = ""
        if !itemActivity.details.include.isEmpty{
            textDescription = "\(itemActivity.details.description ?? "")\n\n\(itemActivity.details.include ?? "")"
        }else{
            textDescription = itemActivity.details.description
        }
        lblDescription.text = textDescription
        
        if itemActivity.listSchedules.count > 0 {
            if !isReload {
                collSchedule.delegate = self
                collSchedule.dataSource = self
            }else{
                collSchedule.reloadData()
                self.toplblDescriptionConstraint.constant = 10
            }
        }else{
            self.lblTitleSchedule.isHidden = true
            self.collSchedule.isHidden = true
            self.toplblDescriptionConstraint.constant = -70
        }
        
        if itemActivity.listNotes.count > 0 {
            if !isReload {
                self.collNotes.delegate = self
                self.collNotes.dataSource = self
            }else{
                self.collNotes.reloadData()
            }
            
        }else{
            self.collNotes.isHidden = true
            self.topSegmentControl.constant = -120
        }
        
        if !itemActivity.details.warning.isEmpty || !itemActivity.getRestrictions.isEmpty {
            if !itemActivity.details.warning.isEmpty {
                self.txtViewSegmentControl.text = itemActivity.details.warning
            }else{
                self.txtViewSegmentControl.text = "-"
            }
        }else{
            self.viewSegmentControll.isHidden = true
            self.txtViewSegmentControl.isHidden = true
            self.newTopButtonReserv = newTopButtonReserv + ( -220)
        }
        self.topButtonReserv.constant = newTopButtonReserv
        
        //Validamos que si XA no muestre mapa ni favoritos
        if appDelegate.itemParkSelected.code == "XA" || appDelegate.itemParkSelected.code == "FE"{
            self.btnGo.isHidden = true
            self.btnFavorite.isHidden = true
        }
    }
    
    @IBAction func btnCallCenter(_ sender: UIButton) {
        //Tools.shared.callNumber(number: "9841792605")
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.callNow.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_callNow": true]
        (AppDelegate.getKruxTracker()).trackPageView("ActivityDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
    }
    
    @IBAction func btnSendMap(_ sender: GoButton) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ActivityDetail.rawValue, title: TagsID.showLocation.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_showLocation": true]
        (AppDelegate.getKruxTracker()).trackPageView("ActivityDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        delegate.goToMap(activity: sender.itemActivity)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentControl.frame.width / CGFloat(self.segmentControl.numberOfSegments)) * CGFloat(self.segmentControl.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            txtViewSegmentControl.text = !itemActivity.details.warning.isEmpty ? itemActivity.details.warning : "-"
        default:
            txtViewSegmentControl.text = !itemActivity.getRestrictions.isEmpty ? itemActivity.getRestrictions : "-"
        }
    }
}

extension ItemDetailActivityTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collSchedule {
            return itemActivity.listSchedules.count
        }else if collectionView == collNotes {
            return itemActivity.listNotes.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collSchedule {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSchedule", for: indexPath) as! ItemScheduleCollectionViewCell
            cell.configureCell(schedule: itemActivity.listSchedules[indexPath.row].s_time)
            return cell
        }else if collectionView == collNotes{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNote", for: indexPath) as! ItemNoteCollectionViewCell
            let aux = itemActivity.listNotes[indexPath.row]
            cell.configureCell(note: itemActivity.listNotes[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNote", for: indexPath) as! ItemNoteCollectionViewCell
            cell.configureCell(note: itemActivity.listNotes[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collSchedule{
            if itemActivity.listSchedules[indexPath.row].s_time.contains("-"){
               return CGSize(width: 180, height: 40)
            }else{
                return CGSize(width: 100, height: 40)
            }
            
        }else if collectionView == collNotes {
            return CGSize(width: 100, height: 110)
        }else {
            return CGSize(width: 120, height: 130)
        }
    }
}
